/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Goal, GoalDocument } from '../goal-oriented-savings/schema/goal.schema';

// Define interfaces for our return types
interface NotificationData {
  daysRemaining: number;
  amountNeeded: number;
  dailySavingNeeded: number;
  progressPercentage: number;
  isAlmostComplete: boolean;
  isUrgentByTime: boolean;
}

interface UrgentGoalInfo {
  goalId: string;
  goalName: string;
  daysRemaining: number;
  amountNeeded: number;
  dailySavingNeeded: number;
  progressPercentage: number;
  isUrgentByTime: boolean;
  isUrgentByProgress: boolean;
}

@Injectable()
export class NotificationService {
  constructor(
    @InjectModel(Goal.name) private goalModel: Model<GoalDocument>,
  ) {}

  // Get notification data for a specific goal
  async getGoalNotificationData(goalId: string): Promise<NotificationData> {
    try {
      const goal = await this.goalModel.findById(goalId).exec();
      if (!goal) {
        throw new Error('Goal not found');
      }

      // Calculate days remaining
      const currentDate = new Date();
      const endDate = new Date(goal.endDate);
      const timeDifference = endDate.getTime() - currentDate.getTime();
      const daysRemaining = Math.ceil(timeDifference / (1000 * 3600 * 24));

      // Calculate amount needed to reach the target
      const amountNeeded = Math.max(0, goal.targetAmount - goal.savedAmount);
      
      // Calculate daily saving needed to reach the goal on time
      const dailySavingNeeded = daysRemaining > 0 ? amountNeeded / daysRemaining : amountNeeded;
      
      // Calculate progress percentage
      const progressPercentage = (goal.savedAmount / goal.targetAmount) * 100;
      
      // Check if the goal is almost complete (within 10% of target)
      const isAlmostComplete = progressPercentage >= 90 && progressPercentage < 100;

      return {
        daysRemaining,
        amountNeeded,
        dailySavingNeeded,
        progressPercentage,
        isAlmostComplete,
        isUrgentByTime: daysRemaining <= 7 && daysRemaining > 0,
      };
    } catch (error) {
      throw error;
    }
  }

  // Get urgent goals for a user (approaching deadline or almost complete)
  async getUrgentGoals(userId: string, daysThreshold = 7): Promise<UrgentGoalInfo[]> {
    try {
      // Get all user's goals
      const goals = await this.goalModel.find({ userId, isCompleted: false }).exec();
      const currentDate = new Date();
      const urgentGoals: UrgentGoalInfo[] = []; // Explicitly type the array

      for (const goal of goals) {
        // Calculate days remaining until deadline
        const endDate = new Date(goal.endDate);
        const timeDifference = endDate.getTime() - currentDate.getTime();
        const daysRemaining = Math.ceil(timeDifference / (1000 * 3600 * 24));

        // Calculate amount needed and daily saving
        const amountNeeded = Math.max(0, goal.targetAmount - goal.savedAmount);
        const dailySavingNeeded = daysRemaining > 0 ? amountNeeded / daysRemaining : amountNeeded;
        
        // Calculate progress percentage
        const progressPercentage = (goal.savedAmount / goal.targetAmount) * 100;
        
        // Check if goal is urgent by time (approaching deadline)
        const isUrgentByTime = daysRemaining <= daysThreshold && daysRemaining > 0;
        
        // Check if goal is urgent by progress (almost complete)
        const isUrgentByProgress = progressPercentage >= 90 && progressPercentage < 100;

        // If urgent by either time or progress, add to urgent goals
        if (isUrgentByTime || isUrgentByProgress) {
          urgentGoals.push({
            goalId: String(goal['_id']),  // Use bracket notation and convert to string
            goalName: goal.name,
            daysRemaining,
            amountNeeded,
            dailySavingNeeded,
            progressPercentage,
            isUrgentByTime,
            isUrgentByProgress,
          });
        }
      }

      return urgentGoals;
    } catch (error) {
      throw error;
    }
  }

  // Send notifications for goals that are almost complete (testing method)
  async testAlmostCompleteNotification(goalId: string) {
    try {
      const notificationData = await this.getGoalNotificationData(goalId);
      
      if (notificationData.isAlmostComplete) {
        console.log(`NOTIFICATION: Goal is almost complete! Only ${(100 - notificationData.progressPercentage).toFixed(1)}% to go!`);
        return {
          success: true,
          message: 'Almost complete notification would be sent',
          data: notificationData
        };
      } else {
        return {
          success: false,
          message: 'Goal is not almost complete yet',
          data: notificationData
        };
      }
    } catch (error) {
      throw error;
    }
  }
}