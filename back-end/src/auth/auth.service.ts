/* eslint-disable prettier/prettier */
import { clerkClient } from '@clerk/clerk-sdk-node';
import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
    async getAllUsers() {
        return clerkClient.users.getUserList();
    }
}
