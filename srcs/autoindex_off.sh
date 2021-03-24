#!/bin/bash
cp /var/www/localhost/autoindex/autoindex_off.conf /etc/nginx/sites-available/
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/nginx.conf
ln -s /etc/nginx/sites-available/autoindex_off.conf /etc/nginx/sites-enabled/
service nginx restart
echo "autoindex off"