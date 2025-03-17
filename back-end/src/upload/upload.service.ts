/* eslint-disable prettier/prettier */
import { Injectable } from '@nestjs/common';
import { GoogleAuth } from 'google-auth-library';
import * as fs from 'fs';
import * as dotenv from 'dotenv';
import axios from 'axios';

dotenv.config();

interface DocumentAIResponse {
  document?: {
    text?: string;
    entities?: { type: string; mentionText?: string }[];
  };
}

interface CategorizedItem {
  item: string;
  quantity: number;
  price: number;
  category: string;
}

@Injectable()
export class UploadService {
  async processDocument(filePath: string): Promise<{ 
    totalAmount: string; 
    //billDate: string; 
    extractedText: string; 
    categorizedItems: CategorizedItem[] 
  }> {
    try {
      // Authenticate with Google Document AI
      const auth = new GoogleAuth({
        keyFile: process.env.GOOGLE_APPLICATION_CREDENTIALS,
        scopes: ['https://www.googleapis.com/auth/cloud-platform'],
      });

      const client = await auth.getClient();
      const url =
      'https://us-documentai.googleapis.com/v1/projects/664418100697/locations/us/processors/bc3ca3fc5c5ae263:process';

      // Read and encode image
      const image = fs.readFileSync(filePath).toString('base64');

      // Send image to Google Document AI
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

      // Parse response
      const result = response.data as DocumentAIResponse;
      const extractedText = result.document?.text || "No text found";

      let totalAmount = 'Total not found';
      // let billDate = 'Date not found';

      if (result.document?.entities) {
        const amountEntity = result.document.entities.find((entity) =>
          entity.type.toLowerCase().includes('total'),
        );
        if (amountEntity) {
          totalAmount = amountEntity.mentionText || 'Total not found';
        }

        // const dateEntity = result.document.entities.find((entity) =>
        //   entity.type.toLowerCase().includes('date'),
        // );
        // if (dateEntity) {
        //   billDate = dateEntity.mentionText || 'Date not found';
        // }
      }

      console.log(`Extracted Text: ${extractedText}`);
      console.log(`Total Amount: ${totalAmount}`);//, Bill Date: ${billDate}

      // Send extracted text to Flask-based Gemini API
      const geminiResponse = await this.sendToGeminiAPI(extractedText);
      const categorizedItems = geminiResponse?.items || [];

      return { totalAmount,  extractedText, categorizedItems }; //billDate,
    } catch (error) {
      console.error('Error processing document:', error);
      throw new Error('Document processing failed');
    }
  }

  private async sendToGeminiAPI(extractedText: string): Promise<any> {
    try {
      console.log("Sending extracted text to Gemini API:", extractedText);

      const response = await axios.post('http://127.0.0.1:5000/extract-bill', {
        bill_text: extractedText,
      });

      console.log("Gemini API Response:", response.data);
      return response.data;
    } catch (error) {
      console.error('Gemini API error:', error.response ? error.response.data : error.message);
      return { items: [] };
    }
  }
}