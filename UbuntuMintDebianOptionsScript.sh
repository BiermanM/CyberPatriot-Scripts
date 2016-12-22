#!/bin/bash
clear
echo "Created by Matthew Bierman, Lightning McQueens, Faith Lutheran Middle & High School, Las Vegas, NV, USA"
echo "Last Modified on Friday, January 21st, 2016, 7:20am"
echo "Linux Ubuntu/Mint/Debian Options Script"

if [[ $EUID -ne 0 ]]
then
  echo This script must be run as root
  exit
fi

running=true

function nmap() 
{
    apt-get install nmap -y -qq
    clear
    
    sudo nmap localhost
    
    echo -e '\n\nPress enter to return to main menu...'
    read return
    clear 
}

function htop()
{
    apt-get install htop -y -qq
    clear
    
    sudo htop
    
    echo -e '\n\nPress enter to return to main menu...'
    read return
    clear
}

function clamav()
{
    apt-get install clamav -y -qq
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

  apt-get install rkhunter -y -qq
  clear
  
  sudo rkhunter -c --skip-keypress --autox --report-warnings-only
  
  cp /var/log/rkhunter.log ~/Desktop/logs/
  chmod 777 ~/Desktop/logs/rkhunter.log

  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

function chkrootkit()
{
  apt-get install chkrootkit -y -qq
  clear

  sudo chkrootkit -q

  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

function unhide()
{
  apt-get install unhide
  clear

  sudo unhide -f brute proc procall procfs quick reverse sys
  cp /home/$USER/unhide.log ~/Desktop/logs/
  chmod 777 ~/Desktop/logs/unhide.log

  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

function lynis()
{
  apt-get install lynis -y -qq
  lynis -c -Q --no-colors > ~/Desktop/logs/lynis.log
  chmod 777 ~/Desktop/logs/lynis.log
  
  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

function bum()
{
  apt-get install bum
  bum
  
  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}

function hardinfo()
{
  apt-get install hardinfo -y -qq
  hardinfo -r > ~/Desktop/logs/hardwareinfo.log 
  chmod 777 ~/Desktop/logs/hardwareinfo.log
  
  echo -e '\n\nPress enter to return to main menu...'
  read return
  clear
}



while [ "$running" = true ]
do
  echo -e 'Type the number of the option you choose (Type "exit" or "quit" to exit the program):\n1. HTOP (Task Manager)\n2. Nmap\n3. ClamAV (Anti-Virus)\n4. RKHunter (Anti-Rootkit)\n5. CHKRootkit (Anti-Rootkit)\n6. Unhide\n7. Lynis\n8. Bum (GUI for startup scripts and services)\n9. HardInfo'
  read answer
  clear

  if [ $answer == 1 ]
  then
    htop
    apt-get purge htop -y -qq
    clear
  fi

  if [ $answer == 2 ]
  then
    nmap
    apt-get purge nmap -y -qq
    clear
  fi

  if [ $answer == 3 ]
  then
    clamav
    apt-get purge clamav -y -qq
    clear
  fi

  if [ $answer == 4 ]
  then
    rkhunter
    apt-get purge rkhunter -y -qq
    clear
  fi

  if [ $answer == 5 ]
  then
    chkrootkit
    apt-get purge chkrootkit -y -qq
    clear
  fi

  if [ $answer == 6 ]
  then
    unhide
    apt-get purge unhide -y -qq
    clear
  fi

  if [ $answer == 7 ]
  then
    lynis
    apt-get purge lynis -y -qq
    clear
  fi

  if [ $answer == 8 ]
  then
    bum
    apt-get purge bum -y -qq
    clear
  fi

  if [ $answer == 9 ]
  then
    hardinfo
    apt-get purge hardinfo -y -qq
    clear
  fi

  if [ $answer == quit ] || [ $answer == exit ]
  then
    running=false
  fi
done
