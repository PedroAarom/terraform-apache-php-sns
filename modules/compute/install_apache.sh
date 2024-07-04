sudo yum update -y
sudo yum install httpd -y
sudo service httpd start
sudo chkconfig httpd on

cd /var/www/html

sudo yum install php php-cli php-json php-mbstring -y
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php
sudo php -r "unlink('composer-setup.php');"
sudo COMPOSER_ALLOW_SUPERUSER=1 php composer.phar require aws/aws-sdk-php
sudo service httpd restart