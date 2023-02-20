FROM ubuntu/apache2
RUN apt-get update && rm -rf /var/www/html/*
COPY ./web-app /var/www/html/
EXPOSE 80
CMD apache2ctl -D FOREGROUND
