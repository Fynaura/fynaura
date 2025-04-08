/* eslint-disable prettier/prettier */
import { Controller, Get, Param, Query } from '@nestjs/common';
import { GoalNotificationService } from './notification.service';

import { GoalService } from '../goal-oriented-savings/goal.service';

@Controller('goals/notifications')
export class GoalNotificationController {
  constructor(
    private goalNotificationService: GoalNotificationService,
    private goalService: GoalService,
  ) {}

  /**
   * Get notification data for a specific goal
   * @param goalId The ID of the goal
   * @returns Notification data for the goal (days remaining and amount needed)
   */
  @Get(':goalId')
  async getGoalNotification(@Param('goalId') goalId: string) {
    return this.goalNotificationService.getGoalNotification(goalId);
  }

  /**
   * Get notification data for all goals of the authenticated user
   * @param userId The ID of the authenticated user
   * @returns Array of goals with notification data
   */
  @Get('user/:userId')
  async getUserGoalNotifications(@Param('userId') userId: string) {
    return this.goalNotificationService.getUserGoalNotifications(userId);
  }

  /**
   * Get urgent goals for a specific user
   * @param userId The ID of the user
   * @param daysThreshold Optional parameter to set days threshold
   * @param percentageThreshold Optional parameter to set percentage threshold
   * @returns Array of urgent goals with notification data
   */
  @Get('urgent/:userId')
  async getUrgentGoalNotifications(
    @Param('userId') userId: string,
    @Query('daysThreshold') daysThreshold?: string,
    @Query('percentageThreshold') percentageThreshold?: string,
  ) {
    return this.goalNotificationService.getUrgentGoalNotifications(
      userId,
      daysThreshold ? parseInt(daysThreshold, 10) : undefined,
      percentageThreshold ? parseInt(percentageThreshold, 10) : undefined,
    );
  }

  /**
   * Get summary of goals progress and statistics for a user
   * @param userId The ID of the user
   * @returns Summary statistics of user's goals
   */
  @Get('summary/:userId')
  async getGoalsSummary(@Param('userId') userId: string) {
    const allGoals = await this.goalService.findByUserId(userId);
    const activeGoals = allGoals.filter(goal => !goal.isCompleted);
    
    if (activeGoals.length === 0) {
      return {
        totalGoals: 0,
        goalsOnTrack: 0,
        goalsAtRisk: 0,
        averageProgress: 0,
        upcomingDeadlines: [],
      };
    }
    
    const goalsWithNotifications = await this.goalNotificationService.getUserGoalNotifications(userId);
    
    // Calculate summary statistics
    const totalGoals = activeGoals.length;
    const goalsAtRisk = goalsWithNotifications.filter(g => 
      g.daysRemaining <= 7 || g.amountNeeded > (g.targetAmount * 0.5)
    ).length;
    const goalsOnTrack = totalGoals - goalsAtRisk;
    
    // Calculate average progress
    const totalProgress = activeGoals.reduce((sum, goal) => {
      const progressPercent = (goal.savedAmount / goal.targetAmount) * 100;
      return sum + progressPercent;
    }, 0);
    const averageProgress = Math.round(totalProgress / totalGoals);
    
    // Get upcoming deadlines
    const upcomingDeadlines = goalsWithNotifications
      .filter(g => g.daysRemaining >= 0 && g.daysRemaining <= 14)
      .sort((a, b) => a.daysRemaining - b.daysRemaining)
      .slice(0, 3)
      .map(g => ({
        goalId: g.goalId,
        goalName: g.goalName,
        daysRemaining: g.daysRemaining,
        amountNeeded: g.amountNeeded,
      }));
    
    return {
      totalGoals,
      goalsOnTrack,
      goalsAtRisk,
      averageProgress,
      upcomingDeadlines,
    };
  }
  
  /**
   * Get daily saving amount needed for goals
   * @param userId The ID of the user
   * @returns Array of goals with daily savings requirements
   */
  @Get('daily-target/:userId')
  async getDailySavingTargets(@Param('userId') userId: string) {
    const goalsWithNotifications = await this.goalNotificationService.getUserGoalNotifications(userId);
    
    return goalsWithNotifications
      .filter(g => g.daysRemaining > 0 && g.amountNeeded > 0)
      .map(g => ({
        goalId: g.goalId,
        goalName: g.goalName,
        dailySavingNeeded: Math.ceil(g.amountNeeded / g.daysRemaining),
        daysRemaining: g.daysRemaining,
        amountNeeded: g.amountNeeded,
      }));
  }
}