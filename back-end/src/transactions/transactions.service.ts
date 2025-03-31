/* eslint-disable prettier/prettier */
import { Injectable, HttpStatus } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateTransactionDto } from './dto/create-transaction.dto';
import { Transaction } from './schemas/transaction.schema';
import * as moment from 'moment-timezone';
import { TransactionDTO } from './entity/transaction.entity';

// Define Sri Lanka timezone
const SRI_LANKA_TIMEZONE = 'Asia/Colombo';

@Injectable()
export class TransactionsService {
  constructor(
    @InjectModel(Transaction.name)
    private readonly transactionModel: Model<Transaction>,
  ) { }

  async create(createTransactionDto: CreateTransactionDto): Promise<Transaction> {
    // Convert the date from local time to UTC for storage
    if (createTransactionDto.date) {
      // Parse the date as Sri Lanka time and convert to UTC for storage
      const sriLankaDate = moment.tz(createTransactionDto.date, SRI_LANKA_TIMEZONE);
      createTransactionDto.date = sriLankaDate.toDate();
    }
    
    const newTransaction = new this.transactionModel(createTransactionDto);
    return newTransaction.save();
  }

  async findAll(): Promise<Transaction[]> {
    return this.transactionModel.find().exec();
  }

  async findByType(type: 'income' | 'expense'): Promise<Transaction[]> {
    return this.transactionModel.find({ type }).exec();
  }

  async getAllTransactions(): Promise<Transaction[]> {
    const transactions = await this.transactionModel.find();
    
    // Convert dates from UTC to Sri Lanka time zone for display
    return transactions.map(transaction => {
      const sriLankaDate = moment.utc(transaction.date).tz(SRI_LANKA_TIMEZONE);
      return {
        ...transaction.toObject(),
        date: sriLankaDate.toDate(),
      };
    });
  }

  private getDateRange(period: string): { start: Date; end: Date } {
    // Create a moment object in Sri Lanka timezone
    const now = moment().tz(SRI_LANKA_TIMEZONE);

    if (period === 'today') {
      return {
        start: now.startOf('day').toDate(),
        end: now.endOf('day').toDate(),
      };
    } else if (period === 'week') {
      return {
        start: now.startOf('week').toDate(),
        end: now.endOf('week').toDate(),
      };
    } else if (period === 'month') {
      return {
        start: now.startOf('month').toDate(),
        end: now.endOf('month').toDate(),
      };
    }
    throw new Error('Invalid period');
  }

  async getTotalExpense(uid: string, period: string): Promise<number> {
    const { start, end } = this.getDateRange(period);

    const expense = await this.transactionModel.aggregate([
      {
        $match: {
          userId: uid,
          type: 'expense', // Filtering for expense transactions
          date: { $gte: start, $lte: end },
        },
      },
      {
        $group: {
          _id: null,
          totalExpense: { $sum: '$amount' }, // Summing up the amount for the total expense
        },
      },
    ]);

    return expense.length > 0 ? expense[0].totalExpense : 0;
  }

  // Function to fetch the total income for the specified period
  async getTotalIncome(uid: string, period: string): Promise<number> {
    const { start, end } = this.getDateRange(period);

    const income = await this.transactionModel.aggregate([
      {
        $match: {
          userId: uid,
          type: 'income', // Filtering for income transactions
          date: { $gte: start, $lte: end },
        },
      },
      {
        $group: {
          _id: null,
          totalIncome: { $sum: '$amount' }, // Summing up the amount for the total income
        },
      },
    ]);

    return income.length > 0 ? income[0].totalIncome : 0;
  }

  // Method to get the balance for every hour in the last 24 hours
  async getHourlyBalanceForLast24Hours(): Promise<TransactionDTO[]> {
    // Get current time in Sri Lanka timezone
    const now = moment().tz(SRI_LANKA_TIMEZONE);
    const last24Hours = moment(now).subtract(24, 'hours').toDate();

    // Fetch transactions from the last 24 hours
    const transactions = await this.transactionModel
      .find({ date: { $gte: last24Hours } })
      .sort({ date: 1 }) // Sort by date ascending
      .exec();

    // Initialize an array to hold the balance data for each hour
    const hourlyBalances = Array(24).fill(0); // 24 hours in a day, initialize with 0 balance

    // Convert transactions to Sri Lanka time and calculate hourly balances
    transactions.forEach((transaction) => {
      // Convert transaction date to Sri Lanka time
      const txDate = moment.utc(transaction.date).tz(SRI_LANKA_TIMEZONE);
      const hour = txDate.hour(); // Get hour in Sri Lanka time

      if (transaction.type === 'income') {
        hourlyBalances[hour] += transaction.amount; // Add amount for 'income'
      } else if (transaction.type === 'expense') {
        hourlyBalances[hour] -= transaction.amount; // Subtract amount for 'expense'
      }
    });

    // Calculate running balance for each hour
    let cumulativeBalance = 0;
    const balanceHistory: TransactionDTO[] = hourlyBalances.map((balance, index) => {
      cumulativeBalance += balance; // Update cumulative balance

      // Create timestamp for this hour in Sri Lanka time
      const hourTimestamp = moment(now)
        .hour(index)
        .minute(0)
        .second(0)
        .millisecond(0);

      // Create the DTO for the current hour
      return {
        timestamp: hourTimestamp.toDate(), // Hourly timestamp in Sri Lanka time
        balance: cumulativeBalance,  // Running balance
        amount: balance,  // Amount of transactions for this hour
        type: balance >= 0 ? 'income' : 'expense',  // Just an indicator for type
        category: 'N/A', // Placeholder
        description: 'Hourly balance update', // Placeholder description
        date: hourTimestamp.toDate(), // Date field in Sri Lanka time
        reminder: false, 
        userId: 'N/A', // Placeholder
      };
    });

    return balanceHistory;
  }

  async createBulk(bulkTransactions: CreateTransactionDto[]): Promise<{ status: number, message: string }> {
    try {
      // Convert each transaction's date to UTC for storage
      const processedTransactions = bulkTransactions.map(transaction => {
        if (transaction.date) {
          // Parse the date as Sri Lanka time and convert to UTC for storage
          const sriLankaDate = moment.tz(transaction.date, SRI_LANKA_TIMEZONE);
          return {
            ...transaction,
            date: sriLankaDate.toDate()
          };
        }
        return transaction;
      });
      
      // Insert bulk transactions into the database
      await this.transactionModel.insertMany(processedTransactions);

      // Return 200 status code and a success message
      return { status: HttpStatus.OK, message: 'Bulk transactions created successfully' };
    } catch (error) {
      // Handle error and return a 500 status code for internal server error
      console.error('Error creating bulk transactions:', error);
      return { status: HttpStatus.INTERNAL_SERVER_ERROR, message: 'Error creating bulk transactions' };
    }
  }

  // Method to retrieve transactions based on userId
  async findByUserId(userId: string): Promise<Transaction[]> {
    const transactions = await this.transactionModel.find({ userId }).exec();
    
    // Convert dates from UTC to Sri Lanka time zone for display
    return transactions.map(transaction => {
      const sriLankaDate = moment.utc(transaction.date).tz(SRI_LANKA_TIMEZONE);
      return {
        ...transaction.toObject(),
        date: sriLankaDate.toDate(),
      };
    });
  }

  async getTotalIncomeForUser(userId: string): Promise<number> {
    const transactions = await this.transactionModel.find({
      userId: userId,
      type: 'income'
    }).exec();

    const totalIncome = transactions.reduce((acc, transaction) => acc + transaction.amount, 0);
    return totalIncome;
  }

  async getTotalExpenseForUser(userId: string): Promise<number> {
    const transactions = await this.transactionModel.find({ 
      userId: userId, 
      type: 'expense' 
    }).exec();
    
    const totalExpense = transactions.reduce((acc, transaction) => acc + transaction.amount, 0);
    return totalExpense;
  }
}