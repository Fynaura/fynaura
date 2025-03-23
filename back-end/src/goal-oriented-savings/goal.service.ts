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
  ) {}

  // Create a new goal
  async create(createGoalDto: CreateGoalDto): Promise<Goal> {
    const newGoal = new this.goalModel(createGoalDto);
    return await newGoal.save();
  }

  // Get all goals (admin or dev)
  async findAll(): Promise<Goal[]> {
    return this.goalModel.find().exec();
  }

  // Get goals by userId
  async findByUserId(userId: string): Promise<Goal[]> {
    return this.goalModel.find({ userId }).exec();
  }

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
  
    const numericAmount = Number(amount);
    if (isNaN(numericAmount)) {
      throw new Error('Invalid amount: not a number');
    }
  
    if (goal) {
      goal.savedAmount = Number(goal.savedAmount) || 0;
      goal.savedAmount += numericAmount;
  
      // ✅ Optional but good
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
  
    if (!goal) return null;
  
    const numericAmount = Number(amount);
    if (isNaN(numericAmount)) {
      throw new Error('Invalid amount: not a number');
    }
  
    goal.savedAmount = Number(goal.savedAmount) || 0;
  
    if (goal.savedAmount >= numericAmount) {
      goal.savedAmount -= numericAmount;
      await goal.save();
      return goal;
    }
  
    throw new Error('Cannot subtract more than saved amount');
  }
  

  // ✅ Add a transaction history entry
  async addTransaction(
    id: string,
    transaction: { amount: number; date: string; isAdded: boolean },
  ): Promise<Goal | null> {
    const goal = await this.goalModel.findById(id).exec();
    if (goal) {
      goal.history.push({
        amount: transaction.amount,
        date: transaction.date,
        isAdded: transaction.isAdded,
      }); // Let Mongoose handle _id

      await goal.save();
      return goal;
    }
    return null;
  }

  // ✅ Remove a transaction and update savedAmount accordingly
  async removeTransaction(goalId: string, transactionId: string): Promise<Goal | null> {
    const goal = await this.goalModel.findById(goalId).exec();
    if (!goal) return null;
  
    // Find the transaction
    const transactionIndex = goal.history.findIndex(tx => tx._id?.toString() === transactionId);
    if (transactionIndex === -1) return null;

    // ✅ Log the deletion for debugging
    console.log(`Deleting transaction ${transactionId} from goal ${goalId}`);
  
    const transaction = goal.history[transactionIndex];
  
    // Adjust savedAmount
    goal.savedAmount -= transaction.isAdded ? transaction.amount : -transaction.amount;
  
    // Remove the transaction
    goal.history.splice(transactionIndex, 1);
  
    // Save the updated goal
    return await goal.save();
  }
  
  

  // Mark goal as completed
  async markGoalAsCompleted(goalId: string): Promise<void> {
    const updatedGoal = await this.goalModel.findByIdAndUpdate(
      goalId,
      { isCompleted: true },
      { new: true },
    );

    if (!updatedGoal) {
      throw new Error('Goal not found');
    }

    console.log('Goal marked as completed:', updatedGoal);
  }

  // Calculate progress % using total transaction amounts
  async calculateGoalProgress(goalId: string): Promise<number> {
    const goal = await this.goalModel.findById(goalId).exec();
    if (!goal) {
      throw new Error('Goal not found');
    }

    const totalSavedAmount = goal.history.reduce((total, tx) => {
      return total + tx.amount;
    }, 0);

    const progressPercentage = (totalSavedAmount / goal.targetAmount) * 100;
    return progressPercentage;
  }
}