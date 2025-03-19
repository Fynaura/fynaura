/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { CreateGoalDto, UpdateGoalDto } from './dto/goal.dto';  // Adjust import path accordingly
import { Goal, GoalDocument } from './schema/goal.schema';
  // Adjust import path accordingly

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

  // Find all goals for a specific user
  async findAll(userId: string): Promise<Goal[]> {
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
    if (goal) {
      goal.savedAmount += amount;
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
}
