FROM node:12-alpine

RUN apk add --no-cache nginx 

COPY docker-local/start.sh /app/start.sh

COPY server /app/server
COPY client /app/client

COPY docker-local/nginx/default /etc/nginx/sites-available/default
COPY docker-local/nginx/nginx.conf /etc/nginx/nginx.conf

RUN \
    chown nginx -R /var/www /var/log/nginx /app

WORKDIR /app/server
USER nginx

CMD ["/app/start.sh"]

