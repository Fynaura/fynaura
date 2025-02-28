/* eslint-disable prettier/prettier */
import {
    Inject,
    Injectable
  } from '@nestjs/common';
  import {
    InjectModel
  } from '@nestjs/mongoose';
  import {
    Model
  } from 'mongoose';
  

//   import {
//     UpdateEmployeeDto
//   } from './dto/update-employee.dto';

import { Transaction, transactionDocument } from './schemas/transaction.schema';
import { CreateTransactionDto } from './dto/create-transaction.dto';
  
  @Injectable()
  export class TransactionsService {
  
    constructor(@InjectModel(Transaction.name) private readonly transactionModel: Model < transactionDocument >,
    @Inject('DATABASE_CONNECTION') private databaseConnection: any,
) {}
  
    async create(CreateTransactionDto: CreateTransactionDto): Promise < transactionDocument > {
      const employee = new this.transactionModel(CreateTransactionDto);
      return employee.save();
    }
  
    async findAll(): Promise < transactionDocument[] > {
      return this.transactionModel.find()
        .exec();
    }
  
//     async findOne(id: string) {
//       return this.employeeModel.findById(id);
//     }
  
//     async update(id: string, updateEmployeeDto: UpdateEmployeeDto): Promise < EmployeeDocument > {
//       return this.employeeModel.findByIdAndUpdate(id, updateEmployeeDto);
//     }
  
//     async remove(id: string) {
//       return this.employeeModel.findByIdAndRemove(id);
//     }
   }