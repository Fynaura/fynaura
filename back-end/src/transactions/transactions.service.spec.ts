// // /* eslint-disable prettier/prettier */
// // import { Test, TestingModule } from '@nestjs/testing';
// // import { TransactionsService } from './transactions.service';

// // describe('TransactionsService', () => {
// //   let service: TransactionsService;

// //   beforeEach(async () => {
// //     const module: TestingModule = await Test.createTestingModule({
// //       providers: [TransactionsService],
// //     }).compile();

// //     service = module.get<TransactionsService>(TransactionsService);
// //   });

// //   it('should be defined', () => {
// //     expect(service).toBeDefined();
// //   });
// // });
// /* eslint-disable prettier/prettier */
// import { Test, TestingModule } from '@nestjs/testing';
// import { TransactionsService } from './transactions.service';
// import { getModelToken } from '@nestjs/mongoose';

// describe('TransactionsService', () => {
//   let service: TransactionsService;

//   // Create a mock for the TransactionModel
//   const mockTransactionModel = {
//     find: jest.fn().mockReturnThis(),
//     findOne: jest.fn().mockReturnThis(),
//     findById: jest.fn().mockReturnThis(),
//     create: jest.fn(),
//     save: jest.fn(),
//     exec: jest.fn(),
//     // Add any other methods your service uses
//   };

//   beforeEach(async () => {
//     const module: TestingModule = await Test.createTestingModule({
//       providers: [
//         TransactionsService,
//         {
//           provide: getModelToken('Transaction'),
//           useValue: mockTransactionModel,
//         },
//       ],
//     }).compile();

//     service = module.get<TransactionsService>(TransactionsService);
//   });

//   it('should be defined', () => {
//     expect(service).toBeDefined();
//   });
// });
/* eslint-disable prettier/prettier */
import { Test, TestingModule } from '@nestjs/testing';
import { TransactionsController } from './transactions.controller';
import { TransactionsService } from './transactions.service';

describe('TransactionsController', () => {
  let controller: TransactionsController;

  // Create a mock TransactionsService
  const mockTransactionsService = {
    getTotalIncome: jest.fn().mockResolvedValue(1000),
    getTotalExpense: jest.fn().mockResolvedValue(500),
    create: jest
      .fn()
      .mockImplementation((dto) => Promise.resolve({ id: 'some-id', ...dto })),
    findByUserId: jest.fn().mockResolvedValue([]),
    findAll: jest.fn().mockResolvedValue([]),
    getAllTransactions: jest.fn().mockResolvedValue([]),
    getHourlyBalanceForLast24Hours: jest.fn().mockResolvedValue([]),
    createBulk: jest
      .fn()
      .mockImplementation((dtos) =>
        Promise.resolve(dtos.map((dto) => ({ id: 'some-id', ...dto }))),
      ),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TransactionsController],
      providers: [
        {
          provide: TransactionsService,
          useValue: mockTransactionsService,
        },
      ],
    }).compile();

    controller = module.get<TransactionsController>(TransactionsController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  // You can add more specific tests for your controller methods here
});
