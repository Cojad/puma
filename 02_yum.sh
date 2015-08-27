#!/bin/bash
name=puma5
#############################
file6=/etc/yum/yum-cron.conf
#############################
if [ $file6 ]; then
	yum update -y
	yum -y install yum-cron
	cp $file6 $file6.old
	sed -i 's/^email_to = \(.*\)/email_to = xcojad@gmail.com/' $file4
	chkconfig yum-cron on
	service yum-cron start
fi


#############################
file7=安裝一卡車的東西
#############################
if [ $file7 ]; then
	cat <<EOT > /etc/yum.repos.d/mariadb.repo
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.0/centos6-amd64
gpgkey = https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOT
	yum install mutt git php56 php56-mysqlnd php56-mcrypt php56-mbstring php56-gd mod24_ssl php-pear php56-devel gcc make zlib-devel MariaDB perl-devel
	pecl channel-update pecl.php.net
	pecl install zip
	(wget -O - pi.dk/3 || curl pi.dk/3/) | bash
	rm -Rf parallel-*
fi
