#!/bin/bash

# Updating the apt package manager and installing net-tools
sudo apt update
sudo apt install net-tools

# Install sshpass for handling password
sudo apt-get install sshpass

# Create altschool user and add to sudoers
sudo useradd -m -s /bin/bash altschool && sudo usermod -aG sudo altschool

# Create ssh key for the altschool user
sudo su altschool -c 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'

# Copy ssh key from the master machine (altschool user) to the slave machine
sudo su altschool -c 'sshpass -p "vagrant" ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no vagrant@192.168.33.10'

# Create the /mnt/altschool folder 
echo "Creating /mnt/altschool folder..."
sudo su altschool -c 'sudo mkdir /mnt/altschool'

# Process Monitoring 
echo "Displaying running processes..."
ps aux

# Install LAMP stack (Apache, Php, MySQL) and enabling apache2 to start at boot time

# Apache2 installation
sudo apt install -y apache2

# Enabling apache at boot time
sudo systemctl enable apache2

# Php installation
sudo apt install -y php libapache2-mod-php php-mysql 
sudo systemctl restart apache2

# MySQL installation
sudo apt install -y mysql-server

# My default username and password
MYSQL_USER="master"
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