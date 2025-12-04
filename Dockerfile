FROM nginx:1.14.0-alpine

LABEL maintainer="Richard Chesterwood <richard@inceptiontraining.co.uk>"

# Installer bash si nécessaire
RUN apk add --update bash && rm -rf /var/cache/apk/*

# Vider le contenu par défaut de nginx
RUN rm -rf /usr/share/nginx/html/*

# Copier le contenu de l'application Angular
COPY dist/app /usr/share/nginx/html

# Copier la config Nginx
COPY nginx.conf /etc/nginx/nginx.conf

# Lancer Nginx en foreground
CMD ["nginx", "-g", "daemon off;"]

