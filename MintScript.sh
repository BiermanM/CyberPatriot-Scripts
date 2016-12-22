#!/bin/bash
clear
echo "Created by Matthew Bierman, Lightning McQueens, Faith Lutheran Middle & High School, Las Vegas, NV, USA"
echo "Last Modified on Friday, January 19th, 2016, 2:13pm"
echo "Linux Mint Script"
startTime=$(date +"%s")
printTime()
{
	endTime=$(date +"%s")
	diffTime=$(($endTime-$startTime))
	if [ $(($diffTime / 60)) -lt 10 ]
	then
		if [ $(($diffTime % 60)) -lt 10 ]
		then
			echo -e "0$(($diffTime / 60)):0$(($diffTime % 60)) -- $1" >> ~/Desktop/Script.log
		else
			echo -e "0$(($diffTime / 60)):$(($diffTime % 60)) -- $1" >> ~/Desktop/Script.log
		fi
	else
		if [ $(($diffTime % 60)) -lt 10 ]
		then
			echo -e "$(($diffTime / 60)):0$(($diffTime % 60)) -- $1" >> ~/Desktop/Script.log
		else
			echo -e "$(($diffTime / 60)):$(($diffTime % 60)) -- $1" >> ~/Desktop/Script.log
		fi
	fi
}

touch ~/Desktop/Script.log
echo > ~/Desktop/Script.log
chmod 777 ~/Desktop/Script.log

if [[ $EUID -ne 0 ]]
then
  echo This script must be run as root
  exit
fi
printTime "Script is being run as root."

apt-get install gedit -y -qq
clear
printTime "The current OS is Linux Mint."

mkdir -p ~/Desktop/backups
chmod 777 ~/Desktop/backups
printTime "Backups folder created on the Desktop."

cp /etc/group ~/Desktop/backups/
chmod 777 ~/Desktop/backups/group
cp /etc/passwd ~/Desktop/backups/
chmod 777 ~/Desktop/backups/passwd

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
			gpasswd -a ${users[${i}]} sudo
			gpasswd -a ${users[${i}]} adm
			gpasswd -a ${users[${i}]} lpadmin
			gpasswd -a ${users[${i}]} sambashare
			printTime "${users[${i}]} has been made an administrator."
		else
			gpasswd -d ${users[${i}]} sudo
			gpasswd -d ${users[${i}]} adm
			gpasswd -d ${users[${i}]} lpadmin
			gpasswd -d ${users[${i}]} sambashare
			gpasswd -d ${users[${i}]} root
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
		gpasswd -a ${usersNew[${i}]} sudo
		gpasswd -a ${usersNew[${i}]} adm
		gpasswd -a ${usersNew[${i}]} lpadmin
		gpasswd -a ${usersNew[${i}]} sambashare
		printTime "${usersNew[${i}]} has been made an administrator."
	else
		printTime "${usersNew[${i}]} has been made a standard user."
	fi
	
	passwd -x30 -n3 -w7 ${usersNew[${i}]}
	usermod -L ${usersNew[${i}]}
	printTime "${usersNew[${i}]}'s password has been given a maximum age of 30 days, minimum of 3 days, and warning of 7 days. ${users[${i}]}'s account has been locked."
done

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
ls -a /home/ >> ~/Desktop/Script.log

clear
printTime "Check for any files for users that should not be administrators."
ls -a /etc/sudoers.d >> ~/Desktop/Script.log

clear
cp /etc/rc.local ~/Desktop/backups/
echo > /etc/rc.local
echo 'exit 0' >> /etc/rc.local
printTime "Any startup scripts have been removed."

clear
apt-get install ufw -y -qq
ufw enable
ufw deny 1337
printTime "Firewall enabled and port 1337 blocked."

clear
chmod 777 /etc/hosts
cp /etc/hosts ~/Desktop/backups/
echo > /etc/hosts
echo -e "127.0.0.1 localhost\n127.0.1.1 $USER\n::1 ip6-localhost ip6-loopback\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
chmod 644 /etc/hosts
printTime "HOSTS file has been set to defaults."

clear
echo > /etc/mdm/mdm.conf
echo -e "[daemon]\nAutomaticLoginEnable=true\nAutomaticLogin=$USER\nTimedLoginEnable=true\nTimedLogin=$USER\nTimedLoginDelay=10\n\n[security]\nAllowRoot=false\n\n[xdmcp]\n\n[gui]\n\n[greeter]\n\n[chooser]\n\n[debug]\n\n\[servers]" >> /etc/mdm/mdm.conf
printTime "MDM has been secured."

clear
find /bin/ -name "*.sh" -type f -delete
printTime "Scripts in bin have been removed."



clear
if [ $sambaYN == no ]
then
	apt-get purge samba -y -qq
	apt-get purge samba-common -y  -qq
	apt-get purge samba-common-bin -y -qq
	apt-get purge samba4 -y -qq
	clear
	printTime "Samba has been removed."
elif [ $sambaYN == yes ]
then
	echo CREATE SEPARATE PASSWORDS FOR EACH USER
	cp /etc/samba/smb.conf ~/Desktop/backups/
	gedit /etc/samba/smb.conf
else
	echo Response not recognized.
fi
printTime "Samba is complete."

clear
if [ $ftpYN == no ]
then
	ufw deny ftp 
	ufw deny sftp 
	ufw deny saft 
	ufw deny ftps-data 
	ufw deny ftps
	apt-get purge vsftpd -y -qq
	printTime "vsFTPd has been removed. ftp, sftp, saft, ftps-data, and ftps ports have been denied on the firewall."
elif [ $ftpYN == yes ]
then
	ufw allow ftp 
	ufw allow sftp 
	ufw allow saft 
	ufw allow ftps-data 
	ufw allow ftps
	cp /etc/vsftpd/vsftpd.conf ~/Desktop/backups/
	cp /etc/vsftpd.conf ~/Desktop/backups/
	gedit /etc/vsftpd/vsftpd.conf&gedit /etc/vsftpd.conf
	service vsftpd restart
	printTime "ftp, sftp, saft, ftps-data, and ftps ports have been allowed on the firewall. vsFTPd service has been restarted."
else
	echo Response not recognized.
fi
printTime "FTP is complete."


clear
if [ $sshYN == no ]
then
	ufw deny ssh
	apt-get purge openssh-server -y -qq
	printTime "SSH port has been denied on the firewall. Open-SSH has been removed."
elif [ $sshYN == yes ]
then
	ufw allow ssh
	cp /etc/ssh/sshd_config ~/Desktop/backups/	
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
	service ssh restart
	printTime "SSH port has been allowed on the firewall. SSH config file has been configured."
else
	echo Response not recognized.
fi
printTime "SSH is complete."

clear
if [ $telnetYN == no ]
then
	ufw deny telnet 
	ufw deny rtelnet 
	ufw deny telnets
	apt-get purge telnet -y -qq
	apt-get purge telnetd -y -qq
	apt-get inetutils-telnetd -y -qq
	apt-get telnetd-ssl -y -qq
	printTime "Telnet port has been denied on the firewall and Telnet has been removed."
elif [ $telnetYN == yes ]
then
	ufw allow telnet 
	ufw allow rtelnet 
	ufw allow telnets
	printTime "Telnet port has been allowed on the firewall."
else
	echo Response not recognized.
fi
printTime "Telnet is complete."



clear
if [ $mailYN == no ]
then
	ufw deny smtp 
	ufw deny pop2 
	ufw deny pop3
	ufw deny imap2 
	ufw deny imaps 
	ufw deny pop3s
	printTime "smtp, pop2, pop3, imap2, imaps, and pop3s ports have been denied on the firewall."
elif [ $mailYN == yes ]
then
	ufw allow smtp 
	ufw allow pop2 
	ufw allow pop3
	ufw allow imap2 
	ufw allow imaps 
	ufw allow pop3s
	printTime "smtp, pop2, pop3, imap2, imaps, and pop3s ports have been allowed on the firewall."
else
	echo Response not recognized.
fi
printTime "Mail is complete."



clear
if [ $printYN == no ]
then
	ufw deny ipp 
	ufw deny printer 
	ufw deny cups
	printTime "ipp, printer, and cups ports have been denied on the firewall."
elif [ $printYN == yes ]
then
	ufw allow ipp 
	ufw allow printer 
	ufw allow cups
	printTime "ipp, printer, and cups ports have been allowed on the firewall."
else
	echo Response not recognized.
fi
printTime "Printing is complete."



clear
if [ $dbYN == no ]
then
	ufw deny ms-sql-s 
	ufw deny ms-sql-m 
	ufw deny mysql 
	ufw deny mysql-proxy
	apt-get purge mysql -y -qq
	apt-get purge mysql-client-core-5.5 -y -qq
	apt-get purge mysql-server -y -qq
	apt-get purge mysql-server-5.5 -y -qq
	apt-get purge mysql-client-5.5 -y -qq
	printTime "ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been denied on the firewall. MySQL has been removed."
elif [ $dbYN == yes ]
then
	ufw allow ms-sql-s 
	ufw allow ms-sql-m 
	ufw allow mysql 
	ufw allow mysql-proxy
	cp /etc/my.cnf ~/Desktop/backups/
	cp /etc/mysql/my.cnf ~/Desktop/backups/
	cp /usr/etc/my.cnf ~/Desktop/backups/
	cp ~/.my.cnf ~/Desktop/backups/
	gedit /etc/my.cnf&gedit /etc/mysql/my.cnf&gedit /usr/etc/my.cnf&gedit ~/.my.cnf
	service mysql restart
	printTime "ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been allowed on the firewall. MySQL service has been restarted."
else
	echo Response not recognized.
fi
printTime "MySQL is complete."



clear
if [ $httpYN == no ]
then
	ufw deny http
	ufw deny https
	apt-get purge apache2 -y -qq
	rm -r /var/www/*
	printTime "http and https ports have been denied on the firewall. Apache2 has been removed. Web server files have been removed."
elif [ $httpYN == yes ]
then
	ufw allow http 
	ufw allow https
	cp /etc/apache2/apache2.conf ~/Desktop/backups/
	if [ -e /etc/apache2/apache2.conf ]
	then
  	  echo -e '\<Directory \>\n\t AllowOverride None\n\t Order Deny,Allow\n\t Deny from all\n\<Directory \/\>\nUserDir disabled root' >> /etc/apache2/apache2.conf
	fi
	chown -R root:root /etc/apache2

	printTime "http and https ports have been allowed on the firewall. Apache2 config file has been configured. Only root can now access the Apache2 folder."
else
	echo Response not recognized.
fi
printTime "Web Server is complete."



clear
if [ $dnsYN == no ]
then
	ufw deny domain
	apt-get purge bind9 -qq
	printTime "domain port has been denied on the firewall. DNS name binding has been removed."
elif [ $dnsYN == yes ]
then
	ufw allow domain
	printTime "domain port has been allowed on the firewall."
else
	echo Response not recognized.
fi
printTime "DNS is complete."


clear
if [ $mediaFilesYN == no ]
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
printTime "Media files are complete."


clear
apt-get purge netcat -y -qq
apt-get purge netcat-openbsd -y -qq
apt-get purge netcat-traditional -y -qq
apt-get purge ncat -y -qq
apt-get purge pnetcat -y -qq
apt-get purge socat -y -qq
apt-get purge sock -y -qq
apt-get purge socket -y -qq
apt-get purge sbd -y -qq
rm /usr/bin/nc
clear
printTime "Netcat and all other instances have been removed."

apt-get purge john -y -qq
apt-get purge john-data -y -qq
clear
printTime "John the Ripper has been removed."

apt-get purge hydra -y -qq
apt-get purge hydra-gtk -y -qq
clear
printTime "Hydra has been removed."

apt-get purge aircrack-ng -y -qq
clear
printTime "Aircrack-NG has been removed."

apt-get purge fcrackzip -y -qq
clear
printTime "FCrackZIP has been removed."

apt-get purge lcrack -y -qq
clear
printTime "LCrack has been removed."

apt-get purge ophcrack -y -qq
apt-get purge ophcrack-cli -y -qq
clear
printTime "OphCrack has been removed."

apt-get purge pdfcrack -y -qq
clear
printTime "PDFCrack has been removed."

apt-get purge pyrit -y -qq
clear
printTime "Pyrit has been removed."

apt-get purge rarcrack -y -qq
clear
printTime "RARCrack has been removed."

apt-get purge sipcrack -y -qq
clear
printTime "SipCrack has been removed."

apt-get purge irpas -y -qq
clear
printTime "IRPAS has been removed."

clear
printTime 'Are there any hacking tools shown? (not counting libcrack2:amd64 or cracklib-runtime)'
dpkg -l | egrep "crack|hack" >> ~/Desktop/Script.log

apt-get purge zeitgeist-core -y -qq
apt-get purge zeitgeist-datahub -y -qq
apt-get purge python-zeitgeist -y -qq
apt-get purge rhythmbox-plugin-zeitgeist -y -qq
apt-get purge zeitgeist -y -qq
printTime "Zeitgeist has been removed."

cp /etc/login.defs ~/Desktop/backups/
sed -i '160s/.*/PASS_MAX_DAYS\o01130/' /etc/login.defs
sed -i '161s/.*/PASS_MIN_DAYS\o0113/' /etc/login.defs
sed -i '162s/.*/PASS_MIN_LEN\o0118/' /etc/login.defs
sed -i '163s/.*/PASS_WARN_AGE\o0117/' /etc/login.defs

clear
apt-get install libpam-cracklib -y -qq
cp /etc/pam.d/common-auth ~/Desktop/backups/
cp /etc/pam.d/common-password ~/Desktop/backups/
grep "auth optional pam_tally.so deny=5 unlock_time=900 onerr=fail audit even_deny_root_account silent " /etc/pam.d/common-auth
if [ "$?" -eq "1" ]
then	
	echo "auth optional pam_tally.so deny=5 unlock_time=900 onerr=fail audit even_deny_root_account silent " >> /etc/pam.d/common-auth
	echo -e "password requisite pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\npassword requisite pam_pwhistory.so use_authtok remember=24 enforce_for_root" >>  /etc/pam.d/common-password
fi
printTime "Password policies have been set, editing /etc/login.defs and pam.d."

clear
apt-get install iptables -y -qq
iptables -A INPUT -p all -s localhost  -i eth0 -j DROP
printTime "All outside packets from internet claiming to be from loopback are denied."

clear
cp /etc/init/control-alt-delete.conf ~/Desktop/backups/
sed '/^exec/ c\exec false' /etc/init/control-alt-delete.conf
printTime "Reboot using Ctrl-Alt-Delete has been disabled."

clear
apt-get install apparmor apparmor-profiles -y -qq
printTime "AppArmor has been installed."

clear
crontab -l > ~/Desktop/backups/crontab-old
chmod 777 ~/Desktop/backups/crontab-old
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

chmod 777 /etc/apt/sources.list
cp /etc/apt/sources.list ~/Desktop/backups/
if [[ $(lsb_release -r) == "Release:	17.3" ]]
then
	echo -e "deb http://packages.linuxmint.com rosa main upstream import\ndeb http://extra.linuxmint.com rosa main\ndeb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu trsuty-updates main restricted universe multiverse\ndeb http://security.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu/ trusty partner" > /etc/apt/sources.list
elif [[ $(lsb_release -r) == "Release:	17.2" ]]
then
	echo -e "deb http://packages.linuxmint.com rafaela main upstream import\ndeb http://extra.linuxmint.com rafaela main\ndeb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu trusty-updates main restricted universe multiverse\ndeb http://security.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu/ trusty partner" > /etc/apt/sources.list
elif [[ $(lsb_release -r) == "Release:	17.1" ]]
then
	echo -e "deb http://packages.linuxmint.com rebecca main upstream import\ndeb http://extra.linuxmint.com rebecca main\ndeb http://archive.ubuntu.com/ubuntu trusty main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu trsuty-updates main restricted universe multiverse\ndeb http://security.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu/ trusty partner" > /etc/apt/sources.list
elif [[ $(lsb_release -r) == "Release:	16" ]]
then
	echo -e "deb http://packages.linuxmint.com petra main upstream import\ndeb http://extra.linuxmint.com petra main\ndeb http://archive.ubuntu.com/ubuntu saucy main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu saucy-updates main restricted universe multiverse\ndeb http://security.ubuntu.com/ubuntu/ saucy-security main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu/ saucy partner" > /etc/apt/sources.list
elif [[ $(lsb_release -r) == "Release:	13" ]]
then
	echo -e "deb http://packages.linuxmint.com maya main upstream import\ndeb http://extra.linuxmint.com maya main\ndeb http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse\ndeb http://archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse\ndeb http://security.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse\ndeb http://archive.canonical.com/ubuntu/ precise partner" > /etc/apt/sources.list
fi
chmod 644 /etc/apt/sources.list
printTime "Apt Repositories have been added."


clear
apt-get update -qq
apt-get upgrade -qq
apt-get dist-upgrade -qq
printTime "Linux Mint OS has checked for updates and has been upgraded."

clear
chmod 777 /etc/apt/apt.conf.d/10periodic
cp /etc/apt/apt.conf.d/10periodic ~/Desktop/backups/
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Download-Upgradeable-Packages \"1\";\nAPT::Periodic::AutocleanInterval \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";" > /etc/apt/apt.conf.d/10periodic
chmod 644 /etc/apt/apt.conf.d/10periodic
printTime "Daily update checks, download upgradeable packages, autoclean interval, and unattended upgrade enabled."

clear
apt-get autoremove -y -qq
apt-get autoclean -y -qq
apt-get clean -y -qq
printTime "All unused packages have been removed."


clear
if [[ $(grep root /etc/passwd | wc -l) -gt 1 ]]
then
	grep root /etc/passwd | wc -l
	echo -e "UID 0 is not correctly set to root. Please fix.\nPress enter to continue..."
	read waiting
else
	printTime "UID 0 is correctly set to root."
fi

clear
mkdir -p ~/Desktop/logs
chmod 777 ~/Desktop/logs
printTime "Logs folder has been created on the Desktop."

cp /etc/services ~/Desktop/logs/allports.log
chmod 777 ~/Desktop/logs/allports.log
printTime "All ports log has been created."
dpkg -l > ~/Desktop/logs/packages.log
chmod 777 ~/Desktop/logs/packages.log
printTime "All packages log has been created."
apt-mark showmanual > ~/Desktop/logs/manuallyinstalled.log
chmod 777 ~/Desktop/logs/manuallyinstalled.log
printTime "All manually instealled packages log has been created."
service --status-all > ~/Desktop/logs/allservices.txt
chmod 777 ~/Desktop/logs/allservices.txt
printTime "All running services log has been created."
ps ax > ~/Desktop/logs/processes.log
chmod 777 ~/Desktop/logs/processes.log
printTime "All running processes log has been created."
ss -l > ~/Desktop/logs/socketconnections.log
chmod 777 ~/Desktop/logs/socketconnections.log
printTime "All socket connections log has been created."
sudo netstat -tlnp > ~/Desktop/logs/listeningports.log
chmod 777 ~/Desktop/logs/listeningports.log
printTime "All listening ports log has been created."
cp /var/log/auth.log ~/Desktop/logs/auth.log
chmod 777 ~/Desktop/logs/auth.log
printTime "Auth log has been created."
cp /var/log/auth.log ~/Desktop/logs/syslog.log
chmod 777 ~/Desktop/logs/syslog.log
printTime "System log has been created."