/* eslint-disable prettier/prettier */
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Budget, BudgetDocument } from './schema/budget.schema';
import { CreateBudgetDto } from './dto/create-budget.dto';
import { UpdateBudgetDto } from './dto/update-budget.dto';
import { AddTransactionDto } from './dto/add-transaction.dto';

@Injectable()
export class CollabBudgetsService {
  constructor(
    @InjectModel(Budget.name) private budgetModel: Model<BudgetDocument>,
  ) {}

  async create(createBudgetDto: CreateBudgetDto): Promise<Budget> {
    const newBudget = new this.budgetModel(createBudgetDto);
    return newBudget.save();
  }

  async findAll(userId?: string): Promise<Budget[]> {
    if (userId) {
      return this.budgetModel
        .find({
          $or: [{ userId }, { collaborators: userId }],
        })
        .exec();
    }
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

  async addTransaction(
    id: string,
    transactionDto: AddTransactionDto,
  ): Promise<Budget> {
    const budget = await this.budgetModel.findById(id).exec();
    if (!budget) {
      throw new NotFoundException('Budget not found');
    }

    // If it's an expense, store it as is. If it's income, store it with negative amount
    // This way we can use the same array for both expenses and income
    const transaction = {
      description: transactionDto.description,
      amount: transactionDto.isExpense
        ? transactionDto.amount
        : -transactionDto.amount,
      date: transactionDto.date,
      addedBy: transactionDto.addedBy,
      isExpense: transactionDto.isExpense,
    };

    budget.expenses.push(transaction);

    if (transactionDto.isExpense) {
      budget.amount -= transactionDto.amount;
    } else {
      budget.amount += transactionDto.amount;
    }

    return budget.save();
  }
  async addCollaborator(budgetId: string, userId: string): Promise<Budget> {
    const budget = await this.budgetModel.findById(budgetId).exec();

    if (!budget) {
      throw new NotFoundException('Budget not found');
    }

    // Check if the user is already a collaborator
    if (budget.collaborators.includes(userId)) {
      return budget; // User is already a collaborator, return the budget unchanged
    }

    // Add the user to the collaborators array
    budget.collaborators.push(userId);

    // Save and return the updated budget
    return budget.save();
  }

  // Add a new endpoint to get all budgets including collaborative ones for a user
  async findAllForUser(
    userId: string,
    includeCollaborative: boolean = true,
  ): Promise<Budget[]> {
    if (!userId) {
      throw new NotFoundException('User ID is required');
    }

    let query = {};

    if (includeCollaborative) {
      query = {
        $or: [
          { userId: userId }, // Budgets owned by the user
          { collaborators: userId }, // Budgets where user is a collaborator
        ],
      };
    } else {
      query = { userId: userId }; // Only budgets owned by the user
    }

    return this.budgetModel.find(query).exec();
  }
}
