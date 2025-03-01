import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CollabBudgetsController } from './collab-budgets.controller';
import { CollabBudgetsService } from './collab-budgets.service';
import { CollabBudget } from './entity/collabBudget.entity';

@Module({
  imports: [TypeOrmModule.forFeature([CollabBudget])],
  controllers: [CollabBudgetsController],
  providers: [CollabBudgetsService],
  exports: [CollabBudgetsService],
})
export class CollabBudgetsModule {}
