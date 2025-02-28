/* eslint-disable prettier/prettier */
export class Transaction {
    // _id: string;  // MongoDB ObjectId as a string
    type: 'income' | 'expense';
    amount: number;
    category: string;
    note?: string;
    date: Date;
    reminder: boolean;
  }
  