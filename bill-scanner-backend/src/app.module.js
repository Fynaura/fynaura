import { UploadController } from './upload.controller.js';

export class AppModule {
  static register(app) {
    app.use('/upload', new UploadController().router);
  }
}




