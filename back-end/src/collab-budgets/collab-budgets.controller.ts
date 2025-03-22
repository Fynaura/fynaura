/* eslint-disable @typescript-eslint/no-unsafe-member-access */
// /* eslint-disable prettier/prettier */

// /* eslint-disable @typescript-eslint/no-unsafe-assignment */
// /* eslint-disable prettier/prettier */
// /* eslint-disable @typescript-eslint/no-unsafe-argument */
// import {
//   Controller,
//   Get,
//   Post,
//   Body,
//   Param,
//   Patch,
//   Delete,
//   Query,
// } from '@nestjs/common';
// import { CollabBudgetsService } from './collab-budgets.service';
// import { CreateBudgetDto } from './dto/create-budget.dto';
// import { UpdateBudgetDto } from './dto/update-budget.dto';
// import { AddTransactionDto } from './dto/add-transaction.dto';
// import { UserService } from '../user/user.service';

// @Controller('collab-budgets')
// export class CollabBudgetsController {
//   constructor(
//     private readonly collabBudgetsService: CollabBudgetsService,
//     private readonly userService: UserService,
//   ) {}

//   @Post()
//   create(@Body() createBudgetDto: CreateBudgetDto) {
//     return this.collabBudgetsService.create(createBudgetDto);
//   }

//   @Get()
//   findAll(@Query('userId') userId?: string) {
//     return this.collabBudgetsService.findAll(userId);
//   }

//   @Get(':id')
//   findOne(@Param('id') id: string) {
//     return this.collabBudgetsService.findOne(id);
//   }

//   @Patch(':id')
//   update(@Param('id') id: string, @Body() updateBudgetDto: UpdateBudgetDto) {
//     return this.collabBudgetsService.update(id, updateBudgetDto);
//   }

//   @Delete(':id')
//   remove(@Param('id') id: string) {
//     return this.collabBudgetsService.delete(id);
//   }

//   @Post(':id/transactions')
//   addTransaction(
//     @Param('id') id: string,
//     @Body() addTransactionDto: AddTransactionDto,
//   ) {
//     return this.collabBudgetsService.addTransaction(id, addTransactionDto);
//   }

//   @Get('collab-budgets')
//   findAllForUser(
//     @Query('userId') userId: string,
//     @Query('includeCollaborative') includeCollaborative: boolean = true,
//   ) {
//     return this.collabBudgetsService.findAllForUser(
//       userId,
//       includeCollaborative,
//     );
//   }

//   @Patch(':id/collaborators')
//   addCollaborator(@Param('id') id: string, @Body('userId') userId: string) {
//     return this.collabBudgetsService.addCollaborator(id, userId);
//   }

//   // Fixed endpoint to use the instance method
//   @Get('check-exists/:userId')
//   async checkUserExists(@Param('userId') userId: string) {
//     const userExists = await this.userService.checkUserExists(userId);

//     return { exists: userExists };

//   }
// }
/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable prettier/prettier */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Patch,
  Delete,
  Query,
} from '@nestjs/common';
import { CollabBudgetsService } from './collab-budgets.service';
import { CreateBudgetDto } from './dto/create-budget.dto';
import { UpdateBudgetDto } from './dto/update-budget.dto';
import { AddTransactionDto } from './dto/add-transaction.dto';
import { UserService } from '../user/user.service';

@Controller('collab-budgets')
export class CollabBudgetsController {
  constructor(
    private readonly collabBudgetsService: CollabBudgetsService,
    private readonly userService: UserService,
  ) {}

  @Post()
  create(@Body() createBudgetDto: CreateBudgetDto) {
    return this.collabBudgetsService.create(createBudgetDto);
  }

  @Get()
  findAll(@Query('userId') userId?: string) {
    return this.collabBudgetsService.findAll(userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.collabBudgetsService.findOne(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateBudgetDto: UpdateBudgetDto) {
    return this.collabBudgetsService.update(id, updateBudgetDto);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.collabBudgetsService.delete(id);
  }

  @Post(':id/transactions')
  addTransaction(
    @Param('id') id: string,
    @Body() addTransactionDto: AddTransactionDto,
  ) {
    return this.collabBudgetsService.addTransaction(id, addTransactionDto);
  }

  // This endpoint had a conflict with the root controller path
  @Get('user-budgets')
  findAllForUser(
    @Query('userId') userId: string,
    @Query('includeCollaborative') includeCollaborative: boolean = true,
  ) {
    return this.collabBudgetsService.findAllForUser(
      userId,
      includeCollaborative,
    );
  }

  // @Patch(':id/collaborators')
  // addCollaborator(@Param('id') id: string, @Body('userId') userId: string) {
  //   return this.collabBudgetsService.addCollaborator(id, userId);
  // }

  @Patch(':id/collaborators')
  async addCollaborator(
    @Param('id') id: string,
    @Body('userId') userId: string,
  ) {
    try {
      // First check if user exists
      const userExists = await this.userService.checkUserExists(userId);
      if (!userExists) {
        return { success: false, message: 'User does not exist' };
      }

      // Then add as collaborator
      return this.collabBudgetsService.addCollaborator(id, userId);
    } catch (error) {
      console.error('Error adding collaborator:', error);
      return { success: false, message: error.message };
    }
  }

  // Fixed the path to ensure it's properly registered
  // @Get('check-exists/:userId')
  // async checkUserExists(@Param('userId') userId: string) {
  //   try {
  //     const userExists = await this.userService.checkUserExists(userId);
  //     // For the user check endpoint, also fetch the user's budgets if the user exists
  //     if (userExists) {
  //       const budgets = await this.collabBudgetsService.findAllForUser(
  //         userId,
  //         true,
  //       );
  //       return budgets; // Return budgets array directly to match Flutter expectation
  //     }
  //     return { exists: userExists };
  //   } catch (error) {
  //     console.error('Error checking user/fetching budgets:', error);
  //     return { error: error.message };
  //   }
  // }

  // @Get('check-exists/:userId')
  // async checkUserExists(@Param('userId') userId: string) {
  //   const userExists = await this.userService.checkUserExists(userId);

  //   return { exists: userExists };
  // }
  @Get('check-exists/:userId')
  async checkUserExists(@Param('userId') userId: string) {
    try {
      const userExists = await this.userService.checkUserExists(userId);

      if (userExists) {
        const budgets = await this.collabBudgetsService.findAllForUser(
          userId,
          true,
        );
        return { exists: userExists, budgets };
      }

      return { exists: userExists };
    } catch (error) {
      console.error('Error checking user existence:', error);
      return { error: error.message };
    }
  }
}
