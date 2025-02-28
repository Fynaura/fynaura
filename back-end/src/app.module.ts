/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ConfigModule } from '@nestjs/config';
// import { ClerkClientProvider } from './providers/clerk-client.provider';

import { UsersModule } from './users/users.module';
import { DatabaseModule } from './database/database.module';

import { BudgetsModule } from './budgets/budgets.module';
import { TransactionsModule } from './transactions/transactions.module';

import { MongooseModule } from '@nestjs/mongoose';




// import { ClerkClientProvider } from './providers/clerk-client.provider';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),

    MongooseModule.forRoot(process.env.MONGODB_URI || 'mongodb://localhost:27017/defaultdb'),
    
    
  
    TransactionsModule,
    BudgetsModule,
    DatabaseModule,
    UsersModule
  ],
  controllers: [AppController],
  providers: [
    AppService,


    
  ],
})
export class AppModule {}