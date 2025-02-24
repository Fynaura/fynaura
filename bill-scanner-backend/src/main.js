import express from 'express';
import { AppModule } from './app.module.js';

async function bootstrap() {
  const app = express();
  AppModule.register(app); // Register routes

  app.listen(3000, () => console.log('Server running on port 3000'));
}

bootstrap();




