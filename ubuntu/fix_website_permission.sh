#!/bin/bash
sudo chown -R www-data:www-data /storage/wwwroot/*
sudo chmod -R 550 /storage/wwwroot/*
find /storage/wwwroot/ -type d |grep "/sites" |grep "/files" |xargs sudo chmod -R g+w
find /storage/wwwroot/ -type d |grep "/sites" |grep "/sec" |xargs sudo chmod -R g+w
find /storage/wwwroot/ -type f |grep "/.htaccess" |xargs sudo chmod g-w
