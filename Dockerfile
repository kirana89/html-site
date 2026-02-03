# Use the official Nginx image
FROM nginx:alpine

# Copy HTML file to Nginx's default location
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
