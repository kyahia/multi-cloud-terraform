#!/bin/bash

sudo apt-get update -y 
sudo apt-get install apache2 -y
sudo sh -c 'echo "<h1>Hello world</h1>" + $(hostname) > /var/www/html/index.html'

