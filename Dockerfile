FROM ubuntu
RUN apt-get update -y
RUN apt-get install apache2 -y
RUN apt-get install unzip -y
ADD https://www.free-css.com/assets/files/free-css-templates/download/page294/jobentry.zip /var/www/html
WORKDIR /var/www/html
RUN unzip jobentry.zip
RUN cp -rvf job-portal-website-template/* .
RUN rm -rf job-portal-website-template jobentry.zip
EXPOSE 80
CMD ["/usr/sbin/apache2ctl" , "-D" , "FOREGROUND"]
