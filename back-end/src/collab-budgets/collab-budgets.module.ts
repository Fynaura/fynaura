/* eslint-disable prettier/prettier */

import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { CollabBudgetsService } from './collab-budgets.service';
import { CollabBudgetsController } from './collab-budgets.controller';
import { Budget, BudgetSchema } from './schema/budget.schema';
import { UserModule } from '../user/user.module';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Budget.name, schema: BudgetSchema }]),
    UserModule,
  ],
  controllers: [CollabBudgetsController],
  providers: [CollabBudgetsService],
})
export class CollabBudgetsModule {}
