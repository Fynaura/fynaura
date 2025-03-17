/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateTransactionDto } from './dto/create-transaction.dto';
import { Transaction } from './schemas/transaction.schema';
import { TransactionDTO } from './entity/transaction.entity'; // Assuming this is the correct path for your DTO

@Injectable()
export class TransactionsService {
  constructor(
    @InjectModel(Transaction.name)
    private readonly transactionModel: Model<Transaction>,
  ) {}

  async create(createTransactionDto: CreateTransactionDto): Promise<Transaction> {
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
    const balanceHistory: TransactionDTO[] = hourlyBalances.map((balance, index) => {
      cumulativeBalance += balance; // Update cumulative balance
  
      // Create the DTO for the current hour, with the required missing properties
      return {
        timestamp: new Date(now.getFullYear(), now.getMonth(), now.getDate(), index), // Hourly timestamp
        balance: cumulativeBalance,  // Running balance
        amount: balance,  // Amount of transactions for this hour
        type: balance >= 0 ? 'income' : 'expense',  // Just an indicator for type (can be customized)
        category: 'N/A', // Placeholder, you can modify as necessary
        description: 'Hourly balance update', // Placeholder description
        date: new Date(now.getFullYear(), now.getMonth(), now.getDate(), index), // Add the missing 'date' field
        reminder: false, // Add the missing 'reminder' field, you can set this to false or adjust as needed
      };
    });
  
    return balanceHistory;
  }
  
  async createBulk(bulkTransactions: CreateTransactionDto[]): Promise<Transaction[]> {
    return this.transactionModel.insertMany(bulkTransactions);
  }
  
}
