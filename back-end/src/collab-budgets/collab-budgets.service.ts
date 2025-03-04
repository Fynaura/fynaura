/* eslint-disable prettier/prettier */
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Budget, BudgetDocument } from './schema/budget.schema';
import { CreateBudgetDto } from './dto/create-budget.dto';
import { UpdateBudgetDto } from './dto/update-budget.dto';

@Injectable()
export class CollabBudgetsService {
  constructor(
    @InjectModel(Budget.name) private budgetModel: Model<BudgetDocument>,
  ) {}

  async create(createBudgetDto: CreateBudgetDto): Promise<Budget> {
    const newBudget = new this.budgetModel(createBudgetDto);
    return newBudget.save();
  }

  async findAll(): Promise<Budget[]> {
    return this.budgetModel.find().exec();
  }

  async findOne(id: string): Promise<Budget> {
    const budget = await this.budgetModel.findById(id).exec();
    if (!budget) {
      throw new NotFoundException('Budget not found');
    }
    return budget;
  }

  async update(id: string, updateBudgetDto: UpdateBudgetDto): Promise<Budget> {
    const updatedBudget = await this.budgetModel
      .findByIdAndUpdate(id, updateBudgetDto, { new: true })
      .exec();
    if (!updatedBudget) {
      throw new NotFoundException('Budget not found');
    }
    return updatedBudget;
  }

  async delete(id: string): Promise<{ message: string }> {
    const result = await this.budgetModel.findByIdAndDelete(id).exec();
    if (!result) {
      throw new NotFoundException('Budget not found');
    }
    return { message: 'Budget deleted successfully' };
  }
}
