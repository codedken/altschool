#!/bin/bash

# Updating the apt package manager and installing net-tools
sudo apt update
sudo apt install net-tools

# Enabling password authentication
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

# Create the /mnt/altschool/slave folder
sudo mkdir /mnt/altschool && sudo mkdir /mnt/altschool/slave

# Install LAMP stack (Apache, Php, MySQL) and enabling apache to start at boot time

# Apache installation
sudo apt install -y apache2

# Starting apache at boot time
sudo systemctl enable apache2

# Php installation
sudo apt install -y php libapache2-mod-php php-mysql
sudo systemctl restart apache2

# MySQL installation
sudo apt install -y mysql-server

# My default username and password
MYSQL_USER="slave"
MYSQL_PASS="12345678"

# Set the default username and password
echo "setting default username and password..."
mysql -u root -p <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$MYSQL_PASS';
CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY '$MYSQL_PASS';
GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF

# Secure the MySQL installation