import { Test } from '@nestjs/testing';
import { TransactionController } from './transaction.controller';

describe('Transaction Controller', () => {
  let controller;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      controllers: [TransactionController],
    }).compile();

    controller = module.get(TransactionController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
