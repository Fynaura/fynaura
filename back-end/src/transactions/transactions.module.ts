/* eslint-disable prettier/prettier */


import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { TransactionsController } from './transactions.controller';
import { TransactionsService } from './transactions.service';
import { Transaction, TransactionSchema } from './schemas/transaction.schema';


// import { DatabaseModule } from 'src/database/database.module';


@Module({
    imports: [
     MongooseModule.forFeature([
        {
          name: Transaction.name,
          schema: TransactionSchema,
        },  
        
     ])
    ],
    controllers: [TransactionsController],
    providers: [TransactionsService]
})
export class TransactionsModule {}
