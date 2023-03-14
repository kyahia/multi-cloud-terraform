#!/bin/bash
sudo apt-get update -y
sudo apt-get install wget -y
sudo wget https://raw.githubusercontent.com/ixec-lab/simpleAppForTerraform/main/app.py -O ~/app.py
sudo apt-get install python3 -y
sudo python3 ~/app.py&