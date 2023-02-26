#!/bin/bash
sudo sh -c 'apt-get update && apt-get upgrade -y && apt-get install apache2 -y'
sudo sh -c 'echo "<h1>Hello world</h1>" $(hostname) > /var/www/html/index.html'