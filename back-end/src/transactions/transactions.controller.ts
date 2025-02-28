/* eslint-disable prettier/prettier */

import {
    Controller,
    Get,
    Post,
    Body,
  } from '@nestjs/common';

import { TransactionsService } from './transactions.service';
import { CreateTransactionDto } from './dto/create-transaction.dto';
  
  @Controller('transaction')
  export class TransactionsController {
    constructor(private readonly transactionService: TransactionsService) {}
  
    @Post()
    create(@Body() createTransactionDto: CreateTransactionDto) {
      return this.transactionService.create(createTransactionDto);
    }
  
    @Get()
    findAll() {
      return this.transactionService.findAll();
    }
  }
