/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable prettier/prettier */
import {
  Controller,
  Post,
  Body,
  ValidationPipe,
  UsePipes,
  Get,
  Query,
  Param,
} from '@nestjs/common';
import { UserService } from './user.service';

import { RegisterUserDto } from './dto/register-user.dto';
import { LoginDto } from './dto/login.dto';
import { ApiBearerAuth, ApiResponse } from '@nestjs/swagger';
import { SendPasswordResetDto } from './dto/send-password-reset.dto';

@Controller('user')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Post('register')
  @UsePipes(new ValidationPipe({ transform: true }))
  registerUser(@Body() registerUserDTo: RegisterUserDto) {
    return this.userService.registerUser(registerUserDTo);
  }

  @Post('login')
  @UsePipes(new ValidationPipe({ transform: true }))
  login(@Body() loginDto: LoginDto) {
    return this.userService.loginUser(loginDto);
  }

  @Get()
  @ApiBearerAuth()
  findAll() {
    return this.userService.findAll();
  }

  @Post('refresh-auth')
  refreshAuth(@Query('refreshToken') refreshToken: string) {
    return this.userService.refreshAuthToken(refreshToken);
  }

  @Get('me')
  async getUserDetails(@Query('idToken') idToken: string) {
    return await this.userService.getUserDetails(idToken);
  }

  @Post('password-reset')
  @ApiResponse({
    status: 200,
    description: 'Password reset link sent successfully.',
  })
  @ApiResponse({
    status: 400,
    description: 'Invalid email format or user not found.',
  })
  async sendPasswordResetLink(
    @Body() sendPasswordResetDto: SendPasswordResetDto,
  ) {
    return this.userService.sendPasswordResetLink(sendPasswordResetDto.email);
  }

  @Get('check-exists/:userId')
  async checkUserExists(@Param('userId') userId: string) {
    const exists = await this.userService.checkUserExists(userId);
    return { exists };
  }
}
//   @Post()
//   create(@Body() createUserDto: CreateUserDto) {
//     return this.userService.create(createUserDto);
//   }

//   @Get()
//   findAll() {
//     return this.userService.findAll();
//   }

//   @Get(':id')
//   findOne(@Param('id') id: string) {
//     return this.userService.findOne(+id);
//   }

//   @Patch(':id')
//   update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
//     return this.userService.update(+id, updateUserDto);
//   }

//   @Delete(':id')
//   remove(@Param('id') id: string) {
//     return this.userService.remove(+id);
//   }
