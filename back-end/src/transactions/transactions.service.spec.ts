// /* eslint-disable prettier/prettier */
// import { Test, TestingModule } from '@nestjs/testing';
// import { TransactionsService } from './transactions.service';

// describe('TransactionsService', () => {
//   let service: TransactionsService;

//   beforeEach(async () => {
//     const module: TestingModule = await Test.createTestingModule({
//       providers: [TransactionsService],
//     }).compile();

//     service = module.get<TransactionsService>(TransactionsService);
//   });

//   it('should be defined', () => {
//     expect(service).toBeDefined();
//   });
// });
/* eslint-disable prettier/prettier */
import { Test, TestingModule } from '@nestjs/testing';
import { TransactionsService } from './transactions.service';
import { getModelToken } from '@nestjs/mongoose';

describe('TransactionsService', () => {
  let service: TransactionsService;

  // Create a mock for the TransactionModel
  const mockTransactionModel = {
    find: jest.fn().mockReturnThis(),
    findOne: jest.fn().mockReturnThis(),
    findById: jest.fn().mockReturnThis(),
    create: jest.fn(),
    save: jest.fn(),
    exec: jest.fn(),
    // Add any other methods your service uses
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TransactionsService,
        {
          provide: getModelToken('Transaction'),
          useValue: mockTransactionModel,
        },
      ],
    }).compile();

    service = module.get<TransactionsService>(TransactionsService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
