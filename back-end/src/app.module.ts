/* eslint-disable prettier/prettier */


import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { ConfigModule } from '@nestjs/config';
// import { ClerkClientProvider } from './providers/clerk-client.provider';
import { UserModule } from './user/user.module';



import { DatabaseModule } from './database/database.module';

import { BudgetsModule } from './budgets/budgets.module';
import { TransactionsModule } from './transactions/transactions.module';


import { CollabBudgetsModule } from './collab-budgets/collab-budgets.module';

import { MongooseModule } from '@nestjs/mongoose';


import { AppService } from './app.service';
import { AuthGuard } from './guard/auth.guard';







// import { ClerkClientProvider } from './providers/clerk-client.provider';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),


    MongooseModule.forRoot(
      process.env.MONGODB_URI || 'mongodb://localhost:27017/defaultdb',
    ),

 
    BudgetsModule,
    DatabaseModule,

    // Remove individual registrations of Transactions
    TransactionsModule,
    CollabBudgetsModule,
    UserModule,
    
  ],
  controllers: [AppController],
  providers: [AppService, AuthGuard],


})
export class AppModule {}
