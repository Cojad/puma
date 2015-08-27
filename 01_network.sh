#!/bin/bash
name=puma5
#############################
file1=/etc/hosts
#############################
if [ $file1 ]; then
	cp $file1 $file1.old
	echo 127.0.0.1   $name.titan.com.tw $name localhost localhost.localdomain > /etc/hosts
	echo -- diff start -- $file1 $file1.old
	diff $file1 $file1.old
	echo -- diff  end  -- $file1 $file1.old
	echo
fi
#############################
file2=/etc/sysconfig/network
#############################
if [ $file2 ]; then
	cp $file2 $file2.old
	echo NETWORKING=yes >$file2
	echo HOSTNAME=$name >>$file2
	cat <<EOT >> $file2
NOZEROCONF=yes
NETWORKING_IPV6=no
IPV6INIT=no
IPV6_ROUTER=no
IPV6_AUTOCONF=no
IPV6FORWARDING=no
IPV6TO4INIT=no
IPV6_CONTROL_RADVD=no
EOT
	echo -- diff start -- $file2 $file2.old
	diff $file2 $file2.old
	echo -- diff  end  -- $file2 $file2.old
	echo
fi
#############################
file3=/etc/sysconfig/clock
#############################
if [ $file3 ]; then
	cp $file3 $file3.old
	cat <<EOT > $file3
ZONE="Asia/Taipei"
UTC=true
EOT
	echo -- diff start -- $file3 $file3.old
	diff $file3 $file3.old
	echo -- diff  end  -- $file3 $file3.old
	echo
	echo export LANG=zh_TW.UTF-8>> /home/ec2-user/.bash_profile
	echo export TZ=/usr/share/zoneinfo/Asia/Taipei>> /home/ec2-user/.bash_profile
	ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
	echo setup .bash_profile env for LANG/TZ
fi
#############################
file4=/etc/rsyslog.conf
#############################
if [ $file4 ]; then
	cp $file4 $file4.old
	sed -i 's/\(\$ActionFileDefaultTemplate\) \(.*\)/$template MyFormat,"<%syslogseverity%>%timegenerated:3:$:date-mysql% %timegenerated:8:$% %HOSTNAME% %syslogtag%%msg:::sp-if-no-1st-sp%%msg:::drop-last-lf%\\n\n\1 MyFormat/' $file4
	echo -- diff start -- $file4 $file4.old
	diff $file4 $file4.old
	echo -- diff  end  -- $file4 $file4.old
fi
#############################
file5=/etc/fstab
#############################
if [ $file5 ]; then
	cp $file5 $file5.old
	echo -- 目前分割 --
	lsblk
	mkfs -t ext4 /dev/xvdb
	mkfs -t ext4 /dev/xvdc
	mkdir /www
	mkdir /x1
	mount /dev/xvdb /www
	mount /dev/xvdc /x1
	echo -- 掛載分割 --
	lsblk
	cat <<EOT >> $file5
/dev/xvdb   /www        ext4    defaults,nofail 0   2
/dev/xvdc   /x1         ext4    defaults,nofail 0   2
EOT
	sudo umount /dev/xvdb
	sudo umount /dev/xvdc
	sudo mount -a
	echo -- 重掛分割 --
	lsblk
	echo -- diff start -- $file5 $file5.old
	diff $file5 $file5.old
	echo -- diff  end  -- $file5 $file5.old
fi
#############################
