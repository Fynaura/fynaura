/* eslint-disable prettier/prettier */


import { Body, Get, HttpCode, Param, Post } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { CreateTransactionDto } from './dto/create-transaction.dto';
import { TransactionsService } from './transactions.service';

@Controller('transaction')
export class TransactionsController {
  constructor(private readonly transactionService: TransactionsService) { }

  @Post()
  create(@Body() createTransactionDto: CreateTransactionDto) {
    console.log("✅ New transaction received:", createTransactionDto);
    return this.transactionService.create(createTransactionDto);
  }

  @Get(':userId')
  async getTransactionsByUserId(@Param('userId') userId: string) {
    return this.transactionService.findByUserId(userId);
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
  @HttpCode(200)
  async createBulk(@Body() bulkTransactions: CreateTransactionDto[]) {
    console.log(`✅ Received ${bulkTransactions.length} transactions`);
    return await this.transactionService.createBulk(bulkTransactions);
  }

  @Get('total-income/:userId')
  async getTotalIncome(@Param('userId') userId: string) {
    const totalIncome = await this.transactionService.getTotalIncomeForUser(userId);
    return {
      userId,
      totalIncome
    };

  }

  @Get('total-expense/:userId')
  async getTotalExpense(@Param('userId') userId: string) {
    const totalExpense = await this.transactionService.getTotalExpenseForUser(userId);
    return {
      userId,
      totalExpense
    };
  }






}



