#!/bin/bash
yum update -y
yum install git -y
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>Welcome To My Webpage</h1></html>" > index.html
