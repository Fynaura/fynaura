/* eslint-disable prettier/prettier */
import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document, Types } from 'mongoose'; // ⬅ Add Types for ObjectId

export type GoalDocument = Goal & Document;

// -----------------------------
// Transaction Subdocument Schema
// -----------------------------
@Schema({ _id: true }) // Auto-generate _id for each transaction
export class Transaction {
  @Prop({ required: true })
  amount: number;

  @Prop({ required: true })
  date: string;

  @Prop({ required: true })
  isAdded: boolean;

  // ✅ Add this so TypeScript knows each transaction has an _id
  _id?: Types.ObjectId;
}

export const TransactionSchema = SchemaFactory.createForClass(Transaction);

// -----------------------------
// Goal Schema
// -----------------------------
@Schema({ timestamps: true })
export class Goal {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  targetAmount: number;

  @Prop({ required: false, default: 0 })
  savedAmount: number;

  @Prop({ required: true })
  startDate: string;

  @Prop({ required: true })
  endDate: string;

  @Prop({ default: false })
  isCompleted: boolean;

  @Prop({ type: String, default: null })
  image: string | null;

  @Prop({ type: [TransactionSchema], default: [] })
  history: Transaction[];

  @Prop({ required: false })
  userId: string;
}

export const GoalSchema = SchemaFactory.createForClass(Goal);