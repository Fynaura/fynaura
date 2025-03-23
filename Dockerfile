FROM node:18-alpine

WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./
RUN npm ci

# Copy the rest of the application
COPY . .

# Build application
RUN npm run build

# Don't run tests in Dockerfile - they've already run in the CI pipeline
# RUN npm run test

# Expose port (adjust as needed for your app)
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start:prod"]