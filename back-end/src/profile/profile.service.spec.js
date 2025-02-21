import { Test } from '@nestjs/testing';
import { ProfileService } from './profile.service';

describe('ProfileService', () => {
  let service;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [ProfileService],
    }).compile();

    service = module.get(ProfileService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
