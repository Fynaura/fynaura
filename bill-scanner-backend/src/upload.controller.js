import express from 'express';
import multer from 'multer';
import fs from 'fs';
import { GoogleAuth } from 'google-auth-library';
import dotenv from 'dotenv';

dotenv.config();

const upload = multer({ dest: 'uploads/' });

export class UploadController {
  constructor() {
    this.router = express.Router();
    this.router.post('/', upload.single('image'), this.uploadFile);
  }

  async uploadFile(req, res) {
    const file = req.file;
    if (!file) {
      return res.status(400).json({ error: 'No file uploaded.' });
    }

    console.log("Image received:", file.path);

    try {
      const result = await processDocument(file.path);

      // Extract text from response
      //const extractedText = result.document?.text || "No text found";

      // Extract total amount using Document AI
      let totalAmount = "Total not found";
      let billDate = "Date not found";

      if (result.document?.entities) {
        // Extract total amount
        const amountEntity = result.document.entities.find(entity => entity.type.toLowerCase().includes("total"));
        if (amountEntity) {
          totalAmount = amountEntity.mentionText || "Total not found";
        }

        // Extract bill date
        const dateEntity = result.document.entities.find(entity => entity.type.toLowerCase().includes("date"));
        if (dateEntity) {
          billDate = dateEntity.mentionText || "Date not found";
        }
      }

      //console.log(`Extracted Text: ${extractedText}`);
      console.log(`Total Amount: ${totalAmount}`);
      console.log(`Bill Date: ${billDate}`);

      // Remove the uploaded file after processing
      fs.unlinkSync(file.path);

      res.json({ totalAmount,billDate }); //totalAmount and billDate, 
    } catch (error) {
      console.error("Error processing document:", error);
      res.status(500).json({ error: error.message });
    }
  }
}

// Function to process document using Google Document AI
async function processDocument(filePath) {
  const auth = new GoogleAuth({
    keyFile: process.env.GOOGLE_APPLICATION_CREDENTIALS,
    scopes: ["https://www.googleapis.com/auth/cloud-platform"],
  });
  const client = await auth.getClient();
  const url = "https://us-documentai.googleapis.com/v1/projects/664418100697/locations/us/processors/bc3ca3fc5c5ae263:process";

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

  return response.data;
}





