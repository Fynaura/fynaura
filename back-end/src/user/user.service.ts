/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
/* eslint-disable @typescript-eslint/no-unsafe-return */
// /* eslint-disable prettier/prettier */
// import { HttpException, HttpStatus, Injectable } from '@nestjs/common';

// import { RegisterUserDto } from './dto/register-user.dto';
// import * as firebaseAdmin from 'firebase-admin';
// import { LoginDto } from './dto/login.dto';
// import axios from 'axios';

// @Injectable()
// export class UserService {

//   async registerUser(registerUser: RegisterUserDto) {
//     console.log(registerUser);
//         // Validate that password and confirmPassword match
//         if (registerUser.password !== registerUser.confirmPassword) {
//           throw new HttpException(
//             'Passwords do not match',
//             HttpStatus.BAD_REQUEST,
//           );
//         }

//     try {
//       const userRecord = await firebaseAdmin.auth().createUser({
//         displayName: registerUser.firstName,
//         email: registerUser.email,
//         password: registerUser.password,
//       });
//       console.log('User Record:', userRecord);
//       return userRecord;
//     } catch (error) {
//       console.error('Error creating user:', error);
//       throw new Error('User registration failed'); // Handle errors gracefully
//     }
//   }

//   async loginUser(payload: LoginDto) {
//     const { email, password } = payload;
//     try {
//       const { idToken, refreshToken, expiresIn } =
//         await this.signInWithEmailAndPassword(email, password);
//       return { idToken, refreshToken, expiresIn };
//     } catch (error: any) {
//       if (error.message.includes('EMAIL_NOT_FOUND')) {
//         throw new Error('User not found.');
//       } else if (error.message.includes('INVALID_PASSWORD')) {
//         throw new Error('Invalid password.');
//       } else {
//         throw new Error(error.message);
//       }
//     }
//   }
//   private async signInWithEmailAndPassword(email: string, password: string) {
//     const url = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${process.env.APIKEY}`;
//     return await this.sendPostRequest(url, {
//       email,
//       password,
//       returnSecureToken: true,
//     });
//   }
//   private async sendPostRequest(url: string, data: any) {
//     try {
//       const response = await axios.post(url, data, {
//         headers: { 'Content-Type': 'application/json' },
//       });
//       return response.data;
//     } catch (error) {
//       console.log('error', error);
//     }
//   }

//   async validateRequest(req): Promise<boolean> {
//     const authHeader = req.headers['authorization'];
//     if (!authHeader) {
//       console.log('Authorization header not provided.');
//       return false;
//     }
//     const [bearer, token] = authHeader.split(' ');
//     if (bearer !== 'Bearer' || !token) {
//       console.log('Invalid authorization format. Expected "Bearer <token>".');
//       return false;
//     }
//     try {
//       const decodedToken = await firebaseAdmin.auth().verifyIdToken(token);
//       console.log('Decoded Token:', decodedToken);
//       return true;
//     } catch (error) {
//       if (error.code === 'auth/id-token-expired') {
//         console.error('Token has expired.');
//       } else if (error.code === 'auth/invalid-id-token') {
//         console.error('Invalid ID token provided.');
//       } else {
//         console.error('Error verifying token:', error);
//       }
//       return false;
//     }
//   }

//   async refreshAuthToken(refreshToken: string) {
//     try {
//       const {
//         id_token: idToken,
//         refresh_token: newRefreshToken,
//         expires_in: expiresIn,
//       } = await this.sendRefreshAuthTokenRequest(refreshToken);
//       return {
//         idToken,
//         refreshToken: newRefreshToken,
//         expiresIn,
//       };
//     } catch (error: any) {
//       if (error.message.includes('INVALID_REFRESH_TOKEN')) {
//         throw new Error(`Invalid refresh token: ${refreshToken}.`);
//       } else {
//         throw new Error('Failed to refresh token');
//       }
//     }
//   }
//   private async sendRefreshAuthTokenRequest(refreshToken: string) {
//     const url = `https://securetoken.googleapis.com/v1/token?key=${process.env.APIKEY}`;
//     const payload = {
//       grant_type: 'refresh_token',
//       refresh_token: refreshToken,
//     };
//     return await this.sendPostRequest(url, payload);
//   }

//   // create(createUserDto: CreateUserDto) {
//   //   return 'This action adds a new user';
//   // }

//   findAll() {
//     return `This action returns all user`;
//   }

//   // findOne(id: number) {
//   //   return `This action returns a #${id} user`;
//   // }

//   // update(id: number, updateUserDto: UpdateUserDto) {
//   //   return `This action updates a #${id} user`;
//   // }

//   // remove(id: number) {
//   //   return `This action removes a #${id} user`;
//   // }
// }
/* eslint-disable prettier/prettier */
import { HttpException, HttpStatus, Injectable } from '@nestjs/common';

import { RegisterUserDto } from './dto/register-user.dto';
import * as firebaseAdmin from 'firebase-admin';
import { LoginDto } from './dto/login.dto';
import axios from 'axios';

@Injectable()
export class UserService {
  async registerUser(registerUser: RegisterUserDto) {
    console.log(registerUser);
    // Validate that password and confirmPassword match
    if (registerUser.password !== registerUser.confirmPassword) {
      throw new HttpException('Passwords do not match', HttpStatus.BAD_REQUEST);
    }

    try {
      const userRecord = await firebaseAdmin.auth().createUser({
        displayName: registerUser.firstName,
        email: registerUser.email,
        password: registerUser.password,
      });
      console.log('User Record:', userRecord);

      // Return a formatted response instead of the raw user object
      return {
        success: true,
        message: 'User registered successfully please Login ',
        userId: userRecord.uid,
      };
    } catch (error) {
      console.error('Error creating user:', error);
      // Check for specific Firebase errors
      if (error.code === 'auth/email-already-exists') {
        throw new HttpException('Email already in use', HttpStatus.CONFLICT);
      } else if (error.code === 'auth/invalid-email') {
        throw new HttpException('Invalid email format', HttpStatus.BAD_REQUEST);
      } else if (error.code === 'auth/weak-password') {
        throw new HttpException('Password is too weak', HttpStatus.BAD_REQUEST);
      } else {
        throw new HttpException(
          'User registration failed',
          HttpStatus.INTERNAL_SERVER_ERROR,
        );
      }
    }
  }

  async loginUser(payload: LoginDto) {
    const { email, password } = payload;
    try {
      const { idToken, refreshToken, expiresIn } =
        await this.signInWithEmailAndPassword(email, password);
        const decodedToken = await firebaseAdmin.auth().verifyIdToken(idToken);
        const userId = decodedToken.uid; 
        console.log('Logged in user UID:', userId);
      return { idToken, refreshToken, expiresIn, uid:userId};
    } catch (error: any) {
      if (error.message.includes('EMAIL_NOT_FOUND')) {
        throw new Error('User not found.');
      } else if (error.message.includes('INVALID_PASSWORD')) {
        throw new Error('Invalid password.');
      } else {
        throw new Error(error.message);
      }
    }
  }
  private async signInWithEmailAndPassword(email: string, password: string) {
    const url = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${process.env.APIKEY}`;
    return await this.sendPostRequest(url, {
      email,
      password,
      returnSecureToken: true,
      
    });
  }
  private async sendPostRequest(url: string, data: any) {
    try {
      const response = await axios.post(url, data, {
        headers: { 'Content-Type': 'application/json' },
      });
      return response.data;
    } catch (error) {
      console.log('error', error);
    }
  }

  async validateRequest(req): Promise<boolean> {
    const authHeader = req.headers['authorization'];
    if (!authHeader) {
      console.log('Authorization header not provided.');
      return false;
    }
    const [bearer, token] = authHeader.split(' ');
    if (bearer !== 'Bearer' || !token) {
      console.log('Invalid authorization format. Expected "Bearer <token>".');
      return false;
    }
    try {
      const decodedToken = await firebaseAdmin.auth().verifyIdToken(token);
      console.log('Decoded Token:', decodedToken);
      return true;
    } catch (error) {
      if (error.code === 'auth/id-token-expired') {
        console.error('Token has expired.');
      } else if (error.code === 'auth/invalid-id-token') {
        console.error('Invalid ID token provided.');
      } else {
        console.error('Error verifying token:', error);
      }
      return false;
    }
  }

  async refreshAuthToken(refreshToken: string) {
    try {
      const {
        id_token: idToken,
        refresh_token: newRefreshToken,
        expires_in: expiresIn,
      } = await this.sendRefreshAuthTokenRequest(refreshToken);
      return {
        idToken,
        refreshToken: newRefreshToken,
        expiresIn,
      };
    } catch (error: any) {
      if (error.message.includes('INVALID_REFRESH_TOKEN')) {
        throw new Error(`Invalid refresh token: ${refreshToken}.`);
      } else {
        throw new Error('Failed to refresh token');
      }
    }
  }
  private async sendRefreshAuthTokenRequest(refreshToken: string) {
    const url = `https://securetoken.googleapis.com/v1/token?key=${process.env.APIKEY}`;
    const payload = {
      grant_type: 'refresh_token',
      refresh_token: refreshToken,
    };
    return await this.sendPostRequest(url, payload);
  }

  findAll() {
    return `This action returns all user`;
  }

  async getUserDetails(idToken: string) {
    try {
      // Verify the idToken with Firebase Admin SDK
      const decodedToken = await firebaseAdmin.auth().verifyIdToken(idToken);
      const uid = decodedToken.uid; // Extract UID from the decoded token
  
      // Now, fetch the user's details from Firebase using the UID
      const userRecord = await firebaseAdmin.auth().getUser(uid);
  
      // You can return user details here
      return {
        uid: userRecord.uid,
        email: userRecord.email,
        displayName: userRecord.displayName,
      };
    } catch (error) {
      console.error('Error fetching user details:', error);
      throw new HttpException('Unable to fetch user details', HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
  
}
