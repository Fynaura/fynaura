import { Test } from '@nestjs/testing';
import { UserService } from './user.service';

describe('UserService', () => {
  let service;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [UserService],
    }).compile();

    service = module.get(UserService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
