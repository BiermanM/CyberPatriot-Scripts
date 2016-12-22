#!/bin/bash

if [[ $EUID -ne 0 ]]
then
  echo This script must be run as root
  exit
fi

running=true

function nmap() 
{
    dnf install nmap -y -q
    clear
    
    sudo nmap localhost
    
    echo -e '\n\nPress enter to return to main menu...'
    read return
    clear 
}

function htop()
{
    dnf install htop -y -q
    clear
    
    sudo htop
    
    echo -e '\n\nPress enter to return to main menu...'
    read return
    clear
}

function clamav()
{
    dnf install clamav clamav-update -y -q
    sed -i '8s/.*/#Example/' /etc/freshclam.conf
    sed -i '$d/.*/#FRESHCLAM_DELAY=disabled-warn/' /etc/sysconfig/freshclam    
    freshclam
    clear

    echo ClamAV scan is currently running
    clamscan --detect-broken=yes -r --enable-stats --bell >> ~/Desktop/clamavscan.log
    chmod 777 ~/Desktop/clamavscan.log

    echo -e '\n\nPress enter to return to main menu...'
    read return
    clear
}

function rkhunter()
{
  dnf install rkhunter -y -q
  clear
  
  sudo rkhunter -c --skip-keypress --autox --report-warnings-only
  
  cp /var/log/rkhunter/rkhunter.log ~/Desktop/logs/
  chmod 777 ~/Desktop/logs/rkhunter.log

  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

function chkrootkit()
{
  dnf install chkrootkit -y -q
  clear

  sudo chkrootkit > /home/$USER/Desktop/logs/chkrootkit.log
  chmod 777 /home/$USER/Desktop/logs/chkrootkit.log

  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

function unhide()
{
  dnf install unhide -y -q
  clear

  sudo unhide -f brute proc procall procfs quick reverse sys
  cp /home/$USER/unhide-linux_$(date +%Y-%m-%d).log /home/$USER/Desktop/logs/
  chmod 777 /home/$USER/Desktop/logs/unhide-linux_$(date +%Y-%m-%d).log

  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

function lynis()
{
  dnf install lynis -y -q
  clear

  sudo lynis -c -Q --no-colors > /home/$USER/Desktop/logs/lynis.log
  chmod 777 /home/$USER/Desktop/logs/lynis.log

  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

while [ "$running" = true ]
do
  echo -e 'Type the number of the option you choose (Type "exit" or "quit" to exit the program):\n1. HTOP (Task Manager)\n2. Nmap\n3. ClamAV\n4. RKHunter\n5. CHKRootkit\n6. Unhide\n7. Lynis'
  read answer
  clear

  if [ $answer == 1 ]
  then
    htop
    dnf remove htop -y -q
    clear
  fi

  if [ $answer == 2 ]
  then
    nmap
    dnf remove nmap -y -q
    clear
  fi

  if [ $answer == 3 ]
  then
    clamav
    dnf remove clamav -y -q
    clear
  fi

  if [ $answer == 4 ]
  then
    rkhunter
    dnf remove rkhunter -y -q
    clear
  fi

  if [ $answer == 5 ]
  then
    chkrootkit
    dnf remove chkrootkit -y -q
    clear
  fi

  if [ $answer == 6 ]
  then
    unhide
    dnf remove unhide -y -q
    clear
  fi

  if [ $answer == 7 ]
  then
    lynis
    dnf remove lynis -y -q
    clear
  fi

  if [ $answer == quit ] || [ $answer == exit ]
  then
    running=false
  fi
done
