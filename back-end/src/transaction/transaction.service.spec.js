import { Test } from '@nestjs/testing';
import { TransactionService } from './transaction.service';

describe('TransactionService', () => {
  let service;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [TransactionService],
    }).compile();

    service = module.get(TransactionService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
