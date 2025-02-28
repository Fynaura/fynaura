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
import { TransactionsController } from './transactions/transactions.controller';
import { TransactionsService } from './transactions/transactions.service';


// import { ClerkClientProvider } from './providers/clerk-client.provider';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),

    TransactionsModule,
    BudgetsModule,
    DatabaseModule,
    UsersModule
  ],
  controllers: [AppController, TransactionsController],
  providers: [
    AppService,
    
    

    TransactionsService,
  ],
})
export class AppModule {}
