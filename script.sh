#!/bin/bash

sudo apt update -y
sudo apt install apache2 -y
echo "<h1>Hello world</h1>" $(hostname) > /var/www/html/index.html

