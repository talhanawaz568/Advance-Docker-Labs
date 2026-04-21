FROM nginx:1.25-alpine

# Copy custom configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Create non-root user
RUN addgroup -g 1000 -S nginx-user && \
    adduser -S -D -H -u 1000 -h /var/cache/nginx -s /sbin/nologin -G nginx-user -g nginx-user nginx-user

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
