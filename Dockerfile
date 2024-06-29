FROM ubuntu
RUN apt-get update -y
RUN apt-get install apache2 -y
RUN apt-get install apache2-utils -y
COPY index.html /var/www/html
EXPOSE 80
CMD ["/usr/sbin/apache2ctl" , "-D" , "FOREGROUND"]


