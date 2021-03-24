FROM debian:buster

WORKDIR /

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install nginx 
RUN apt-get -y install mariadb-server
RUN apt-get -y install wget
RUN apt-get -y install php7.3-fpm php-mysql php-fpm php-pdo php-gd php-cli php-mbstring

RUN wget -c https://wordpress.org/latest.tar.gz
RUN tar -xzf latest.tar.gz && rm -rf latest.tar.gz
RUN mkdir /var/www/localhost
RUN mv wordpress/ /var/www/localhost/wordpress
COPY ./srcs/wp-config.php /var/www/localhost/wordpress
RUN chown -R www-data:www-data /var/www/localhost/wordpress
RUN chmod -R 755 /var/www/localhost/wordpress

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.4-english.tar.gz && rm -rf phpMyAdmin-5.0.4-english.tar.gz
RUN mv phpMyAdmin-5.0.4-english /var/www/localhost/phpmyadmin

COPY ./srcs/config.inc.php /var/www/localhost/phpmyadmin
RUN chmod -R 644 /var/www/localhost/phpmyadmin/config.inc.php

COPY ./srcs/nginx.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

RUN mkdir /var/www/localhost/autoindex
COPY ./srcs/nginx.conf /var/www/localhost/autoindex
COPY ./srcs/autoindex_off.conf /var/www/localhost/autoindex
COPY ./srcs/init.sh .
COPY ./srcs/autoindex_on.sh .
COPY ./srcs/autoindex_off.sh .

RUN openssl req -x509 -nodes \
		-days 365 -newkey rsa:2048 \
		-subj "/CN=localhost/" \
		-keyout /etc/ssl/private/nginx-selfsigned.key \
		-out /etc/ssl/certs/nginx-selfsigned.crt

RUN service mysql start && mysql -u root && mysql --execute="CREATE DATABASE wp_base; \
															CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin'; \
						                                    GRANT ALL PRIVILEGES ON wp_base.* TO 'admin'@'localhost' WITH GRANT OPTION; \
						                                    FLUSH PRIVILEGES;"

EXPOSE 80 443

CMD bash init.sh