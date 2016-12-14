#!/bin/sh
sudo rm /etc/nginx/sites-enabled/default
sudo cp nginx-SandersFanClub.conf /etc/nginx/sites-enabled/
sudo cp -r webroot/ /var/www/sanders/
sudo nginx -t
