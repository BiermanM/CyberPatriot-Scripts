# AFACP Scripts
Scripts created and used during the AFACP VIII competition

## Ubuntu Script / Debian Script / Mint Script / Fedora Script
Features:
* Log file is created to date and describe all events
* Verify script is being run as `root`
* Backs up all critical files
* Add/Remove users
* Modify user privileges
* Change user passwords
* Remove alias
* Lock `root` account
* Set correct permissions for `shadow`
* Remove unnecessary user directories in `/home/`
* Remove startup scripts
* Enable firewall
* Fix Shellshock Bash vulnerability
* Set `hosts` file to defaults
* Secure `LightDM`
* Remove scripts in `/bin/`
* Disable IRQ Balance
* Configure `sysctl`
* Enable/Disable IPv6
* Add (and configure)/Remove `samba`
* Add (and configure)/Remove `ftp`
* Add (and configure)/Remove `ssh`
* Add (and configure)/Remove `telnet`
* Add (and configure)/Remove mail
* Add (and configure)/Remove printing
* Add (and configure)/Remove `MySQL`
* Add (and configure)/Remove web servers
* Add (and configure)/Remove `dns`
* Remove all media files
* List all files with a file permission of 700-777
* List all `PHP` files
* Remove `netcat`, `John the Ripper`, `Hydra`, `Aircrack-NG`, `FCrackZIP`, `LCrack`, `OphCrack`, `PDFCrack`, `Pyrit`, `RARCrack`, `SipCrack`, `IRPAS`, `LogKeys`, `Zeitgeist`, `NFS`, `NGINX`, `Inetd`, `VNC`, and `SNMP`
* Set `login.defs` and `pam.d` password policies
* Deny false loopback packets
* Disable Ctrl-Alt-Del reboot
* Install `AppArmor`
* Remove startup tasks from `crontab`
* Allow only `root` in `cron`
* Add `apt` repositories
* Check and perform updates and operating system upgrades
* Remove unused packages
* Fix `OpenSSL` Heart Bleed bug
* Set UID 0 to `root`
* Create backups/logs for comparatives script

## Ubuntu, Mint, Debian Options Script / Fedora Options Script
Allows the user to use the following programs:
* `HTOP` (Task Manager)
* `Nmap` (Network Mapper)
* `ClamAV` (Anti-Virus)
* `RKHunter` (Anti-Rootkit)
* `CHKRootkit` (Anti-Rootkit)
* `Unhide` (Shows Hidden Processes & TCP/UDP Ports)
* `Lynis` (Security Auditing)
* `Bum` (GUI for Startup Scripts & Services)
* `HardInfo` (Hardware Analysis, System Benchmark, & Report Generator)

## Comparative Script
Uses the program `Diffuse` to compare various system files between the current files and the default system files as of January 21, 2016. `Diffuse` shows the differences in text between the two files using colored highlighting.
