#!/bin/bash
clear
echo "Created by Matthew Bierman, Lightning McQueens, Faith Lutheran Middle & High School, Las Vegas, NV, USA"
echo "Last Modified on Friday, January 21st, 2016, 7:20am"
echo "Linux Ubuntu Script"
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

printTime "The current OS is Linux Ubuntu."

mkdir -p ~/Desktop/backups
chmod 777 ~/Desktop/backups
printTime "Backups folder created on the Desktop."

cp /etc/group ~/Desktop/backups/
cp /etc/passwd ~/Desktop/backups/

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
printTime "Root account has been locked. Use 'usermod -U root' to unlock it."

clear
chmod 640 .bash_history
printTime "Bash history file permissions set."

clear
chmod 604 /etc/shadow
printTime "Read/Write permissions on shadow have been set."

clear
printTime "Check for any user folders that do not belong to any users in /home/."
ls -a /home/ >> ~/Desktop/Script.log

clear
printTime "Check for any files for users that should not be administrators in /etc/sudoers.d."
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
env i='() { :;}; echo Your system is Bash vulnerable' bash -c "echo Bash vulnerability test"
printTime "Shellshock Bash vulnerability has been fixed."

clear
chmod 777 /etc/hosts
cp /etc/hosts ~/Desktop/backups/
echo > /etc/hosts
echo -e "127.0.0.1 localhost\n127.0.1.1 $USER\n::1 ip6-localhost ip6-loopback\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters" >> /etc/hosts
chmod 644 /etc/hosts
printTime "HOSTS file has been set to defaults."

clear
chmod 777 /etc/lightdm/lightdm.conf
cp /etc/lightdm/lightdm.conf ~/Desktop/backups/
echo > /etc/lightdm/lightdm.conf
echo -e '[SeatDefaults]\nallow-guest=false\ngreeter-hide-users=true\ngreeter-show-manual-login=true' >> /etc/lightdm/lightdm.conf
chmod 644 /etc/lightdm/lightdm.conf
printTime "LightDM has been secured."

clear
find /bin/ -name "*.sh" -type f -delete
printTime "Scripts in bin have been removed."

clear
cp /etc/default/irqbalance ~/Desktop/backups/
echo > /etc/default/irqbalance
echo -e "#Configuration for the irqbalance daemon\n\n#Should irqbalance be enabled?\nENABLED=\"0\"\n#Balance the IRQs only once?\nONESHOT=\"0\"" >> /etc/default/irqbalance
printTime "IRQ Balance has been disabled."

clear
cp /etc/sysctl.conf ~/Desktop/backups/
echo > /etc/sysctl.conf
echo -e "# Controls IP packet forwarding\nnet.ipv4.ip_forward = 0\n\n# IP Spoofing protection\nnet.ipv4.conf.all.rp_filter = 1\nnet.ipv4.conf.default.rp_filter = 1\n\n# Ignore ICMP broadcast requests\nnet.ipv4.icmp_echo_ignore_broadcasts = 1\n\n# Disable source packet routing\nnet.ipv4.conf.all.accept_source_route = 0\nnet.ipv6.conf.all.accept_source_route = 0\nnet.ipv4.conf.default.accept_source_route = 0\nnet.ipv6.conf.default.accept_source_route = 0\n\n# Ignore send redirects\nnet.ipv4.conf.all.send_redirects = 0\nnet.ipv4.conf.default.send_redirects = 0\n\n# Block SYN attacks\nnet.ipv4.tcp_syncookies = 1\nnet.ipv4.tcp_max_syn_backlog = 2048\nnet.ipv4.tcp_synack_retries = 2\nnet.ipv4.tcp_syn_retries = 5\n\n# Log Martians\nnet.ipv4.conf.all.log_martians = 1\nnet.ipv4.icmp_ignore_bogus_error_responses = 1\n\n# Ignore ICMP redirects\nnet.ipv4.conf.all.accept_redirects = 0\nnet.ipv6.conf.all.accept_redirects = 0\nnet.ipv4.conf.default.accept_redirects = 0\nnet.ipv6.conf.default.accept_redirects = 0\n\n# Ignore Directed pings\nnet.ipv4.icmp_echo_ignore_all = 1\n\n# Accept Redirects? No, this is not router\nnet.ipv4.conf.all.secure_redirects = 0\n\n# Log packets with impossible addresses to kernel log? yes\nnet.ipv4.conf.default.secure_redirects = 0\n\n########## IPv6 networking start ##############\n# Number of Router Solicitations to send until assuming no routers are present.\n# This is host and not router\nnet.ipv6.conf.default.router_solicitations = 0\n\n# Accept Router Preference in RA?\nnet.ipv6.conf.default.accept_ra_rtr_pref = 0\n\n# Learn Prefix Information in Router Advertisement\nnet.ipv6.conf.default.accept_ra_pinfo = 0\n\n# Setting controls whether the system will accept Hop Limit settings from a router advertisement\nnet.ipv6.conf.default.accept_ra_defrtr = 0\n\n#router advertisements can cause the system to assign a global unicast address to an interface\nnet.ipv6.conf.default.autoconf = 0\n\n#how many neighbor solicitations to send out per address?\nnet.ipv6.conf.default.dad_transmits = 0\n\n# How many global unicast IPv6 addresses can be assigned to each interface?
net.ipv6.conf.default.max_addresses = 1\n\n########## IPv6 networking ends ##############" >> /etc/sysctl.conf
sysctl -p >> /dev/null
printTime "Sysctl has been configured."


echo Disable IPv6?
read ipv6YN
if [ $ipv6YN == yes ]
then
	echo -e "\n\n# Disable IPv6\nnet.ipv6.conf.all.disable_ipv6 = 1\nnet.ipv6.conf.default.disable_ipv6 = 1\nnet.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
	sysctl -p >> /dev/null
	printTime "IPv6 has been disabled."
fi

clear
if [ $sambaYN == no ]
then
	ufw deny netbios-ns
	ufw deny netbios-dgm
	ufw deny netbios-ssn
	ufw deny microsoft-ds
	apt-get purge samba -y -qq
	apt-get purge samba-common -y  -qq
	apt-get purge samba-common-bin -y -qq
	apt-get purge samba4 -y -qq
	clear
	printTime "netbios-ns, netbios-dgm, netbios-ssn, and microsoft-ds ports have been denied. Samba has been removed."
elif [ $sambaYN == yes ]
then
	ufw allow netbios-ns
	ufw allow netbios-dgm
	ufw allow netbios-ssn
	ufw allow microsoft-ds
	apt-get install samba -y -qq
	apt-get install system-config-samba -y -qq
	cp /etc/samba/smb.conf ~/Desktop/backups/
	if [ "$(grep '####### Authentication #######' /etc/samba/smb.conf)"==0 ]
	then
		sed -i 's/####### Authentication #######/####### Authentication #######\nsecurity = user/g' /etc/samba/smb.conf
	fi
	sed -i 's/usershare allow guests = no/usershare allow guests = yes/g' /etc/samba/smb.conf
	
	echo Type all user account names, with a space in between
	read -a usersSMB
	usersSMBLength=${#usersSMB[@]}	
	for (( i=0;i<$usersSMBLength;i++))
	do
		echo -e 'Moodle!22\nMoodle!22' | smbpasswd -a ${usersSMB[${i}]}
		printTime "${usersSMB[${i}]} has been given the password 'Moodle!22' for Samba."
	done
	printTime "netbios-ns, netbios-dgm, netbios-ssn, and microsoft-ds ports have been denied. Samba config file has been configured."
	clear
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
	apt-get install openssh-server -y -qq
	ufw allow ssh
	cp /etc/ssh/sshd_config ~/Desktop/backups/	
	echo Type all user account names, with a space in between
	read usersSSH
	echo -e "# Package generated configuration file\n# See the sshd_config(5) manpage for details\n\n# What ports, IPs and protocols we listen for\nPort 2200\n# Use these options to restrict which interfaces/protocols sshd will bind to\n#ListenAddress ::\n#ListenAddress 0.0.0.0\nProtocol 2\n# HostKeys for protocol version \nHostKey /etc/ssh/ssh_host_rsa_key\nHostKey /etc/ssh/ssh_host_dsa_key\nHostKey /etc/ssh/ssh_host_ecdsa_key\nHostKey /etc/ssh/ssh_host_ed25519_key\n#Privilege Separation is turned on for security\nUsePrivilegeSeparation yes\n\n# Lifetime and size of ephemeral version 1 server key\nKeyRegenerationInterval 3600\nServerKeyBits 1024\n\n# Logging\nSyslogFacility AUTH\nLogLevel VERBOSE\n\n# Authentication:\nLoginGraceTime 60\nPermitRootLogin no\nStrictModes yes\n\nRSAAuthentication yes\nPubkeyAuthentication yes\n#AuthorizedKeysFile	%h/.ssh/authorized_keys\n\n# Don't read the user's ~/.rhosts and ~/.shosts files\nIgnoreRhosts yes\n# For this to work you will also need host keys in /etc/ssh_known_hosts\nRhostsRSAAuthentication no\n# similar for protocol version 2\nHostbasedAuthentication no\n# Uncomment if you don't trust ~/.ssh/known_hosts for RhostsRSAAuthentication\n#IgnoreUserKnownHosts yes\n\n# To enable empty passwords, change to yes (NOT RECOMMENDED)\nPermitEmptyPasswords no\n\n# Change to yes to enable challenge-response passwords (beware issues with\n# some PAM modules and threads)\nChallengeResponseAuthentication yes\n\n# Change to no to disable tunnelled clear text passwords\nPasswordAuthentication no\n\n# Kerberos options\n#KerberosAuthentication no\n#KerberosGetAFSToken no\n#KerberosOrLocalPasswd yes\n#KerberosTicketCleanup yes\n\n# GSSAPI options\n#GSSAPIAuthentication no\n#GSSAPICleanupCredentials yes\n\nX11Forwarding no\nX11DisplayOffset 10\nPrintMotd no\nPrintLastLog no\nTCPKeepAlive yes\n#UseLogin no\n\nMaxStartups 2\n#Banner /etc/issue.net\n\n# Allow client to pass locale environment variables\nAcceptEnv LANG LC_*\n\nSubsystem sftp /usr/lib/openssh/sftp-server\n\n# Set this to 'yes' to enable PAM authentication, account processing,\n# and session processing. If this is enabled, PAM authentication will\n# be allowed through the ChallengeResponseAuthentication and\n# PasswordAuthentication.  Depending on your PAM configuration,\n# PAM authentication via ChallengeResponseAuthentication may bypass\n# the setting of \"PermitRootLogin without-password\".\n# If you just want the PAM account and session checks to run without\n# PAM authentication, then enable this but set PasswordAuthentication\n# and ChallengeResponseAuthentication to 'no'.\nUsePAM yes\n\nAllowUsers $usersSSH\nDenyUsers\nRhostsAuthentication no\nClientAliveInterval 300\nClientAliveCountMax 0\nVerifyReverseMapping yes\nAllowTcpForwarding no\nUseDNS no\nPermitUserEnvironment no" > /etc/ssh/sshd_config
	service ssh restart
	mkdir ~/.ssh
	chmod 700 ~/.ssh
	ssh-keygen -t rsa
	printTime "SSH port has been allowed on the firewall. SSH config file has been configured. SSH RSA 2048 keys have been created."
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
	apt-get purge inetutils-telnetd -y -qq
	apt-get purge telnetd-ssl -y -qq
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
	apt-get purge mysql-client-core-5.6 -y -qq
	apt-get purge mysql-common-5.5 -y -qq
	apt-get purge mysql-common-5.6 -y -qq
	apt-get purge mysql-server -y -qq
	apt-get purge mysql-server-5.5 -y -qq
	apt-get purge mysql-server-5.6 -y -qq
	apt-get purge mysql-client-5.5 -y -qq
	apt-get purge mysql-client-5.6 -y -qq
	apt-get purge mysql-server-core-5.6 -y -qq
	printTime "ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been denied on the firewall. MySQL has been removed."
elif [ $dbYN == yes ]
then
	ufw allow ms-sql-s 
	ufw allow ms-sql-m 
	ufw allow mysql 
	ufw allow mysql-proxy
	apt-get install mysql-server-5.6 -y -qq
	cp /etc/my.cnf ~/Desktop/backups/
	cp /etc/mysql/my.cnf ~/Desktop/backups/
	cp /usr/etc/my.cnf ~/Desktop/backups/
	cp ~/.my.cnf ~/Desktop/backups/
	if grep -q "bind-address" "/etc/mysql/my.cnf"
	then
		sed -i "s/bind-address\t\t=.*/bind-address\t\t= 127.0.0.1/g" /etc/mysql/my.cnf
	fi
	gedit /etc/my.cnf&gedit /etc/mysql/my.cnf&gedit /usr/etc/my.cnf&gedit ~/.my.cnf
	service mysql restart
	printTime "ms-sql-s, ms-sql-m, mysql, and mysql-proxy ports have been allowed on the firewall. MySQL has been installed. MySQL config file has been secured. MySQL service has been restarted."
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
	apt-get install apache2 -y -qq
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
	find / -name "*.midi" -type f >> ~/Desktop/Script.log
	find / -name "*.mid" -type f >> ~/Desktop/Script.log
	find / -name "*.mod" -type f >> ~/Desktop/Script.log
	find / -name "*.mp3" -type f >> ~/Desktop/Script.log
	find / -name "*.mp2" -type f >> ~/Desktop/Script.log
	find / -name "*.mpa" -type f >> ~/Desktop/Script.log
	find / -name "*.abs" -type f >> ~/Desktop/Script.log
	find / -name "*.mpega" -type f >> ~/Desktop/Script.log
	find / -name "*.au" -type f >> ~/Desktop/Script.log
	find / -name "*.snd" -type f >> ~/Desktop/Script.log
	find / -name "*.wav" -type f >> ~/Desktop/Script.log
	find / -name "*.aiff" -type f >> ~/Desktop/Script.log
	find / -name "*.aif" -type f >> ~/Desktop/Script.log
	find / -name "*.sid" -type f >> ~/Desktop/Script.log
	find / -name "*.flac" -type f >> ~/Desktop/Script.log
	find / -name "*.ogg" -type f >> ~/Desktop/Script.log
	clear
	printTime "All audio files has been listed."

	find / -name "*.mpeg" -type f >> ~/Desktop/Script.log
	find / -name "*.mpg" -type f >> ~/Desktop/Script.log
	find / -name "*.mpe" -type f >> ~/Desktop/Script.log
	find / -name "*.dl" -type f >> ~/Desktop/Script.log
	find / -name "*.movie" -type f >> ~/Desktop/Script.log
	find / -name "*.movi" -type f >> ~/Desktop/Script.log
	find / -name "*.mv" -type f >> ~/Desktop/Script.log
	find / -name "*.iff" -type f >> ~/Desktop/Script.log
	find / -name "*.anim5" -type f >> ~/Desktop/Script.log
	find / -name "*.anim3" -type f >> ~/Desktop/Script.log
	find / -name "*.anim7" -type f >> ~/Desktop/Script.log
	find / -name "*.avi" -type f >> ~/Desktop/Script.log
	find / -name "*.vfw" -type f >> ~/Desktop/Script.log
	find / -name "*.avx" -type f >> ~/Desktop/Script.log
	find / -name "*.fli" -type f >> ~/Desktop/Script.log
	find / -name "*.flc" -type f >> ~/Desktop/Script.log
	find / -name "*.mov" -type f >> ~/Desktop/Script.log
	find / -name "*.qt" -type f >> ~/Desktop/Script.log
	find / -name "*.spl" -type f >> ~/Desktop/Script.log
	find / -name "*.swf" -type f >> ~/Desktop/Script.log
	find / -name "*.dcr" -type f >> ~/Desktop/Script.log
	find / -name "*.dir" -type f >> ~/Desktop/Script.log
	find / -name "*.dxr" -type f >> ~/Desktop/Script.log
	find / -name "*.rpm" -type f >> ~/Desktop/Script.log
	find / -name "*.rm" -type f >> ~/Desktop/Script.log
	find / -name "*.smi" -type f >> ~/Desktop/Script.log
	find / -name "*.ra" -type f >> ~/Desktop/Script.log
	find / -name "*.ram" -type f >> ~/Desktop/Script.log
	find / -name "*.rv" -type f >> ~/Desktop/Script.log
	find / -name "*.wmv" -type f >> ~/Desktop/Script.log
	find / -name "*.asf" -type f >> ~/Desktop/Script.log
	find / -name "*.asx" -type f >> ~/Desktop/Script.log
	find / -name "*.wma" -type f >> ~/Desktop/Script.log
	find / -name "*.wax" -type f >> ~/Desktop/Script.log
	find / -name "*.wmv" -type f >> ~/Desktop/Script.log
	find / -name "*.wmx" -type f >> ~/Desktop/Script.log
	find / -name "*.3gp" -type f >> ~/Desktop/Script.log
	find / -name "*.mov" -type f >> ~/Desktop/Script.log
	find / -name "*.mp4" -type f >> ~/Desktop/Script.log
	find / -name "*.avi" -type f >> ~/Desktop/Script.log
	find / -name "*.swf" -type f >> ~/Desktop/Script.log
	find / -name "*.flv" -type f >> ~/Desktop/Script.log
	find / -name "*.m4v" -type f >> ~/Desktop/Script.log
	clear
	printTime "All video files have been listed."
	
	find / -name "*.tiff" -type f >> ~/Desktop/Script.log
	find / -name "*.tif" -type f >> ~/Desktop/Script.log
	find / -name "*.rs" -type f >> ~/Desktop/Script.log
	find / -name "*.im1" -type f >> ~/Desktop/Script.log
	find / -name "*.gif" -type f >> ~/Desktop/Script.log
	find / -name "*.jpeg" -type f >> ~/Desktop/Script.log
	find / -name "*.jpg" -type f >> ~/Desktop/Script.log
	find / -name "*.jpe" -type f >> ~/Desktop/Script.log
	find / -name "*.png" -type f >> ~/Desktop/Script.log
	find / -name "*.rgb" -type f >> ~/Desktop/Script.log
	find / -name "*.xwd" -type f >> ~/Desktop/Script.log
	find / -name "*.xpm" -type f >> ~/Desktop/Script.log
	find / -name "*.ppm" -type f >> ~/Desktop/Script.log
	find / -name "*.pbm" -type f >> ~/Desktop/Script.log
	find / -name "*.pgm" -type f >> ~/Desktop/Script.log
	find / -name "*.pcx" -type f >> ~/Desktop/Script.log
	find / -name "*.ico" -type f >> ~/Desktop/Script.log
	find / -name "*.svg" -type f >> ~/Desktop/Script.log
	find / -name "*.svgz" -type f >> ~/Desktop/Script.log
	clear
	printTime "All image files have been listed."
else
	echo Response not recognized.
fi
printTime "Media files are complete."

clear
find / -type f -perm 777 >> ~/Desktop/Script.log
find / -type f -perm 776 >> ~/Desktop/Script.log
find / -type f -perm 775 >> ~/Desktop/Script.log
find / -type f -perm 774 >> ~/Desktop/Script.log
find / -type f -perm 773 >> ~/Desktop/Script.log
find / -type f -perm 772 >> ~/Desktop/Script.log
find / -type f -perm 771 >> ~/Desktop/Script.log
find / -type f -perm 770 >> ~/Desktop/Script.log
find / -type f -perm 767 >> ~/Desktop/Script.log
find / -type f -perm 766 >> ~/Desktop/Script.log
find / -type f -perm 765 >> ~/Desktop/Script.log
find / -type f -perm 764 >> ~/Desktop/Script.log
find / -type f -perm 763 >> ~/Desktop/Script.log
find / -type f -perm 762 >> ~/Desktop/Script.log
find / -type f -perm 761 >> ~/Desktop/Script.log
find / -type f -perm 760 >> ~/Desktop/Script.log
find / -type f -perm 757 >> ~/Desktop/Script.log
find / -type f -perm 756 >> ~/Desktop/Script.log
find / -type f -perm 755 >> ~/Desktop/Script.log
find / -type f -perm 754 >> ~/Desktop/Script.log
find / -type f -perm 753 >> ~/Desktop/Script.log
find / -type f -perm 752 >> ~/Desktop/Script.log
find / -type f -perm 751 >> ~/Desktop/Script.log
find / -type f -perm 750 >> ~/Desktop/Script.log
find / -type f -perm 747 >> ~/Desktop/Script.log
find / -type f -perm 746 >> ~/Desktop/Script.log
find / -type f -perm 745 >> ~/Desktop/Script.log
find / -type f -perm 744 >> ~/Desktop/Script.log
find / -type f -perm 743 >> ~/Desktop/Script.log
find / -type f -perm 742 >> ~/Desktop/Script.log
find / -type f -perm 741 >> ~/Desktop/Script.log
find / -type f -perm 740 >> ~/Desktop/Script.log
find / -type f -perm 737 >> ~/Desktop/Script.log
find / -type f -perm 736 >> ~/Desktop/Script.log
find / -type f -perm 735 >> ~/Desktop/Script.log
find / -type f -perm 734 >> ~/Desktop/Script.log
find / -type f -perm 733 >> ~/Desktop/Script.log
find / -type f -perm 732 >> ~/Desktop/Script.log
find / -type f -perm 731 >> ~/Desktop/Script.log
find / -type f -perm 730 >> ~/Desktop/Script.log
find / -type f -perm 727 >> ~/Desktop/Script.log
find / -type f -perm 726 >> ~/Desktop/Script.log
find / -type f -perm 725 >> ~/Desktop/Script.log
find / -type f -perm 724 >> ~/Desktop/Script.log
find / -type f -perm 723 >> ~/Desktop/Script.log
find / -type f -perm 722 >> ~/Desktop/Script.log
find / -type f -perm 721 >> ~/Desktop/Script.log
find / -type f -perm 720 >> ~/Desktop/Script.log
find / -type f -perm 717 >> ~/Desktop/Script.log
find / -type f -perm 716 >> ~/Desktop/Script.log
find / -type f -perm 715 >> ~/Desktop/Script.log
find / -type f -perm 714 >> ~/Desktop/Script.log
find / -type f -perm 713 >> ~/Desktop/Script.log
find / -type f -perm 712 >> ~/Desktop/Script.log
find / -type f -perm 711 >> ~/Desktop/Script.log
find / -type f -perm 710 >> ~/Desktop/Script.log
find / -type f -perm 707 >> ~/Desktop/Script.log
find / -type f -perm 706 >> ~/Desktop/Script.log
find / -type f -perm 705 >> ~/Desktop/Script.log
find / -type f -perm 704 >> ~/Desktop/Script.log
find / -type f -perm 703 >> ~/Desktop/Script.log
find / -type f -perm 702 >> ~/Desktop/Script.log
find / -type f -perm 701 >> ~/Desktop/Script.log
find / -type f -perm 700 >> ~/Desktop/Script.log
printTime "All files with file permissions between 700 and 777 have been listed above."

clear
find / -name "*.php" -type f >> ~/Desktop/Script.log
printTime "All PHP files have been listed above. ('/var/cache/dictionaries-common/sqspell.php' is a system PHP file)"

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

apt-get purge logkeys -y -qq
clear 
printTime "LogKeys has been removed."

apt-get purge zeitgeist-core -y -qq
apt-get purge zeitgeist-datahub -y -qq
apt-get purge python-zeitgeist -y -qq
apt-get purge rhythmbox-plugin-zeitgeist -y -qq
apt-get purge zeitgeist -y -qq
printTime "Zeitgeist has been removed."

apt-get purge nfs-kernel-server -y -qq
apt-get purge nfs-common -y -qq
apt-get purge portmap -y -qq
apt-get purge rpcbind -y -qq
apt-get purge autofs -y -qq
printTime "NFS has been removed."

apt-get purge nginx -y -qq
apt-get purge nginx-common -y -qq
printTime "NGINX has been removed."

apt-get purge inetd -y -qq
apt-get purge openbsd-inetd -y -qq
apt-get purge xinetd -y -qq
apt-get purge inetutils-ftp -y -qq
apt-get purge inetutils-ftpd -y -qq
apt-get purge inetutils-inetd -y -qq
apt-get purge inetutils-ping -y -qq
apt-get purge inetutils-syslogd -y -qq
apt-get purge inetutils-talk -y -qq
apt-get purge inetutils-talkd -y -qq
apt-get purge inetutils-telnet -y -qq
apt-get purge inetutils-telnetd -y -qq
apt-get purge inetutils-tools -y -qq
apt-get purge inetutils-traceroute -y -qq
printTime "Inetd (super-server) and all inet utilities have been removed."

clear
apt-get purge vnc4server -y -qq
apt-get purge vncsnapshot -y -qq
apt-get purge vtgrab -y -qq
printTime "VNC has been removed."

clear
apt-get purge snmp -y -qq
printTime "SNMP has been removed."

clear
cp /etc/login.defs ~/Desktop/backups/
sed -i '160s/.*/PASS_MAX_DAYS\o01130/' /etc/login.defs
sed -i '161s/.*/PASS_MIN_DAYS\o0113/' /etc/login.defs
sed -i '162s/.*/PASS_MIN_LEN\o0118/' /etc/login.defs
sed -i '163s/.*/PASS_WARN_AGE\o0117/' /etc/login.defs
printTime "Password policies have been set with /etc/login.defs."

clear
apt-get install libpam-cracklib -y -qq
cp /etc/pam.d/common-auth ~/Desktop/backups/
cp /etc/pam.d/common-password ~/Desktop/backups/
echo -e "#\n# /etc/pam.d/common-auth - authentication settings common to all services\n#\n# This file is included from other service-specific PAM config files,\n# and should contain a list of the authentication modules that define\n# the central authentication scheme for use on the system\n# (e.g., /etc/shadow, LDAP, Kerberos, etc.).  The default is to use the\n# traditional Unix authentication mechanisms.\n#\n# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.\n# To take advantage of this, it is recommended that you configure any\n# local modules either before or after the default block, and use\n# pam-auth-update to manage selection of other modules.  See\n# pam-auth-update(8) for details.\n\n# here are the per-package modules (the \"Primary\" block)\nauth	[success=1 default=ignore]	pam_unix.so nullok_secure\n# here's the fallback if no module succeeds\nauth	requisite			pam_deny.so\n# prime the stack with a positive return value if there isn't one already;\n# this avoids us returning an error just because nothing sets a success code\n# since the modules above will each just jump around\nauth	required			pam_permit.so\n# and here are more per-package modules (the \"Additional\" block)\nauth	optional			pam_cap.so \n# end of pam-auth-update config\nauth required pam_tally2.so deny=5 unlock_time=1800 onerr=fail audit even_deny_root_account silent" > /etc/pam.d/common-auth
echo -e "#\n# /etc/pam.d/common-password - password-related modules common to all services\n#\n# This file is included from other service-specific PAM config files,\n# and should contain a list of modules that define the services to be\n# used to change user passwords.  The default is pam_unix.\n\n# Explanation of pam_unix options:\n#\n# The \"sha512\" option enables salted SHA512 passwords.  Without this option,\n# the default is Unix crypt.  Prior releases used the option \"md5\".\n#\n# The \"obscure\" option replaces the old \`OBSCURE_CHECKS_ENAB\' option in\n# login.defs.\n#\n# See the pam_unix manpage for other options.\n\n# As of pam 1.0.1-6, this file is managed by pam-auth-update by default.\n# To take advantage of this, it is recommended that you configure any\n# local modules either before or after the default block, and use\n# pam-auth-update to manage selection of other modules.  See\n# pam-auth-update(8) for details.\n\n# here are the per-package modules (the \"Primary\" block)\npassword	[success=1 default=ignore]	pam_unix.so obscure sha512\n# here's the fallback if no module succeeds\npassword	requisite			pam_deny.so\n# prime the stack with a positive return value if there isn't one already;\n# this avoids us returning an error just because nothing sets a success code\n# since the modules above will each just jump around\npassword	required			pam_permit.so\n# and here are more per-package modules (the \"Additional\" block)\npassword	optional	pam_gnome_keyring.so \n# end of pam-auth-update config" > /etc/pam.d/common-password
printTime "If password policies are not correctly configured, try this for /etc/pam.d/common-password:\npassword requisite pam_cracklib.so retry=3 minlen=8 difok=3 reject_username minclass=3 maxrepeat=2 dcredit=1 ucredit=1 lcredit=1 ocredit=1\npassword requisite pam_pwhistory.so use_authtok remember=24 enforce_for_root"
printTime "Password policies have been set with and /etc/pam.d."

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
chmod 777 /etc/apt/apt.conf.d/10periodic
cp /etc/apt/apt.conf.d/10periodic ~/Desktop/backups/
echo -e "APT::Periodic::Update-Package-Lists \"1\";\nAPT::Periodic::Download-Upgradeable-Packages \"1\";\nAPT::Periodic::AutocleanInterval \"1\";\nAPT::Periodic::Unattended-Upgrade \"1\";" > /etc/apt/apt.conf.d/10periodic
chmod 644 /etc/apt/apt.conf.d/10periodic
printTime "Daily update checks, download upgradeable packages, autoclean interval, and unattended upgrade enabled."

clear
if [[ $(lsb_release -r) == "Release:	14.04" ]] || [[ $(lsb_release -r) == "Release:	14.10" ]]
then
	chmod 777 /etc/apt/sources.list
	cp /etc/apt/sources.list ~/Desktop/backups/
	echo -e "deb http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ trusty-proposed main restricted universe multiverse" > /etc/apt/sources.list
	chmod 644 /etc/apt/sources.list
elif [[ $(lsb_release -r) == "Release:	12.04" ]] || [[ $(lsb_release -r) == "Release:	12.10" ]]
then
	chmod 777 /etc/apt/sources.list
	cp /etc/apt/sources.list ~/Desktop/backups/
	echo -e "deb http://us.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse \ndeb-src http://us.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse \ndeb http://us.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse\ndeb http://us.archive.ubuntu.com/ubuntu/ precise-proposed main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse\ndeb-src http://us.archive.ubuntu.com/ubuntu/ precise-proposed main restricted universe multiverse" > /etc/apt/sources.list
	chmod 644 /etc/apt/sources.list
else
	echo “Error, cannot detect OS version”
fi
printTime "Apt Repositories have been added."

clear
apt-get update -qq
apt-get upgrade -qq
apt-get dist-upgrade -qq
printTime "Ubuntu OS has checked for updates and has been upgraded."

clear
apt-get autoremove -y -qq
apt-get autoclean -y -qq
apt-get clean -y -qq
printTime "All unused packages have been removed."

clear
echo "Check to verify that all update settings are correct."
update-manager

clear
apt-get update
apt-get upgrade openssl libssl-dev
apt-cache policy openssl libssl-dev
printTime "OpenSSL heart bleed bug has been fixed."

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

clear
touch ~/Desktop/logs/allusers.txt
uidMin=$(grep "^UID_MIN" /etc/login.defs)
uidMax=$(grep "^UID_MAX" /etc/login.defs)
echo -e "User Accounts:" >> ~/Desktop/logs/allusers.txt
awk -F':' -v "min=${uidMin##UID_MIN}" -v "max=${uidMax##UID_MAX}" '{ if ( $3 >= min && $3 <= max  && $7 != "/sbin/nologin" ) print $0 }' /etc/passwd >> ~/Desktop/logs/allusers.txt
echo -e "\nSystem Accounts:" >> ~/Desktop/logs/allusers.txt
awk -F':' -v "min=${uidMin##UID_MIN}" -v "max=${uidMax##UID_MAX}" '{ if ( !($3 >= min && $3 <= max  && $7 != "/sbin/nologin")) print $0 }' /etc/passwd >> ~/Desktop/logs/allusers.txt
printTime "All users have been logged."
cp /etc/services ~/Desktop/logs/allports.log
printTime "All ports log has been created."
dpkg -l > ~/Desktop/logs/packages.log
printTime "All packages log has been created."
apt-mark showmanual > ~/Desktop/logs/manuallyinstalled.log
printTime "All manually instealled packages log has been created."
service --status-all > ~/Desktop/logs/allservices.txt
printTime "All running services log has been created."
ps ax > ~/Desktop/logs/processes.log
printTime "All running processes log has been created."
ss -l > ~/Desktop/logs/socketconnections.log
printTime "All socket connections log has been created."
sudo netstat -tlnp > ~/Desktop/logs/listeningports.log
printTime "All listening ports log has been created."
cp /var/log/auth.log ~/Desktop/logs/auth.log
printTime "Auth log has been created."
cp /var/log/syslog ~/Desktop/logs/syslog.log
printTime "System log has been created."

clear
apt-get install tree -y -qq
apt-get install diffuse -y -qq
mkdir Desktop/Comparatives
chmod 777 Desktop/Comparatives

cp /etc/apt/apt.conf.d/10periodic Desktop/Comparatives/
cp Desktop/logs/allports.log Desktop/Comparatives/
cp Desktop/logs/allservices.txt Desktop/Comparatives/
touch Desktop/Comparatives/alltextfiles.txt
find . -type f -exec grep -Iq . {} \; -and -print >> Desktop/Comparatives/alltextfiles.txt
cp Desktop/logs/allusers.txt Desktop/Comparatives/
cp /etc/apache2/apache2.conf Desktop/Comparatives/
cp /etc/pam.d/common-auth Desktop/Comparatives/
cp /etc/pam.d/common-password Desktop/Comparatives/
cp /etc/init/control-alt-delete.conf Desktop/Comparatives/
crontab -l > Desktop/Comparatives/crontab.log
cp /etc/group Desktop/Comparatives/
cp /etc/hosts Desktop/Comparatives/
touch Desktop/Comparatives/initctl-running.txt
initctl list | grep running > Desktop/Comparatives/initctl-running.txt
cp /etc/lightdm/lightdm.conf Desktop/Comparatives/
cp Desktop/logs/listeningports.log Desktop/Comparatives/
cp /etc/login.defs Desktop/Comparatives/
cp Desktop/logs/manuallyinstalled.log Desktop/Comparatives/
cp /etc/mysql/my.cnf Desktop/Comparatives/
cp Desktop/logs/packages.log Desktop/Comparatives/
cp /etc/passwd Desktop/Comparatives/
cp Desktop/logs/processes.log Desktop/Comparatives/
cp /etc/rc.local Desktop/Comparatives/
cp /etc/samba/smb.conf Desktop/Comparatives/
cp Desktop/logs/socketconnections.log Desktop/Comparatives/
cp /etc/apt/sources.list Desktop/Comparatives/
cp /etc/ssh/sshd_config Desktop/Comparatives/
cp /etc/sudoers Desktop/Comparatives/
cp /etc/sysctl.conf Desktop/Comparatives/
tree / -o Desktop/Comparatives/tree.txt -n -p -h -u -g -D -v
cp /etc/vsftpd.conf Desktop/Comparatives/
printTime "Tree and Diffuse have been installed, files on current system have been copied for comparison."

chmod 777 -R Desktop/Comparatives/
chmod 777 -R Desktop/backups
chmod 777 -R Desktop/logs

clear
printTime "Script is complete."