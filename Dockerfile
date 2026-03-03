# Multi-stage Dockerfile for Create React App

# 1. Build the React app using Node.js
FROM node:18-alpine AS build

# set working directory
WORKDIR /app

# copy dependency manifests
COPY package.json package-lock.json ./

# install dependencies
RUN npm ci

# copy the rest of the source code
COPY . .

# build the app for production
RUN npm run build

# 2. Serve the compiled app with Nginx
FROM nginx:stable-alpine

# remove default nginx static assets
RUN rm -rf /usr/share/nginx/html/*

# copy build output from previous stage
COPY --from=build /app/build /usr/share/nginx/html

# expose port
EXPOSE 80

# start nginx
CMD ["nginx", "-g", "daemon off;"]
