/* eslint-disable prettier/prettier */
import { Controller, Get, Param, Query } from '@nestjs/common';
import { NotificationService } from './notification.service';


@Controller('goals/notifications')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  // Get notification data for a specific goal
  @Get(':goalId')
  async getGoalNotification(@Param('goalId') goalId: string) {
    try {
      return await this.notificationService.getGoalNotificationData(goalId);
    } catch (error) {
      return { error: error.message };
    }
  }

  // Get urgent goals for a user (approaching deadline or almost complete)
  @Get('urgent/:userId')
  async getUrgentGoals(
    @Param('userId') userId: string,
    @Query('daysThreshold') daysThreshold = 7,
  ) {
    try {
      return await this.notificationService.getUrgentGoals(userId, Number(daysThreshold));
    } catch (error) {
      return { error: error.message };
    }
  }

  // Test endpoint for almost complete notifications
  @Get('test-almost-complete/:goalId')
  async testAlmostComplete(@Param('goalId') goalId: string) {
    try {
      return await this.notificationService.testAlmostCompleteNotification(goalId);
    } catch (error) {
      return { error: error.message };
    }
  }
}