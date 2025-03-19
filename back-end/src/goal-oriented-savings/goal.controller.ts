/* eslint-disable prettier/prettier */
import { Controller, Get, Post, Body, Param, Put, Delete } from '@nestjs/common';
import { GoalService } from './goal.service';  // Adjust import path accordingly
import { CreateGoalDto, UpdateGoalDto } from './dto/goal.dto';  // Adjust import path accordingly
import { Goal } from './schema/goal.schema';
  // Adjust import path accordingly

@Controller('goals')
export class GoalController {
  constructor(private readonly goalService: GoalService) {}

  // Endpoint to create a new goal
  @Post()
  async create(@Body() createGoalDto: CreateGoalDto): Promise<Goal> {
    return this.goalService.create(createGoalDto);
  }

  // Endpoint to get all goals for a specific user
  @Get(':userId')
  async findAll(@Param('userId') userId: string): Promise<Goal[]> {
    return this.goalService.findAll(userId);
  }

  // Endpoint to get a single goal by its ID
  @Get('goal/:id')
  async findOne(@Param('id') id: string): Promise<Goal | null> {
    return this.goalService.findOne(id);
  }

  // Endpoint to update an existing goal
  @Put('goal/:id')
  async update(
    @Param('id') id: string,
    @Body() updateGoalDto: UpdateGoalDto,
  ): Promise<Goal | null> {
    return this.goalService.update(id, updateGoalDto);
  }

  // Endpoint to delete a goal by its ID
  @Delete('goal/:id')
  async remove(@Param('id') id: string): Promise<Goal | null> {
    return this.goalService.remove(id);
  }

  // Endpoint to add amount to a goal
  @Post('goal/:id/addAmount')
  async addAmount(
    @Param('id') id: string,
    @Body('amount') amount: number,
  ): Promise<Goal | null> {
    return this.goalService.addAmount(id, amount);
  }

  // Endpoint to subtract amount from a goal
  @Post('goal/:id/subtractAmount')
  async subtractAmount(
    @Param('id') id: string,
    @Body('amount') amount: number,
  ): Promise<Goal | null> {
    return this.goalService.subtractAmount(id, amount);
  }

  // Endpoint to add a transaction to a goal
  @Post('goal/:id/addTransaction')
  async addTransaction(
    @Param('id') id: string,
    @Body() transaction: { amount: number; date: string; isAdded: boolean },
  ): Promise<Goal | null> {
    return this.goalService.addTransaction(id, transaction);
  }
}
