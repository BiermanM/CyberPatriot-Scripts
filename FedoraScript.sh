#!/bin/bash
clear
echo "Created by Matthew Bierman, Lightning McQueens, Faith Lutheran Middle & High School, Las Vegas, NV, USA"
echo "Last Modified on Friday, January 15th, 2016, 8:49pm"
startTime=$(date +"%s")
printTime()
{
	endTime=$(date +"%s")
	diffTime=$(($endTime-$startTime))
	if [ $(($diffTime / 60)) -lt 10 ]
	then
		if [ $(($diffTime % 60)) -lt 10 ]
		then
			echo -e "0$(($diffTime / 60)):0$(($diffTime % 60)) -- $1" >> /home/$USER/Desktop/Script.log
		else
			echo -e "0$(($diffTime / 60)):$(($diffTime % 60)) -- $1" >> /home/$USER/Desktop/Script.log
		fi
	else
		if [ $(($diffTime % 60)) -lt 10 ]
		then
			echo -e "$(($diffTime / 60)):0$(($diffTime % 60)) -- $1" >> /home/$USER/Desktop/Script.log
		else
			echo -e "$(($diffTime / 60)):$(($diffTime % 60)) -- $1" >> /home/$USER/Desktop/Script.log
		fi
	fi
}

touch /home/$USER/Desktop/Script.log
echo > /home/$USER/Desktop/Script.log

if [[ $EUID -ne 0 ]]
then
  echo This script must be run as root
  exit
fi
printTime "Script is being run as root."


# Creates backup folder
mkdir -p /home/$USER/Desktop/backups
chmod 777 /home/$USER/Desktop/backups
printTime "Backups folder created on the Desktop."

cp /etc/group /home/$USER/Desktop/backups/
chmod 777 /home/$USER/Desktop/backups/group
cp /etc/passwd /home/$USER/Desktop/backups/
chmod 777 /home/$USER/Desktop/backups/passwd
printTime "/etc/group and /etc/passwd files backed up."

echo Type all user account names, with a space in between
read -a users

usersLength=${#users[@]}	

for (( i=0;i<$usersLength;i++))
do
	clear
	echo ${users[${i}]}
	echo Delete ${users[${i}]}? yes or no
	read yn1
	if [ $yn1 == yes ]
	then
		userdel -r ${users[${i}]}
		printTime "${users[${i}]} has been deleted."	
	else	
		echo Make ${users[${i}]} administrator? yes or no
		read yn2								
		if [ $yn2 == yes ]
		then
			gpasswd -a ${users[${i}]} root
			gpasswd -a ${users[${i}]} adm
			gpasswd -a ${users[${i}]} lp
			gpasswd -a ${users[${i}]} wheel
			printTime "${users[${i}]} has been made an administrator."
		else
			gpasswd -d ${users[${i}]} root
			gpasswd -d ${users[${i}]} adm
			gpasswd -d ${users[${i}]} lp
			gpasswd -d ${users[${i}]} wheel
			printTime "${users[${i}]} has been made a standard user."
		fi
		
		echo Make custom password for ${users[${i}]}? yes or no
		read yn3								
		if [ $yn3 == yes ]
		then
			echo Password:
			read pw
			echo -e "$pw\n$pw" | passwd ${users[${i}]}
			printTime "${users[${i}]} has been given the password '$pw'."
		else
			echo -e "Moodle!22\nMoodle!22" | passwd ${users[${i}]}
			printTime "${users[${i}]} has been given the password 'Moodle!22'."
		fi
		passwd -x30 -n3 -w7 ${users[${i}]}
		usermod -L ${users[${i}]}
		printTime "${users[${i}]}'s password has been given a maximum age of 30 days, minimum of 3 days, and warning of 7 days. ${users[${i}]}'s account has been locked."
	fi
done
clear

echo Type user account names of users you want to add, with a space in between
read -a usersNew

usersNewLength=${#usersNew[@]}	

for (( i=0;i<$usersNewLength;i++))
do
	clear
	echo ${usersNew[${i}]}
	adduser ${usersNew[${i}]}
	printTime "A user account for ${usersNew[${i}]} has been created."
	clear
	echo Make ${usersNew[${i}]} administrator? yes or no
	read ynNew								
	if [ $ynNew == yes ]
	then
		gpasswd -a ${usersNew[${i}]} root
		gpasswd -a ${usersNew[${i}]} adm
		gpasswd -a ${usersNew[${i}]} lp
		gpasswd -a ${usersNew[${i}]} wheel
		printTime "${usersNew[${i}]} has been made an administrator."
	else
		printTime "${usersNew[${i}]} has been made a standard user."
	fi
	echo Make custom password for ${usersNew[${i}]}? yes or no
	read yn3								
	if [ $yn3 == yes ]
	then
		echo Password:
		read pw
		echo -e "$pw\n$pw" | passwd ${users[${i}]}
		printTime "${usersNew[${i}]} has been given the password '$pw'."
	else
		echo -e "Moodle!22\nMoodle!22" | passwd ${users[${i}]}
		printTime "${usersNew[${i}]} has been given the password 'Moodle!22'."
	fi
	passwd -x30 -n3 -w7 ${usersNew[${i}]}
	usermod -L ${usersNew[${i}]}
	printTime "${usersNew[${i}]}'s password has been given a maximum age of 30 days, minimum of 3 days, and warning of 7 days. ${users[${i}]}'s account has been locked."
done
clear

echo Does this machine need Samba?
read sambaYN
echo Does this machine need FTP?
read ftpYN
echo Does this machine need SSH?
read sshYN
echo Does this machine need Telnet?
read telnetYN
echo Does this machine need Mail?
read mailYN
echo Does this machine need Printing?
read printYN
echo Does this machine need MySQL?
read dbYN
echo Will this machine be a Web Server?
read httpYN
echo Does this machine need DNS?
read dnsYN
echo Does this machine allow media files?
read mediaFilesYN

clear
unalias -a
printTime "All alias have been removed."

clear
usermod -L root
printTime "Root account has been locked."

clear
chmod 640 .bash_history
printTime "Bash history file permissions set."

clear
chmod 604 /etc/shadow
printTime "Read/Write permissions on shadow have been set."

clear
printTime "Check for any user folders that do not belong to any users."
ls -a /home/ >> /home/$USER/Desktop/Script.log

clear
printTime "Check for any files for users that should not be administrators."
ls -a /etc/sudoers.d >> /home/$USER/Desktop/Script.log

clear
echo > /etc/rc.local
echo 'exit 0' >> /etc/rc.local
printTime "Any startup scripts have been removed."

clear
dnf install firewall-config -y -q
firewall-config
firewall-cmd --permanent --remove-port=1337/tcp
firewall-cmd --permanent --remove-port=1337/udp
printTime "Firewall enabled and port 1337 blocked."

clear
chmod 777 /etc/hosts
cp /etc/hosts /home/$USER/Desktop/backups/
chmod 777 /home/$USER/Desktop/backups/hosts
echo > /etc/hosts
echo -e "127.0.0.1 localhost\n127.0.1.1 $USER\n::1 ip6-localhost ip6-loopback\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
chmod 644 /etc/hosts
printTime "HOSTS file has been set to defaults."

clear
mkdir -p /etc/dconf/db/gdm.d/
touch /etc/dconf/db/gdm.d/01-hide-users
chmod 777 /etc/dconf/db/gdm.d/01-hide-users
echo -e "[org/gnome/login-screen]\ndisable-user-list=true" >> /etc/dconf/db/gdm.d/01-hide-users
echo > /etc/dconf/profile/gdm
echo -e "user-db:user\nsystem-db:gdm" >> /etc/dconf/profile/gdm
dconf update
printTime "GDM has been secured."

clear
find /bin/ -name "*.sh" -type f -delete
printTime "Scripts in bin have been removed."


clear
if [ $sambaYN == no ]
then
	dnf remove samba -y -q
	clear
	printTime "Samba has been removed."
elif [ $sambaYN == yes ]
then
	cp /etc/samba/smb.conf /home/$USER/Desktop/backups/
	chmod 777 /home/$USER/Desktop/backups/smb.conf
	echo CREATE SEPARATE PASSWORDS FOR EACH USER	
	gedit /etc/samba/smb.conf
	systemctl start smb
	systemctl enable smb
	clear	
	printTime "Samba server has been started and enabled."
else
	echo Response not recognized.
fi
printTime "Samba is complete."

clear
if [ $ftpYN == no ]
then
	firewall-cmd --permanent --remove-port=20/tcp
	firewall-cmd --permanent --remove-port=20/udp
	firewall-cmd --permanent --remove-port=21/tcp
	firewall-cmd --permanent --remove-port=21/udp
	firewall-cmd --permanent --remove-port=47/tcp
	firewall-cmd --permanent --remove-port=47/udp
	firewall-cmd --permanent --remove-port=69/tcp
	firewall-cmd --permanent --remove-port=69/udp
	firewall-cmd --permanent --remove-port=115/tcp
	firewall-cmd --permanent --remove-port=115/udp
	firewall-cmd --permanent --remove-port=152/tcp
	firewall-cmd --permanent --remove-port=152/udp
	firewall-cmd --permanent --remove-port=349/tcp
	firewall-cmd --permanent --remove-port=349/udp
	firewall-cmd --permanent --remove-port=574/tcp
	firewall-cmd --permanent --remove-port=574/udp
	firewall-cmd --permanent --remove-port=662/tcp
	firewall-cmd --permanent --remove-port=662/udp
	firewall-cmd --permanent --remove-port=989/tcp
	firewall-cmd --permanent --remove-port=989/udp
	firewall-cmd --permanent --remove-port=990/tcp
	firewall-cmd --permanent --remove-port=990/udp
	firewall-cmd --permanent --remove-port=1758/tcp
	firewall-cmd --permanent --remove-port=1758/udp
	firewall-cmd --permanent --remove-port=1759/udp
	firewall-cmd --permanent --remove-port=1818/tcp
	firewall-cmd --permanent --remove-port=1818/udp
	firewall-cmd --permanent --remove-port=2529/tcp
	firewall-cmd --permanent --remove-port=2529/udp
	firewall-cmd --permanent --remove-port=2811/tcp
	firewall-cmd --permanent --remove-port=2811/udp
	firewall-cmd --permanent --remove-port=3305/tcp
	firewall-cmd --permanent --remove-port=3305/udp
	firewall-cmd --permanent --remove-port=3713/tcp
	firewall-cmd --permanent --remove-port=3713/udp
	firewall-cmd --permanent --remove-port=6619/tcp
	firewall-cmd --permanent --remove-port=6619/udp
	firewall-cmd --permanent --remove-port=6620/tcp
	firewall-cmd --permanent --remove-port=6620/udp
	firewall-cmd --permanent --remove-port=6621/tcp
	firewall-cmd --permanent --remove-port=6621/udp
	firewall-cmd --permanent --remove-port=6622/tcp
	firewall-cmd --permanent --remove-port=6622/udp
	firewall-cmd --reload
	dnf remove vsftpd -y -q
	dnf remove sbd -y -q
	printTime "vsFTPd and sbd have been removed. ftp, ftp-data, ni-ftp, bftp, tftp, tftp-mcast, sftp, mtftp, mftp, ftp-agent, pftp, ftps, ftps-data, etftp, utsftp, gsiftp, odette-ftp, tftps, odette-ftps, kftp, kftp-data, and mcftp ports have been denied on the firewall."
elif [ $ftpYN == yes ]
then
	firewall-cmd --permanent --add-port=20/tcp
	firewall-cmd --permanent --add-port=20/udp
	firewall-cmd --permanent --add-port=21/tcp
	firewall-cmd --permanent --add-port=21/udp
	firewall-cmd --permanent --add-port=47/tcp
	firewall-cmd --permanent --add-port=47/udp
	firewall-cmd --permanent --add-port=69/tcp
	firewall-cmd --permanent --add-port=69/udp
	firewall-cmd --permanent --add-port=115/tcp
	firewall-cmd --permanent --add-port=115/udp
	firewall-cmd --permanent --add-port=152/tcp
	firewall-cmd --permanent --add-port=152/udp
	firewall-cmd --permanent --add-port=349/tcp
	firewall-cmd --permanent --add-port=349/udp
	firewall-cmd --permanent --add-port=574/tcp
	firewall-cmd --permanent --add-port=574/udp
	firewall-cmd --permanent --add-port=662/tcp
	firewall-cmd --permanent --add-port=662/udp
	firewall-cmd --permanent --add-port=989/tcp
	firewall-cmd --permanent --add-port=989/udp
	firewall-cmd --permanent --add-port=990/tcp
	firewall-cmd --permanent --add-port=990/udp
	firewall-cmd --permanent --add-port=1758/tcp
	firewall-cmd --permanent --add-port=1758/udp
	firewall-cmd --permanent --add-port=1759/udp
	firewall-cmd --permanent --add-port=1818/tcp
	firewall-cmd --permanent --add-port=1818/udp
	firewall-cmd --permanent --add-port=2529/tcp
	firewall-cmd --permanent --add-port=2529/udp
	firewall-cmd --permanent --add-port=2811/tcp
	firewall-cmd --permanent --add-port=2811/udp
	firewall-cmd --permanent --add-port=3305/tcp
	firewall-cmd --permanent --add-port=3305/udp
	firewall-cmd --permanent --add-port=3713/tcp
	firewall-cmd --permanent --add-port=3713/udp
	firewall-cmd --permanent --add-port=6619/tcp
	firewall-cmd --permanent --add-port=6619/udp
	firewall-cmd --permanent --add-port=6620/tcp
	firewall-cmd --permanent --add-port=6620/udp
	firewall-cmd --permanent --add-port=6621/tcp
	firewall-cmd --permanent --add-port=6621/udp
	firewall-cmd --permanent --add-port=6622/tcp
	firewall-cmd --permanent --add-port=6622/udp
	firewall-cmd --reload
	cp /etc/vsftpd/vsftpd.conf /home/$USER/Desktop/backups/
	chmod 777 /home/$USER/Desktop/backups/vsftpd.conf
	grep anonymous_enable= /etc/vsftpd/vsftpd.conf | grep YES
	if [ $?==0 ]
	then
  	  sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf
	fi
	
	grep local_enable= /etc/vsftpd/vsftpd.conf | grep NO
	if [ $?==0 ]
	then
  	  sed -i 's/local_enable=NO/local_enable=YES/g' /etc/vsftpd/vsftpd.conf
	fi

	grep write_enable= /etc/vsftpd/vsftpd.conf | grep NO
	if [ $?==0 ]
	then
  	  sed -i 's/write_enable=NO/write_enable=YES/g' /etc/vsftpd/vsftpd.conf
	fi

	grep chroot_local_user= /etc/vsftpd/vsftpd.conf | grep NO
	if [ $?==0 ]
	then
  	  sed -i 's/chroot_local_user=NO/chroot_local_user=YES/g' /etc/vsftpd/vsftpd.conf
	fi
	systemctl enable vsftpd
	systemctl restart vsftpd
	printTime "ftp, ftp-data, ni-ftp, bftp, tftp, tftp-mcast, sftp, mtftp, mftp, ftp-agent, pftp, ftps, ftps-data, etftp, utsftp, gsiftp, odette-ftp, tftps, odette-ftps, kftp, kftp-data, and mcftp ports have been allowed on the firewall. vsFTPd service has been restarted."
else
	echo Response not recognized.
fi
printTime "FTP is complete."

clear
if [ $sshYN == no ]
then
	firewall-cmd --permanent --remove-port=22/tcp
	firewall-cmd --permanent --remove-port=22/udp
	firewall-cmd --permanent --remove-port=830/tcp
	firewall-cmd --permanent --remove-port=830/udp
	dnf remove openssh-server -y -q
	clear
	printTime "ssh and netconf-ssh ports have been denied on the firewall. Open-SSH has been removed."
elif [ $sshYN == yes ]
then
	firewall-cmd --permanent --add-port=22/tcp
	firewall-cmd --permanent --add-port=22/udp
	firewall-cmd --permanent --add-port=830/tcp
	firewall-cmd --permanent --add-port=830/udp
	cp /etc/ssh/sshd_config /home/$USER/Desktop/backups/
	chmod 777 /home/$USER/Desktop/backups/sshd_config
	grep PermitRootLogin /etc/ssh/sshd_config | grep yes
	if [ $?==0 ]
	then
  	  sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
	  sed -i 's/PermitRootLogin without-password/PermitRootLogin no/g' /etc/ssh/sshd_config

	fi
	
	grep Protocol /etc/ssh/sshd_config | grep 1
	if [ $?==0 ]
	then
	  sed -i 's/Protocol 2,1/Protocol 2/g' /etc/ssh/sshd_config
	  sed -i 's/Protocol 1,2/Protocol 2/g' /etc/ssh/sshd_config
	fi

	grep X11Forwarding /etc/ssh/sshd_config | grep yes
	if [ $?==0 ]
	then
	  sed -i 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config
	fi
	
	grep PermitEmptyPasswords /etc/ssh/sshd_config | grep yes
	if [ $?==0 ]
	then
	  sed -i 's/PermitEmptyPasswords yes/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
	fi

	systemctl reload sshd
	systemctl start sshd
	systemctl enable sshd
	printTime "ssh and netconf-ssh ports have been allowed on the firewall. SSH config file has been configured."
else
	echo Response not recognized.
fi
printTime "SSH is complete."

clear
if [ $telnetYN == no ]
then
	firewall-cmd --permanent --remove-port=23/tcp
	firewall-cmd --permanent --remove-port=23/udp
	firewall-cmd --permanent --remove-port=107/tcp
	firewall-cmd --permanent --remove-port=107/udp
	firewall-cmd --permanent --remove-port=992/tcp
	firewall-cmd --permanent --remove-port=992/udp
	printTime "telnet, rtelnet, and telnets ports have been denied on the firewall."
elif [ $telnetYN == yes ]
then
	firewall-cmd --permanent --add-port=23/tcp
	firewall-cmd --permanent --add-port=23/udp
	firewall-cmd --permanent --add-port=107/tcp
	firewall-cmd --permanent --add-port=107/udp
	firewall-cmd --permanent --add-port=992/tcp
	firewall-cmd --permanent --add-port=992/udp
	printTime "telnet, rtelnet, and telnets ports have been allowed on the firewall."
else
	echo Response not recognized.
fi
printTime "Telnet is complete."

clear
if [ $mailYN == no ]
then
	firewall-cmd --permanent --remove-port=25/tcp
	firewall-cmd --permanent --remove-port=25/udp
	firewall-cmd --permanent --remove-port=109/tcp
	firewall-cmd --permanent --remove-port=109/udp
	firewall-cmd --permanent --remove-port=110/tcp
	firewall-cmd --permanent --remove-port=110/udp
	firewall-cmd --permanent --remove-port=143/tcp
	firewall-cmd --permanent --remove-port=143/udp
	firewall-cmd --permanent --remove-port=220/tcp
	firewall-cmd --permanent --remove-port=220/udp
	firewall-cmd --permanent --remove-port=993/tcp
	firewall-cmd --permanent --remove-port=993/udp
	firewall-cmd --permanent --remove-port=995/tcp
	firewall-cmd --permanent --remove-port=995/udp
	printTime "smtp, pop2, pop3, imap2, imap3, imaps, and pop3s ports have been denied on the firewall"
elif [ $mailYN == yes ]
then
	firewall-cmd --permanent --add-port=25/tcp
	firewall-cmd --permanent --add-port=25/udp
	firewall-cmd --permanent --add-port=109/tcp
	firewall-cmd --permanent --add-port=109/udp
	firewall-cmd --permanent --add-port=110/tcp
	firewall-cmd --permanent --add-port=110/udp
	firewall-cmd --permanent --add-port=143/tcp
	firewall-cmd --permanent --add-port=143/udp
	firewall-cmd --permanent --add-port=220/tcp
	firewall-cmd --permanent --add-port=220/udp
	firewall-cmd --permanent --add-port=993/tcp
	firewall-cmd --permanent --add-port=993/udp
	firewall-cmd --permanent --add-port=995/tcp
	firewall-cmd --permanent --add-port=995/udp
	printTime "smtp, pop2, pop3, imap2, imap3, imaps, and pop3s ports have been allowed on the firewall."
else
	echo Response not recognized.
fi
printTime "Mail is complete."

clear
if [ $printYN == no ]
then
	firewall-cmd --permanent --remove-port=631/tcp
	firewall-cmd --permanent --remove-port=631/udp
	firewall-cmd --permanent --remove-port=515/tcp
	firewall-cmd --permanent --remove-port=515/udp
	printTime "ipp and printer ports have been denied on the firewall."
elif [ $printYN == yes ]
then
	firewall-cmd --permanent --add-port=631/tcp
	firewall-cmd --permanent --add-port=631/udp
	firewall-cmd --permanent --add-port=515/tcp
	firewall-cmd --permanent --add-port=515/udp
	printTime "ipp and printer ports have been allowed on the firewall."
else
	echo Response not recognized.
fi
printTime "Printing is complete."

clear
if [ $dbYN == no ]
then
	firewall-cmd --permanent --remove-port=1433/tcp
	firewall-cmd --permanent --remove-port=1433/udp
	firewall-cmd --permanent --remove-port=1434/tcp
	firewall-cmd --permanent --remove-port=1434/udp
	firewall-cmd --permanent --remove-port=3306/tcp
	firewall-cmd --permanent --remove-port=3306/udp
	firewall-cmd --permanent --remove-port=6446/tcp
	firewall-cmd --permanent --remove-port=6446/udp
	dnf remove mysql -y -q
	dnf remove mysql-server -y -q
	sed '/mysql/d' /etc/group
	clear
	printTime "ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been denied on the firewall. MySQL has been removed."
elif [ $dbYN == yes ]
then
	firewall-cmd --permanent --add-port=1433/tcp
	firewall-cmd --permanent --add-port=1433/udp
	firewall-cmd --permanent --add-port=1434/tcp
	firewall-cmd --permanent --add-port=1434/udp
	firewall-cmd --permanent --add-port=3306/tcp
	firewall-cmd --permanent --add-port=3306/udp
	firewall-cmd --permanent --add-port=6446/tcp
	firewall-cmd --permanent --add-port=6446/udp
	gedit /etc/my.cnf&gedit /etc/mysql/my.cnf&gedit /usr/etc/my.cnf&gedit ~/.my.cnf
	systemctl start mariadb
	systemctl enable mariadb
	clear
	echo Set Root Password
	/usr/bin/mysql_secure_installation
	printTime "ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been allowed on the firewall. MySQL service has been restarted."
else
	echo Response not recognized.
fi
printTime "MySQL is complete."

clear
if [ $httpYN == no ]
then
	firewall-cmd --permanent --remove-port=80/tcp
	firewall-cmd --permanent --remove-port=80/udp
	firewall-cmd --permanent --remove-port=443/tcp
	firewall-cmd --permanent --remove-port=443/udp
	dnf remove httpd -y -q
	clear
	rm -r /var/www/*
	printTime "http and https ports have been denied on the firewall. Apache2 has been removed. Web server files have been removed."
elif [ $httpYN == yes ]
then
	firewall-cmd --permanent --add-port=80/tcp
	firewall-cmd --permanent --add-port=80/udp
	firewall-cmd --permanent --add-port=443/tcp
	firewall-cmd --permanent --add-port=443/udp
	cp /etc/apache2/apache2.conf ~/Desktop/backups/
	chmod 777 /home/$USER/Desktop/backups/apache2.conf
	cp /etc/httpd/conf/httpd.conf ~/Desktop/backups/
	chmod 777 /home/$USER/Desktop/backups/httpd.conf	
	if [ -e /etc/httpd/conf/httpd.conf ]
	then
  	  echo -e '\<Directory \>\n\t AllowOverride None\n\t Order Deny,Allow\n\t Deny from all\n\<Directory \/\>\nUserDir disabled root' >> /etc/httpd/conf/httpd.conf
	fi
	chown -R root:root /etc/httpd
	systemctl start httpd
	systemctl enable httpd
	printTime "http and https ports have been allowed on the firewall. Apache2 config file has been configured. Only root can now access the Apache2 folder."
else
	echo Response not recognized.
fi
printTime "Web Server is complete."

clear
if [ $dnsYN == no ]
then
	firewall-cmd --permanent --remove-port=53/tcp
	firewall-cmd --permanent --remove-port=53/udp
	dnf remove bind bind-utils -y -q
	printTime "domain port has been denied on the firewall. DNS name binding has been removed."
elif [ $dnsYN == yes ]
then
	firewall-cmd --permanent --add-port=53/tcp
	firewall-cmd --permanent --add-port=53/udp
	printTime "domain port has been allowed on the firewall."
else
	echo Response not recognized.
fi
printTime "DNS is complete."

if [ $mediaFilesYN == yes ]
then
	find / -name "*.midi" -type f -delete
	find / -name "*.mid" -type f -delete
	find / -name "*.mod" -type f -delete
	find / -name "*.mp3" -type f -delete
	find / -name "*.mp2" -type f -delete
	find / -name "*.mpa" -type f -delete
	find / -name "*.abs" -type f -delete
	find / -name "*.mpega" -type f -delete
	find / -name "*.au" -type f -delete
	find / -name "*.snd" -type f -delete
	find / -name "*.wav" -type f -delete
	find / -name "*.aiff" -type f -delete
	find / -name "*.aif" -type f -delete
	find / -name "*.sid" -type f -delete
	find / -name "*.flac" -type f -delete
	find / -name "*.ogg" -type f -delete
	clear
	printTime "Audio files removed."

	find / -name "*.mpeg" -type f -delete
	find / -name "*.mpg" -type f -delete
	find / -name "*.mpe" -type f -delete
	find / -name "*.dl" -type f -delete
	find / -name "*.movie" -type f -delete
	find / -name "*.movi" -type f -delete
	find / -name "*.mv" -type f -delete
	find / -name "*.iff" -type f -delete
	find / -name "*.anim5" -type f -delete
	find / -name "*.anim3" -type f -delete
	find / -name "*.anim7" -type f -delete
	find / -name "*.avi" -type f -delete
	find / -name "*.vfw" -type f -delete
	find / -name "*.avx" -type f -delete
	find / -name "*.fli" -type f -delete
	find / -name "*.flc" -type f -delete
	find / -name "*.mov" -type f -delete
	find / -name "*.qt" -type f -delete
	find / -name "*.spl" -type f -delete
	find / -name "*.swf" -type f -delete
	find / -name "*.dcr" -type f -delete
	find / -name "*.dir" -type f -delete
	find / -name "*.dxr" -type f -delete
	find / -name "*.rpm" -type f -delete
	find / -name "*.rm" -type f -delete
	find / -name "*.smi" -type f -delete
	find / -name "*.ra" -type f -delete
	find / -name "*.ram" -type f -delete
	find / -name "*.rv" -type f -delete
	find / -name "*.wmv" -type f -delete
	find / -name "*.asf" -type f -delete
	find / -name "*.asx" -type f -delete
	find / -name "*.wma" -type f -delete
	find / -name "*.wax" -type f -delete
	find / -name "*.wmv" -type f -delete
	find / -name "*.wmx" -type f -delete
	find / -name "*.3gp" -type f -delete
	find / -name "*.mov" -type f -delete
	find / -name "*.mp4" -type f -delete
	find / -name "*.avi" -type f -delete
	find / -name "*.swf" -type f -delete
	find / -name "*.flv" -type f -delete
	find / -name "*.m4v" -type f -delete
	clear
	printTime "Video files removed."
	
	find /home -name "*.tiff" -type f -delete
	find /home -name "*.tif" -type f -delete
	find /home -name "*.rs" -type f -delete
	find /home -name "*.im1" -type f -delete
	find /home -name "*.gif" -type f -delete
	find /home -name "*.jpeg" -type f -delete
	find /home -name "*.jpg" -type f -delete
	find /home -name "*.jpe" -type f -delete
	find /home -name "*.png" -type f -delete
	find /home -name "*.rgb" -type f -delete
	find /home -name "*.xwd" -type f -delete
	find /home -name "*.xpm" -type f -delete
	find /home -name "*.ppm" -type f -delete
	find /home -name "*.pbm" -type f -delete
	find /home -name "*.pgm" -type f -delete
	find /home -name "*.pcx" -type f -delete
	find /home -name "*.ico" -type f -delete
	find /home -name "*.svg" -type f -delete
	find /home -name "*.svgz" -type f -delete
	clear
	printTime "Image files removed."
	
	clear
	printTime "All media files deleted."
else
	echo Response not recognized.
fi

clear
dnf remove netcat -y -q
dnf remove socat -y -q
rm /usr/bin/nc
rm /usr/bin/ncat
clear
printTime "Netcat and all other instances have been removed."

dnf remove john -y -q
clear
printTime "John the Ripper has been removed."

dnf remove hydra -y -q
clear
printTime "Hydra has been removed."

dnf remove aircrack-ng -y -q
clear
printTime "Aircrack-NG has been removed."

dnf remove ophcrack -y -q
clear
printTime "OphCrack has been removed."

dnf remove pdfcrack -y -q
clear
printTime "PDFCrack has been removed."

dnf remove pyrit -y -q
clear
printTime "Pyrit has been removed."

dnf remove zeitgeist -y -q
def remove python-zeitgeist -y -q
clear
printTime "Zeitgeist has been removed."

cp /etc/login.defs ~/Desktop/backups/
chmod 777 /home/$USER/Desktop/backups/login.defs
sed -i '25s/.*/PASS_MAX_DAYS\o01130/' /etc/login.defs
sed -i '26s/.*/PASS_MIN_DAYS\o0113/' /etc/login.defs
sed -i '27s/.*/PASS_MIN_LEN\o0118/' /etc/login.defs
sed -i '28s/.*/PASS_WARN_AGE\o0117/' /etc/login.defs

clear
authconfig --passminlen=8 --passmaxrepeat=2 --enablereqlower --enablerequpper --enablereqdigit --enablereqother --update
printTime "Password policies have been set, editing /etc/login.defs and authconfig."

clear
dnf install iptables -y -q
iptables -A INPUT -p all -s localhost  -i eth0 -j DROP
printTime "All outside packets from internet claiming to be from loopback are denied."

clear
chmod 777 /usr/lib/systemd/system/ctrl-alt-del.target
cp /usr/lib/systemd/system/ctrl-alt-del.target ~/Desktop/ctrl-alt-del.target
echo > /usr/lib/systemd/system/ctrl-alt-del.target
chmod 644 /usr/lib/systemd/system/ctrl-alt-del.target
printTime "Reboot using Ctrl-Alt-Delete has been disabled."

clear
dnf install policycoreutils-gui -y -q
chmod 777 /etc/selinux/config
echo > /etc/selinux/config
echo -e "SELINUX=enforcing\nSELINUXTYPE=targeted" >> /etc/selinux/config
chmod 644 /etc/selinux/config
printTime "SELinux has been configured."

clear
crontab -l > /home/$USER/Desktop/backups/crontab-old
chmod 777 /home/$USER/Desktop/backups/crontab-old
crontab -r
printTime "Crontab has been backed up. All startup tasks have been removed from crontab."

clear
cd /etc/
/bin/rm -f cron.deny at.deny
echo root >cron.allow
echo root >at.allow
/bin/chown root:root cron.allow at.allow
/bin/chmod 400 cron.allow at.allow
cd ..
printTime "Only root allowed in cron." 

clear
dnf check-update -y -q
dnf update -y -q --refresh
dnf upgrade -y -q
printTime "Fedora OS has checked for updates and has been upgraded."

clear
dnf autoremove -y -q
dnf clean all -y -q
dnf distro-sync -y -q
printTime "All unused packages have been removed."

clear
dnf install dnf-automatic -y -q
sed -i '5s/.*/upgrade_type = default/' /etc/dnf/automatic.conf
sed -i '9s/.*/download_updates = yes/' /etc/dnf/automatic.conf
sed -i '14s/.*/apply_updates = yes/' /etc/dnf/automatic.conf
systemctl enable dnf-automatic.timer
systemctl start dnf-automatic.timer
printTime "Daily, automatic updates have been enabled."

clear
mkdir -p /home/$USER/Desktop/logs
chmod 777 /home/$USER/Desktop/logs
printTime "Logs folder has been created on the Desktop."

cp /etc/services /home/$USER/Desktop/logs/allports.log
chmod 777 /home/$USER/Desktop/logs/allports.log
printTime "All ports log has been created."
dnf list all > /home/$USER/Desktop/logs/packages.log
chmod 777 /home/$USER/Desktop/logs/packages.log
printTime "All packages log has been created."
dnf history list > /home/$USER/Desktop/logs/installedupdatedpackages.log
chmod 777 /home/$USER/Desktop/logs/installedupdatedpackages.log
printTime "All installed and updated packages log has been created."
systemctl list-units > /home/$USER/Desktop/logs/allservices.log
chmod 777 /home/$USER/Desktop/logs/allservices.log
printTime "All running services log has been created."
ps -A > /home/$USER/Desktop/logs/processes.log
chmod 777 /home/$USER/Desktop/logs/processes.log
printTime "All running processes log has been created."
ss -l > /home/$USER/Desktop/logs/socketconnections.log
chmod 777 /home/$USER/Desktop/logs/socketconnections.log
printTime "All socket connections log has been created."
sudo netstat -tlnp > /home/$USER/Desktop/logs/listeningports.log
chmod 777 /home/$USER/Desktop/logs/listeningports.log
printTime "All listening ports log has been created."
journalctl > /home/$USER/Desktop/logs/system.log
chmod 777 /home/$USER/Desktop/logs/system.log
printTime "System log has been created."

