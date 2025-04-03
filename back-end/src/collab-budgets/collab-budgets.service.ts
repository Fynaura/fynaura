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
  
    // Get the initial budget amount (the starting amount)
    const initialAmount = budget.amount;
  
    // Create the transaction object with the isExpense field
    const transaction = {
      description: transactionDto.description,
      amount: transactionDto.amount,
      date: transactionDto.date || new Date().toISOString(),
      addedBy: transactionDto.addedBy,
      isExpense: transactionDto.isExpense, // Include isExpense field
    };
  
    // Add the transaction to expenses array
    budget.expenses.push(transaction);
    
    // Calculate total expenses (sum of all expense transactions)
    const totalExpenses = budget.expenses
      .filter(expense => expense.isExpense)
      .reduce((sum, expense) => sum + expense.amount, 0);
    
    // Calculate total income (sum of all income transactions)
    const totalIncome = budget.expenses
      .filter(expense => !expense.isExpense)
      .reduce((sum, expense) => sum + expense.amount, 0);
    
    // Calculate current remaining amount
    const currentAmount = initialAmount - totalExpenses + totalIncome;
    
    // Calculate percentage remaining and ensure it's between 0-100
    let percentageRemaining = (currentAmount / initialAmount) * 100;
    percentageRemaining = Math.max(0, Math.min(100, percentageRemaining));
    
    // Round to 2 decimal places
    percentageRemaining = Math.round(percentageRemaining * 100) / 100;
    
    // Update the remainPercentage field
    budget.remainPercentage = percentageRemaining;
  
    // Save and return the updated budget
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
