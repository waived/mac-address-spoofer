#!/bin/bash
if [ "$(id -u)" -ne 0 ]; then
    echo "Script requires root elevation!" >&2
    exit 1
fi

dt=$(date +"%Y-%m-%d_%H-%M-%S")
save="mac_history_$dt.txt"

# save back-up of original MAC address for both Ethernet and Wi-Fi interfaces
wifi=$(ifconfig wlan0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
wired=$(ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
echo "Wireless: "$wifi "/ Ethernet: "$wired >>$save
sudo chattr -i $save

clear
RED='\033[0;31m'
WHITE='\033[1;37m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
printf "${GREEN}                        .odMM#MMbo.
                      dMMMMMM#MMMMMMb.
                    6MMMMMMMM#MMMMMMMMb.
                   6MMMMMMMMM#MMMMMMMMMM
                  8MMMMMMMMMM#MMMMMMMMMM8
                  MMMMMMMMMMM#MMMMMMMMMMM
                 8MMMMMMMMMMM#MMMMMMMMMMM8\n"


printf "${GREEN}                 NMM ${WHITE}TOPOFTHEFOODCHAIN ${GREEN}MMM\n"
printf "${GREEN}                 MMMMMMMMMMMM#MMMMMMMMMMMM
                 MMN     QMMM#MMMP     MMM
                 MMM    ${RED}@ ${GREEN};MM#MM     ${RED}@ ${GREEN}MMM
                 MMMb.   .dMM#MMb.   .dMMM
                dMMMMMMMMMMMMM#MMMMMMMMMMMb
                8MMMMMMMMMMMMM#MMMMMMMMMMM8
                QMMMMMMMMMMMMM#MMMMMMMMMMMP
                 MMMMMMMMMMMM#MMMMMMMMMMMM
                 QMMMMMMMMP     QMMMMMMMMP
                  8MMMMMMK${RED} ~~~~~ ${GREEN}XMMMMMM8
                  NMMMMMMMb.   .dMMMMMMMN
                  MMMMMMMMMMM#MMMMMMMMMMK.
                 dMMMMMMMMMMM#MMMMMMMMMMMM
               ,dMMMMMMMMMMMM#MMMMMMMMMMMMb
               MMMMMMMMMMMMMM#MMMMMMMMMMMMM8\n"
printf "${GREEN}             dMMMM ${WHITE}MAC ADDRESS SPOOFER ${GREEN}MMMMMb\n"
printf "${GREEN}            8MMMMMMMMMMMMMMM#MMMMMMMMMMMMMMM8${NC}\n"
printf ${NC}"\n"
echo DEVICE"("S")" DETECTED
echo ---------------------------------------------------------------------
sudo nmcli device status
echo ---------------------------------------------------------------------
echo 
read -p "Enter in DEVICE: " INT
read -p "Enter in new MAC ADDRESS [XX:XX:XX:XX:XX:XX]: " MAC
echo 
read -t 3 -p "Shutting down all interfaces..."\n
sudo ifconfig wlan0 down
sudo ifconfig eth0 down
sudo ifconfig lo down
read -t 1 -p "Altering previous MAC address..."\n
read -t 1 -p "Changing MAC address..."\n
sudo ifconfig $INT hw ether $MAC
read -t 3 -p "Restarting Network Manager SVC..."\n
sudo service network-manager start
read -t 3 -p "Unblocking interface RF output..."\n
sudo rfkill unblock all
read -t 3 -p "Restarting all interfaces..."\n
sudo ifconfig wlan0 up
sudo ifconfig eth0 up
sudo ifconfig lo up
echo 
echo MAC Address changed successfully!
read -p "Strike ENTER to exit..."\n
exit
