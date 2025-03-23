/* eslint-disable prettier/prettier */


import { Body, Get, HttpCode, Param, Post } from '@nestjs/common';
import { Controller } from '@nestjs/common';
import { CreateTransactionDto } from './dto/create-transaction.dto';
import { TransactionsService } from './transactions.service';

@Controller('transaction')
export class TransactionsController {
  constructor(private readonly transactionService: TransactionsService) { }


  /**
   * Get total income for the specified period (today, week, month)
   */
  @Get('total-income/:uid/:period')
  async getTotalIncome(
    @Param('uid') uid: string,
    @Param('period') period: string
  ) {
    const totalIncome = await this.transactionService.getTotalIncome(uid, period);
    return { totalIncome };
  }

  /**
   * Get total expense for the specified period (today, week, month)
   */
  @Get('total-expense/:uid/:period')
  async getTotalExpense(
    @Param('uid') uid: string,
    @Param('period') period: string
  ) {
    const totalExpense = await this.transactionService.getTotalExpense(uid, period);
    return { totalExpense };
  }

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
    console.log(bulkTransactions)
    return await this.transactionService.createBulk(bulkTransactions);
  }

  // @Get('total-income/:userId')
  // async getTotalIncome(@Param('userId') userId: string) {
  //   console.log("api called");
  //   const totalIncome = await this.transactionService.getTotalIncomeForUser(userId);
  //   return {
  //     userId,
  //     totalIncome
  //   };

  // }

  // @Get('total-expense/:userId')
  // async getTotalExpense(@Param('userId') userId: string) {
  //   console.log("api called");
  //   const totalExpense = await this.transactionService.getTotalExpenseForUser(userId);
  //   return {
  //     userId,
  //     totalExpense
  //   };
  // }






}



