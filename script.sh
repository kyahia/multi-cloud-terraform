sudo apt-get update -y &&\
sudo apt-get install apache2 -y &&\
sudo service apache2 start &&\
sudo chmod 777 /var/www/html/* &&\
sudo chown $USER:$USER /var/www/* &&\
sudo rm /var/www/html/* &&\
sudo echo "<h1>Hello world</h1>" $(hostname) > /var/www/html/index.html