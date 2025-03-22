/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateGoalDto, UpdateGoalDto } from './dto/goal.dto';
import { Goal, GoalDocument } from './schema/goal.schema';

@Injectable()
export class GoalService {
  constructor(
    @InjectModel(Goal.name) private goalModel: Model<GoalDocument>,
  ) { }

  // Create a new goal
  async create(createGoalDto: CreateGoalDto): Promise<Goal> {
    const newGoal = new this.goalModel(createGoalDto);
    return await newGoal.save(); // Return the goal after saving it
  }

  async findAll(): Promise<Goal[]> {
    return this.goalModel.find().exec();
  }

  // Find all goals for a specific user
  async findByUserId(userId: string): Promise<Goal[]> {
    return this.goalModel.find({ userId }).exec(); // Filter goals by userId
  }
  // // Find all goals for a specific user
  // async findAll(userId: string): Promise<Goal[]> {
  //   return this.goalModel.find({ userId }).exec();
  // }

  // Find a goal by ID
  async findOne(id: string): Promise<Goal | null> {
    return this.goalModel.findById(id).exec();
  }

  // Update an existing goal
  async update(id: string, updateGoalDto: UpdateGoalDto): Promise<Goal | null> {
    return this.goalModel.findByIdAndUpdate(id, updateGoalDto, { new: true }).exec();
  }

  // Delete a goal
  async remove(id: string): Promise<Goal | null> {
    return this.goalModel.findByIdAndDelete(id).exec();
  }

  // Add amount to a goal
  async addAmount(id: string, amount: number): Promise<Goal | null> {
    const goal = await this.goalModel.findById(id).exec();
  
    // Ensure amount is a valid number
    const numericAmount = Number(amount);
    if (isNaN(numericAmount)) {
      throw new Error('Invalid amount: not a number');
    }
  
    if (goal) {
      // Also make sure savedAmount is a number
      goal.savedAmount = Number(goal.savedAmount) || 0;
      goal.savedAmount += numericAmount;
  
      if (goal.savedAmount >= goal.targetAmount) {
        goal.isCompleted = true;
      }
  
      await goal.save();
      return goal;
    }
  
    return null;
  }
  

  // Subtract amount from a goal
  async subtractAmount(id: string, amount: number): Promise<Goal | null> {
    const goal = await this.goalModel.findById(id).exec();
    if (goal && goal.savedAmount >= amount) {
      goal.savedAmount -= amount;
      await goal.save();
      return goal;
    }
    return null;
  }

  // Add a transaction history entry
  async addTransaction(id: string, transaction: { amount: number; date: string; isAdded: boolean }): Promise<Goal | null> {
    const goal = await this.goalModel.findById(id).exec();
    if (goal) {
      goal.history.push(transaction);
      await goal.save();
      return goal;
    }
    return null;
  }


  async markGoalAsCompleted(goalId: string): Promise<void> {
    try {
      // Find the goal by ID and update the 'isCompleted' field to true
      const updatedGoal = await this.goalModel.findByIdAndUpdate(
        goalId,
        { isCompleted: true }, // Update the goal's completion status
        { new: true } // Return the updated goal
      );

      if (!updatedGoal) {
        throw new Error('Goal not found');
      }

      // Goal is marked as completed
      console.log('Goal marked as completed:', updatedGoal);
    } catch (error) {
      console.error('Error in markGoalAsCompleted:', error);
      throw new Error('Failed to mark goal as completed');
    }
  }

  // Calculate progress percentage
  async calculateGoalProgress(goalId: string): Promise<number> {
    // Fetch the goal by its ID
    const goal = await this.goalModel.findById(goalId).exec();

    if (!goal) {
      throw new Error('Goal not found');
    }

    // Sum the amounts in the history
    const totalSavedAmount = goal.history.reduce((total, transaction) => {
      return total + transaction.amount;
    }, 0);

    // Calculate progress as (totalSavedAmount / targetAmount) * 100
    const progressPercentage = (totalSavedAmount / goal.targetAmount) * 100;

    return progressPercentage;
  }

}
