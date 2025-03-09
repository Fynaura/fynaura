import { Injectable } from '@nestjs/common';
import { GoogleAuth } from 'google-auth-library';
import * as fs from 'fs';
import * as dotenv from 'dotenv';

dotenv.config();

interface DocumentAIResponse {
  document?: {
    text?: string; // Added missing 'text' property
    entities?: { type: string; mentionText?: string }[];
  };
}

@Injectable()
export class UploadService {
  async processDocument(filePath: string): Promise<{ totalAmount: string; billDate: string; extractedText: string }> {
    const auth = new GoogleAuth({
      keyFile: process.env.GOOGLE_APPLICATION_CREDENTIALS,
      scopes: ['https://www.googleapis.com/auth/cloud-platform'],
    });

    const client = await auth.getClient();
    const url =
      'https://us-documentai.googleapis.com/v1/projects/664418100697/locations/us/processors/bc3ca3fc5c5ae263:process';

    const image = fs.readFileSync(filePath).toString('base64');

    const response = await client.request({
      url,
      method: 'POST',
      data: {
        rawDocument: {
          content: image,
          mimeType: 'image/jpeg',
        },
      },
    });

    // Ensure TypeScript knows the structure of `response.data`
    const result = response.data as DocumentAIResponse;

    // Fix: Check if `text` property exists and extract it
    const extractedText = result.document?.text || "No text found"; 

    let totalAmount = 'Total not found';
    let billDate = 'Date not found';

    if (result.document?.entities) {
      const amountEntity = result.document.entities.find((entity) =>
        entity.type.toLowerCase().includes('total'),
      );
      if (amountEntity) {
        totalAmount = amountEntity.mentionText || 'Total not found';
      }

      const dateEntity = result.document.entities.find((entity) =>
        entity.type.toLowerCase().includes('date'),
      );
      if (dateEntity) {
        billDate = dateEntity.mentionText || 'Date not found';
      }
    }

    return { totalAmount, billDate, extractedText }; // Fixed return type to include extractedText
  }
}



