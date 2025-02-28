/* eslint-disable prettier/prettier */

import * as mongoose from 'mongoose';
import { Logger } from '@nestjs/common';

const logger = new Logger('DatabaseProvider');

export const databaseProviders = [
  {
    provide: 'DATABASE_CONNECTION',
    useFactory: async (): Promise<typeof mongoose> => {
      try {
        const connection = await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost/nest');
        logger.log('Successfully connected to MongoDB.');
        
        // Listen for connection events
        mongoose.connection.on('error', (error) => {
          logger.error('MongoDB connection error:', error);
        });

        mongoose.connection.on('disconnected', () => {
          logger.warn('MongoDB disconnected');
        });

        return connection;
      } catch (error) {
        logger.error('Failed to connect to MongoDB:', error);
        throw error;
      }
    },
  },
];