/* eslint-disable prettier/prettier */
import { IsNotEmpty, IsNumber, IsString, IsBoolean } from 'class-validator';

export class AddTransactionDto {
  @IsString()
  @IsNotEmpty()
  description: string;

  @IsNumber()
  amount: number;

  @IsString()
  @IsNotEmpty()
  date: string;

  @IsString()
  @IsNotEmpty()
  addedBy: string;

  @IsBoolean()
  isExpense: boolean;
}
