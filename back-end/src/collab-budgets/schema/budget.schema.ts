/* eslint-disable prettier/prettier */

import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type BudgetDocument = Budget & Document;

@Schema({ timestamps: true })
export class Budget {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  amount: number;

  @Prop({ default: 100 })
  remainPercentage: number;

  @Prop({ required: true })
  date: string;

  @Prop({ default: false })
  isPinned: boolean;

  @Prop({ default: [] })
  collaborators: string[];

  @Prop({ default: [] })
  expenses: [
    {
      description: string;
      amount: number;
      date: string;
      addedBy: string;
      isExpense: boolean;
    },
  ];

  @Prop({ required: true })
  userId: string;
}

export const BudgetSchema = SchemaFactory.createForClass(Budget);
