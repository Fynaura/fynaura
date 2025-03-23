/* eslint-disable prettier/prettier */
import { IsBoolean, IsDateString, IsNotEmpty, IsNumber, IsOptional, IsString, IsArray } from 'class-validator';

export class CreateGoalDto {
  @IsString()
  @IsNotEmpty()
  name: string;  // The name of the goal

  @IsNumber()
  @IsNotEmpty()
  targetAmount: number;  // The target amount for the goal

  @IsNumber()
  @IsNotEmpty()
  savedAmount: number;  // The amount saved towards the goal

  @IsDateString()
  @IsNotEmpty()
  startDate: string;  // The start date of the goal

  @IsDateString()
  @IsNotEmpty()
  endDate: string;  // The end date for the goal

  @IsBoolean()
  @IsOptional()
  isCompleted: boolean;  // Whether the goal is completed

  @IsString()
  @IsOptional()
  image: string | null;  // Optional image path for the goal

  @IsArray()
  @IsOptional()
  history: Array<{
    amount: number;
    date: string;
    isAdded: boolean;
  }>;  // Optional array of transaction history
}

export class UpdateGoalDto {
  @IsString()
  @IsOptional()
  name?: string;  // The name of the goal

  @IsNumber()
  @IsOptional()
  targetAmount?: number;  // The target amount for the goal

  @IsNumber()
  @IsOptional()
  savedAmount: number;  // The amount saved towards the goal
  
  @IsDateString()
  @IsOptional()
  startDate?: string;  // The start date of the goal

  @IsDateString()
  @IsOptional()
  endDate?: string;  // The end date for the goal

  @IsBoolean()
  @IsOptional()
  isCompleted?: boolean;  // Whether the goal is completed

  @IsString()
  @IsOptional()
  image?: string | null;  // Optional image path for the goal

  @IsArray()
  @IsOptional()
  history?: Array<{
    amount: number;
    date: string;
    isAdded: boolean;
  }>;  // Optional array of transaction history
}