/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Goal, GoalSchema } from '../goal-oriented-savings/schema/goal.schema';
import { GoalNotificationService } from './notification.service';
import { GoalNotificationController } from './notification.controller';
import { GoalService } from '../goal-oriented-savings/goal.service';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Goal.name, schema: GoalSchema }]),
    
  ],
  controllers: [GoalNotificationController],
  providers: [GoalNotificationService, GoalService],
  exports: [GoalNotificationService],
})
export class GoalNotificationModule {}