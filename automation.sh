name="praneethbussa"
s3_bucket="upgrad-bussa"

#update system
sudo apt update -y

#to check package is install or not
dpkg -s apache2

#if apache2 is not install then install it
if [ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ];

then

        apt install apache2 -y

#to check service is running or not if not running then start it
fi

service_running=$(systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()')

if [ running != ${service_running} ];

then

        systemctl start apache2

fi

#to check service is enabled or not if not then enable it
service_enable=$(systemctl is-enabled apache2 | grep "enabled")

if [ enabled != ${service_enable} ];

then

        systemctl enable apache2

fi

#timestamp variable hold date and time
timestamp=$(date '+%d%m%Y-%H%M%S')

cd /var/log/apache2

#tar creation with name and timestamp
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

#if tar file present then move it to s3 bucket
if [ -f /tmp/${name}-httpd-logs-${timestamp}.tar ];

then
aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar

fi
