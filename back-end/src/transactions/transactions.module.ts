/* eslint-disable prettier/prettier */

/* eslint-disable prettier/prettier */
import {
    Module
  } from '@nestjs/common';
  import {
    MongooseModule
  } from '@nestjs/mongoose';
import { Transaction, TransactionSchema } from './schemas/transaction.schema';
import { TransactionsController } from './transactions.controller';
import { TransactionsService } from './transactions.service';
import { DatabaseModule } from '../database/database.module';

  @Module({
    imports: [
     MongooseModule.forFeature([
        {
          name: Transaction.name,
          schema: TransactionSchema
        },
     ]),
     DatabaseModule
    ],
    controllers: [TransactionsController],
    providers: [TransactionsService]
  })
  export class TransactionsModule {}