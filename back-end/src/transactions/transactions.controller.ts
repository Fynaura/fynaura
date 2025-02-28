/* eslint-disable prettier/prettier */

import {
    Controller,
    Get,
    Post,
    Body,
    UseGuards,
  } from '@nestjs/common';

import { TransactionsService } from './transactions.service';
import { CreateTransactionDto } from './dto/create-transaction.dto';
//import { Public } from '../decorators/public.decorator';
import { ClerkAuthGuard } from '../auth/clerk-auth.guard';
  
  @Controller('transaction')
  export class TransactionsController {
    constructor(private readonly transactionService: TransactionsService) {}
  
    @Post()
    create(@Body() createTransactionDto: CreateTransactionDto) {
      return this.transactionService.create(createTransactionDto);
    }
  
    @UseGuards(ClerkAuthGuard)
    @Get() 
    findAll() {
      return this.transactionService.findAll();
    }
  }
