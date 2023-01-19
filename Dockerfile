# Use the official Node.js image as the base image
FROM node:14-alpine

# Create a directory for the backend and set it as the working directory
RUN mkdir -p /usr/src/backend
WORKDIR /usr/src/backend

# Copy the backend package.json and package-lock.json files to the container
COPY backend/package*.json ./

# Install the backend dependencies
RUN npm ci

# Copy the rest of the backend code to the container
COPY backend/. .

# Compile the TypeScript code to JavaScript
RUN npm run build

# Expose the port that the backend app will run on
EXPOSE 3000

# Move to the frontend directory
WORKDIR /usr/src/app/frontend

# Copy the frontend package.json and package-lock.json files to the container
COPY frontend/package*.json ./

# Install the frontend dependencies
RUN npm ci

# Copy the rest of the frontend code to the container
COPY frontend/. .

# Build the frontend
RUN npm run build

# Install nginx
RUN apk add nginx

# Copy nginx config file
COPY nginx.conf /etc/nginx/nginx.conf

# Start the backend
CMD ["npm", "start"]

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
