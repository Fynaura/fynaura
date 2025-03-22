/* eslint-disable prettier/prettier */
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type GoalDocument = Goal & Document;

@Schema({ timestamps: true })
export class Goal {
  @Prop({ required: true })
  name: string;  // The name of the goal

  @Prop({ required: true })
  targetAmount: number;  // The target amount for the goal

  @Prop({ required: false })
  savedAmount: number;  // The amount saved towards the goal

  @Prop({ required: true })
  startDate: string;  // The start date of the goal

  @Prop({ required: true })
  endDate: string;  // The end date for the goal

  @Prop({ default: false })
  isCompleted: boolean;  // Boolean to check if the goal is completed

  @Prop({ type: String, default: null })
  image: string | null;  // Optional image path for the goal

  @Prop({ default: [] })
  history: [
    {
      amount: number;
      date: string;
      isAdded: boolean;  // Whether the transaction was an addition or subtraction
    }
  ];  // History of transactions related to the goal

  @Prop({ required: false })
  userId: string;  // The user who created the goal
}

export const GoalSchema = SchemaFactory.createForClass(Goal);