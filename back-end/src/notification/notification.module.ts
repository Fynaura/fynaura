/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { Goal, GoalSchema } from '../goal-oriented-savings/schema/goal.schema';

import { GoalService } from '../goal-oriented-savings/goal.service';
import { NotificationService } from './notification.service';
import { NotificationController } from './notification.controller';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Goal.name, schema: GoalSchema }]),
    
  ],
  controllers: [NotificationController],
  providers: [NotificationService, GoalService],
  exports: [NotificationService],
})
export class GoalNotificationModule {}