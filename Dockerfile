FROM nginx:1.14.0-alpine

LABEL maintainer="Richard Chesterwood <richard@inceptiontraining.co.uk>"

RUN apk add --update bash && rm -rf /var/cache/apk/*

RUN rm -rf /usr/share/nginx/html/*

COPY dist/app1 /usr/share/nginx/html/app1
COPY dist/app2 /usr/share/nginx/html/app2

COPY nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]

