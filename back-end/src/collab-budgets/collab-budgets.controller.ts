/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Patch,
  Delete,
} from '@nestjs/common';
import { CollabBudgetsService } from './collab-budgets.service';
import { CreateBudgetDto } from './dto/create-budget.dto';
import { UpdateBudgetDto } from './dto/update-budget.dto';

@Controller('collab-budgets')
export class CollabBudgetsController {
  constructor(private readonly collabBudgetsService: CollabBudgetsService) {}

  @Post()
  create(@Body() createBudgetDto: CreateBudgetDto) {
    return this.collabBudgetsService.create(createBudgetDto);
  }

  @Get()
  findAll() {
    return this.collabBudgetsService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.collabBudgetsService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateBudgetDto: UpdateBudgetDto) {
    return this.collabBudgetsService.update(id, updateBudgetDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.collabBudgetsService.delete(id);
  }
}
