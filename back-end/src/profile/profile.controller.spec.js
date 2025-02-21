import { Test } from '@nestjs/testing';
import { ProfileController } from './profile.controller';

describe('Profile Controller', () => {
  let controller;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      controllers: [ProfileController],
    }).compile();

    controller = module.get(ProfileController);
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
