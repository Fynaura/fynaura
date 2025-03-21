import { Controller, Post, UploadedFile, UseInterceptors, Res } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { UploadService } from './upload.service';
import { Express, Response } from 'express';

@Controller('upload')
export class UploadController {
  constructor(private readonly uploadService: UploadService) {}

  @Post()
  @UseInterceptors(FileInterceptor('image'))
  async uploadFile(@UploadedFile() file: Express.Multer.File, @Res() res: Response) {
    if (!file) {
      return res.status(400).json({ error: 'No file uploaded.' });
    }

    console.log('Image received:', file.path);

    try {
      const { totalAmount,  extractedText, categorizedItems } = await this.uploadService.processDocument(file.path);//billDate,

      console.log(`Total Amount: ${totalAmount}`);
      //console.log(`Bill Date: ${billDate}`);
      console.log(`Extracted Text: ${extractedText}`);
      console.log(`Categorized Items:`, categorizedItems);

      return res.status(200).json({
        totalAmount,
        //billDate,  // This will now be in 'YYYY-MM-DD' format
        extractedText,
        categorizedItems
      });
    } catch (error) {
      console.error('Error processing document:', error);
      return res.status(500).json({ error: error.message });
    }
  }
}
