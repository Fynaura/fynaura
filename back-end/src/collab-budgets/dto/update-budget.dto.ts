/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-call */
// import {
//   IsNumber,
//   IsString,
//   Min,
//   Max,
//   IsOptional,
//   IsBoolean,
//   IsArray,
// } from 'class-validator';

// export class UpdateBudgetDto {
//   @IsOptional()
//   @IsString()
//   name?: string;

//   @IsOptional()
//   @IsNumber()
//   @Min(1)
//   @Max(1000000)
//   amount?: number;

//   @IsOptional()
//   @IsString()
//   date?: string;

//   @IsOptional()
//   @IsBoolean()
//   isPinned?: boolean;

//   @IsOptional()
//   @IsArray()
//   collaborators?: string[];
// }
import { PartialType } from '@nestjs/mapped-types';
import { CreateBudgetDto } from './create-budget.dto';

export class UpdateBudgetDto extends PartialType(CreateBudgetDto) {
  collaborators?: string[];
}
