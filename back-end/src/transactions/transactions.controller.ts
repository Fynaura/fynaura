/* eslint-disable prettier/prettier */


import { Body, Get, Post } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { CreateTransactionDto } from './dto/create-transaction.dto';
import { TransactionsService } from './transactions.service';

@Controller('transaction')
export class TransactionsController {
  constructor(private readonly transactionService: TransactionsService) {}

  @Post()
  create(@Body() createTransactionDto: CreateTransactionDto) {
    console.log("✅ New transaction received:", createTransactionDto);
    return this.transactionService.create(createTransactionDto);
  }

  @Get()
  findAll() {
    return this.transactionService.findAll();
  }

  @Get()
  async getTransactions() {
    return await this.transactionService.getAllTransactions();
  }


  @Get('hourly-balance')
  async getHourlyBalance() {
    return await this.transactionService.getHourlyBalanceForLast24Hours();
  }

    @Post('bulk')
  async createBulk(@Body() bulkTransactions: CreateTransactionDto[]) {
    console.log(`✅ Received ${bulkTransactions.length} transactions`);
    return await this.transactionService.createBulk(bulkTransactions);
  }
  
  


}



