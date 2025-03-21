FROM nginx:stable-alpine-slim

COPY ./site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]