#!/bin/bash

sudo apt update -y
sudo apt install apache2 -y
echo "<hmtl><h1> hello world $(hostname) </h1></html>" > /var/www/html/index.html

