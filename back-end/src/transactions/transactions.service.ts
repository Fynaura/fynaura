
/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';


import { CreateTransactionDto } from './dto/create-transaction.dto';
import { Model } from 'mongoose';
import { Transaction } from './schemas/transaction.schema';

// import { UpdateTransactionDto } from './dto/update-transaction.dto';

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

//   async findOne(id: string): Promise<Transaction> {
//     return this.transactionModel.findById(id).exec();
//   }

//   async update(id: string, updateTransactionDto: UpdateTransactionDto): Promise<Transaction> {
//     return this.transactionModel
//       .findByIdAndUpdate(id, updateTransactionDto, { new: true })
//       .exec();
//   }

//   async remove(id: string): Promise<Transaction> {
//     return this.transactionModel.findByIdAndDelete(id).exec();
//   }
}

