/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model, Types } from 'mongoose';
import { Goal, GoalDocument } from '../goal-oriented-savings/schema/goal.schema';

@Injectable()
export class GoalNotificationService {
  constructor(
    @InjectModel(Goal.name) private goalModel: Model<GoalDocument>,
  ) {}

  /**
   * Get notification data for a specific goal
   * @param goalId The ID of the goal
   * @returns Object containing days remaining and amount needed to save
   */
  async getGoalNotification(goalId: string): Promise<{
    daysRemaining: number;
    amountNeeded: number;
  }> {
    const goal = await this.goalModel.findById(goalId);
    
    if (!goal) {
      throw new Error('Goal not found');
    }

    // Calculate days remaining until due date
    const daysRemaining = this.calculateDaysRemaining(goal.endDate);
    
    // Calculate remaining amount to save
    const amountNeeded = goal.targetAmount - goal.savedAmount;

    return {
      daysRemaining,
      amountNeeded,
    };
  }

  /**
   * Get notification data for all goals of a user
   * @param userId The ID of the user
   * @returns Array of goals with notification data
   */
  async getUserGoalNotifications(userId: string): Promise<Array<{
    goalId: string;
    goalName: string;
    daysRemaining: number;
    amountNeeded: number;
    targetAmount: number;
    savedAmount: number;
    progress: number;
  }>> {
    const goals = await this.goalModel.find({ 
      userId, 
      isCompleted: false 
    });

    return goals.map(goal => {
      const daysRemaining = this.calculateDaysRemaining(goal.endDate);
      const amountNeeded = goal.targetAmount - goal.savedAmount;
      const progress = (goal.savedAmount / goal.targetAmount) * 100;
      
      // Safely convert the _id to string regardless of its type
      const goalId = goal._id instanceof Types.ObjectId 
        ? goal._id.toString() 
        : String(goal._id);

      return {
        goalId,
        goalName: goal.name,
        daysRemaining,
        amountNeeded,
        targetAmount: goal.targetAmount,
        savedAmount: goal.savedAmount,
        progress: Math.round(progress),
      };
    });
  }

  /**
   * Calculate days remaining until a date
   * @param endDate The end date in string format
   * @returns Number of days remaining (can be negative if past due)
   */
  private calculateDaysRemaining(endDate: string): number {
    const today = new Date();
    const targetDate = new Date(endDate);
    
    // Reset time component to compare dates only
    today.setHours(0, 0, 0, 0);
    targetDate.setHours(0, 0, 0, 0);
    
    // Calculate difference in milliseconds and convert to days
    const differenceInTime = targetDate.getTime() - today.getTime();
    const differenceInDays = Math.ceil(differenceInTime / (1000 * 3600 * 24));
    
    return differenceInDays;
  }

  /**
   * Get urgent goals that are near due date or have significant amount left to save
   * @param userId The ID of the user
   * @param daysThreshold Consider urgent if less than this many days remaining
   * @param percentageThreshold Consider urgent if more than this percentage still needed
   * @returns Array of urgent goals with notification data
   */
  async getUrgentGoalNotifications(
    userId: string, 
    daysThreshold = 7, 
    percentageThreshold = 50
  ): Promise<Array<{
    goalId: string;
    goalName: string;
    daysRemaining: number;
    amountNeeded: number;
    targetAmount: number;
    savedAmount: number;
    progress: number;
    isUrgentByTime: boolean;
    isUrgentByAmount: boolean;
    dailySavingNeeded: number;
  }>> {
    const allGoals = await this.getUserGoalNotifications(userId);
    
    // Filter for urgent goals
    return allGoals
      .filter(goal => {
        const isUrgentByTime = goal.daysRemaining <= daysThreshold && goal.daysRemaining >= 0;
        const percentageNeeded = (goal.amountNeeded / goal.targetAmount) * 100;
        const isUrgentByAmount = percentageNeeded >= percentageThreshold;
        
        return isUrgentByTime || isUrgentByAmount;
      })
      .map(goal => {
        // Calculate daily saving needed (if there are days remaining)
        const dailySavingNeeded = goal.daysRemaining > 0 
          ? Math.ceil(goal.amountNeeded / goal.daysRemaining) 
          : goal.amountNeeded; // If past due, need full amount
        
        return {
          ...goal,
          isUrgentByTime: goal.daysRemaining <= daysThreshold && goal.daysRemaining >= 0,
          isUrgentByAmount: (goal.amountNeeded / goal.targetAmount) * 100 >= percentageThreshold,
          dailySavingNeeded,
        };
      });
  }
}