/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-call */
// import {
//   IsNotEmpty,
//   IsNumber,
//   IsString,
//   Min,
//   Max,
//   IsOptional,
//   IsBoolean,
//   IsArray,
// } from 'class-validator';

// export class CreateBudgetDto {
//   @IsNotEmpty()
//   @IsString()
//   name: string;

//   @IsNotEmpty()
//   @IsNumber()
//   @Min(1)
//   @Max(1000000)
//   amount: number;

//   @IsNotEmpty()
//   @IsString()
//   date: string;

//   @IsOptional()
//   @IsBoolean()
//   isPinned?: boolean;

//   @IsOptional()
//   @IsArray()
//   collaborators?: string[];
// }
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CreateBudgetDto {
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsNumber()
  amount: number;

  @IsString()
  @IsNotEmpty()
  date: string;
}
