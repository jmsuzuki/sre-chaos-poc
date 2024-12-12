# Use official Node.js runtime as the base image
FROM node:22

# Set the working directory
WORKDIR /opt/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY src /opt/app/src
COPY README.md /opt/app/README.md

# Expose the application port
EXPOSE 3000

# Command to run the application
CMD ["npm", "run", "start"]
