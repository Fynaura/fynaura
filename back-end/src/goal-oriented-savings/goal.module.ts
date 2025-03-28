/* eslint-disable prettier/prettier */
import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';  // Import MongooseModule
import { GoalController } from './goal.controller';  // Import GoalController
import { GoalService } from './goal.service';  // Import GoalService
import { Goal, GoalSchema } from './schema/goal.schema';
  // Import Goal schema

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Goal.name, schema: GoalSchema }]),  // Register Goal schema with Mongoose
  ],
  controllers: [GoalController],  // Register GoalController
  providers: [GoalService],  // Register GoalService
})
export class GoalModule {}
