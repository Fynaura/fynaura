/* eslint-disable prettier/prettier */


import {
    Prop,
    Schema,
    SchemaFactory
  } from '@nestjs/mongoose';
  import {
    Document
  } from 'mongoose';
  
  export type transactionDocument = Transaction & Document;
  
  @Schema({ timestamps: true })
  export class Transaction {
    @Prop({ required: true, enum: ['income', 'expense'] })
    type: 'income' | 'expense';
  
    @Prop({ required: true })
    amount: number;
  
    @Prop({ required: true })
    category: string;
  
    @Prop({required: false})
    description?: string;
  
    @Prop({ required: true })
    date: Date;
  
    @Prop({ default: false })
    reminder: boolean;

    @Prop()
    reminderDate?: Date;
  }
  
  export const TransactionSchema = SchemaFactory.createForClass(Transaction);
  