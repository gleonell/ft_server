#!/bin/bash
cp /var/www/localhost/autoindex/nginx.conf /etc/nginx/sites-available/
rm -f /etc/nginx/sites-enabled/default
rm -f /etc/nginx/sites-enabled/autoindex_off.conf
ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
service nginx restart
echo "autoindex on"