FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the container
# COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Build the React application
RUN npm run build

# Use a lightweight web server to serve the built files
FROM nginx:alpine

# Copy the built files to the Nginx web server's directory
COPY --from=0 /app/build /usr/share/nginx/html

# Expose port 80 for the application
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]