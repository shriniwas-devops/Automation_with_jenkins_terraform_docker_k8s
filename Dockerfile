FROM ubuntu/apache2
RUN apt-get update
WORKDIR /var/www/html
COPY webapp/* .
EXPOSE 80
CMD apache2ctl -D FOREGROUND
