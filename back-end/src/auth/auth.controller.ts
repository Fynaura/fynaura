/* eslint-disable prettier/prettier */


import { Controller, Get } from '@nestjs/common';
import { Public } from '../decorators/public.decorator'; // Corrected import path

import { clerkClient } from '@clerk/clerk-sdk-node';


@Controller('auth')
export class AuthController {
    
    @Public()
    @Get('users')
    getHello(): Promise<any> {
        return clerkClient.users.getUserList();
    }

}