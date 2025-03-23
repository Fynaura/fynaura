/* eslint-disable @typescript-eslint/no-unsafe-return */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable prettier/prettier */
import { Injectable, HttpStatus } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateTransactionDto } from './dto/create-transaction.dto';
import { Transaction } from './schemas/transaction.schema';
import * as moment from 'moment';
import { TransactionDTO } from './entity/transaction.entity'; // Assuming this is the correct path for your DTO

@Injectable()
export class TransactionsService {
  constructor(
    @InjectModel(Transaction.name)
    private readonly transactionModel: Model<Transaction>,
  ) {}

  async create(
    createTransactionDto: CreateTransactionDto,
  ): Promise<Transaction> {
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
    return await this.transactionModel.find();
  }

  private getDateRange(period: string): { start: Date; end: Date } {
    const now = moment();

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
    const now = new Date();
    const last24Hours = new Date(now.getTime() - 24 * 60 * 60 * 1000); // 24 hours ago

    // Fetch transactions from the last 24 hours
    const transactions = await this.transactionModel
      .find({ date: { $gte: last24Hours } })
      .sort({ date: 1 }) // Sort by date ascending
      .exec();

    // Initialize an array to hold the balance data for each hour
    const hourlyBalances = Array(24).fill(0); // There are 24 hours in a day, initialize with 0 balance

    // Iterate through the transactions to calculate the running balance for each hour
    transactions.forEach((transaction) => {
      const hour = transaction.date.getHours(); // Get the hour of the transaction

      if (transaction.type === 'income') {
        hourlyBalances[hour] += transaction.amount; // Add amount for 'income'
      } else if (transaction.type === 'expense') {
        hourlyBalances[hour] -= transaction.amount; // Subtract amount for 'expense'
      }
    });

    // Calculate running balance for each hour
    let cumulativeBalance = 0;
    const balanceHistory: TransactionDTO[] = hourlyBalances.map(
      (balance, index) => {
        cumulativeBalance += balance; // Update cumulative balance

        // Create the DTO for the current hour, with the required missing properties
        return {
          timestamp: new Date(
            now.getFullYear(),
            now.getMonth(),
            now.getDate(),
            index,
          ), // Hourly timestamp
          balance: cumulativeBalance, // Running balance
          amount: balance, // Amount of transactions for this hour
          type: balance >= 0 ? 'income' : 'expense', // Just an indicator for type (can be customized)
          category: 'N/A', // Placeholder, you can modify as necessary
          description: 'Hourly balance update', // Placeholder description
          date: new Date(
            now.getFullYear(),
            now.getMonth(),
            now.getDate(),
            index,
          ), // Add the missing 'date' field
          reminder: false, // Add the missing 'reminder' field, you can set this to false or adjust as needed
          userId: 'N/A', // Placeholder, you can modify as necessary
        };
      },
    );

    return balanceHistory;
  }

  async createBulk(
    bulkTransactions: CreateTransactionDto[],
  ): Promise<{ status: number; message: string }> {
    try {
      // Insert bulk transactions into the database
      await this.transactionModel.insertMany(bulkTransactions);

      // Return 200 status code and a success message
      return {
        status: HttpStatus.OK,
        message: 'Bulk transactions created successfully',
      };
    } catch (error) {
      // Handle error and return a 500 status code for internal server error
      return {
        status: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Error creating bulk transactions',
      };
    }
  }
  // Method to retrieve transactions based on userId
  async findByUserId(userId: string): Promise<Transaction[]> {
    return this.transactionModel.find({ userId }).exec();
  }

  async getTotalIncomeForUser(userId: string): Promise<number> {
    const transactions = await this.transactionModel
      .find({
        userId: userId,
        type: 'income',
      })
      .exec();

    const totalIncome = transactions.reduce(
      (acc, transaction) => acc + transaction.amount,
      0,
    );
    return totalIncome;
  }

  async getTotalExpenseForUser(userId: string): Promise<number> {
    const transactions = await this.transactionModel
      .find({
        userId: userId,
        type: 'expense',
      })
      .exec();

    const totalExpense = transactions.reduce(
      (acc, transaction) => acc + transaction.amount,
      0,
    );
    return totalExpense;
  }
}
