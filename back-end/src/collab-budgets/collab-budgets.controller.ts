import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  UseGuards,
  Request,
} from '@nestjs/common';
import { CollabBudgetsService } from './collab-budgets.service';
import { CreateCollabBudgetDto } from './dto/create-collab-budget.dto';
import { UpdateCollabBudgetDto } from './dto/update-collab-budget.dto';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('collab-budgets')
@UseGuards(JwtAuthGuard)
export class CollabBudgetsController {
  constructor(private readonly collabBudgetsService: CollabBudgetsService) {}

  @Post()
  async create(
    @Body() createCollabBudgetDto: CreateCollabBudgetDto,
    @Request() req,
  ) {
    const userId = req.user.id;
    return this.collabBudgetsService.create(createCollabBudgetDto, userId);
  }

  @Get()
  async findAll(@Request() req) {
    const userId = req.user.id;
    return this.collabBudgetsService.findAll(userId);
  }

  @Get(':id')
  async findOne(@Param('id') id: string, @Request() req) {
    const userId = req.user.id;
    return this.collabBudgetsService.findOne(id, userId);
  }

  @Patch(':id')
  async update(
    @Param('id') id: string,
    @Body() updateCollabBudgetDto: UpdateCollabBudgetDto,
    @Request() req,
  ) {
    const userId = req.user.id;
    return this.collabBudgetsService.update(id, updateCollabBudgetDto, userId);
  }

  @Patch(':id/toggle-pin')
  async togglePin(@Param('id') id: string, @Request() req) {
    const userId = req.user.id;
    return this.collabBudgetsService.togglePin(id, userId);
  }

  @Delete(':id')
  async remove(@Param('id') id: string, @Request() req) {
    const userId = req.user.id;
    return this.collabBudgetsService.remove(id, userId);
  }
}
