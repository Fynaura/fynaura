// import { IsNotEmpty, IsString, IsNumber, Min, Max, IsDateString, IsOptional, IsBoolean } from 'class-validator';

// export class CreateCollabBudgetDto {
//   @IsNotEmpty({ message: 'Budget name cannot be empty' })
//   @IsString()
//   name: string;

//   @IsNotEmpty({ message: 'Budget amount cannot be empty' })
//   @IsNumber({}, { message: 'Amount must be a valid number' })
//   @Min(0.01, { message: 'Amount must be greater than 0' })
//   @Max(1000000, { message: 'Amount cannot exceed 1,000,000' })
//   amount: number;

//   @IsNotEmpty({ message: 'Date cannot be empty' })
//   @IsString()
//   date: string;

//   @IsOptional()
//   @IsBoolean()
//   isPinned?: boolean;
// }
