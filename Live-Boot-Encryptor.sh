#!/bin/bash
#
# ENCRYPT the BOOT ON TAILS LIVE USB
# Ver. 2.1
# by. Hellresistor
#
counter(){
espera=5 # seconds
tmpcnt=${espera}
while [[ ${tmpcnt} -gt 0 ]];
do
    printf "\rYou have %2d second(s) remaining. Hit Ctrl+C to cancel!" ${tmpcnt}
    sleep 1
    ((tmpcnt--))
done
echo ""
}
tag(){
cat <<EOF
    ░ ░░                               
 ███░ █░          ░ ░            ░█░░█ 
█      ░█ ░▒███░░░  ░░█████░     ▓░ ░█ 
 ░░ ░▓▓░██░               ░▓██░██░   ░█
      ░█░                    ░██ ░█▒█▓█
      █░   ░███░    ░█░░▒      ██░     
     ░█    █                   ░█░     
     ░█                        ░█░     
      █░   █████░    █████     █░      
      ░█░  ██████   ▒█████░  ░█░       
        ██    ░██   ░███░█  ██         
      █░          █        ░░▓█        
 ░░░░██░░██░     █░█      ░██▓░ █░███░ 
▒░ ░░  ░█░██░▒         ▓█░█   ░█    █░ 
 ██░ █▓     ██░▓▓█░░██░███     █  █    
  ░█░▒▓         ░░░░░░░         ▓░░    
 
         @@  Hellresistor  @@

ENCRYPT W/ Pasword BOOT on TAILS Live USB

Required Things:
1x CD/DVD/USB Bootable Linux OS Live (Ubuntu Live, Tails Live, Kali Live...)
1x USB Stick WITH Tails Live Installed

Donate, If you want!
Bitcanna (BCNA): B73RRFVtndfPRNSgSQg34yqz4e9eWyKRSv
EOF
counter
}

check(){
echo "Checking as running as root user"
sleep 1
if [ "root" != "$USER" ]
  then  sudo su -c "$0" root
  exit
fi
}

inicio(){
echo "Listing Devices...."
sleep 1
fdisk -l
sleep 1
echo
read -p "What is your Disk/USB to be Encrypted? (ex: /dev/sdb1): " MyDisk && echo
echo -n "Mounting Selected Device --> $MyDisk "
mount $MyDisk /mnt/
echo && sleep 1 && echo "Drive Mounted on /mnt/" && echo && sleep 1
echo && echo && echo "Checking Tails as a CLEAN installation..."
TAILSS=/mnt/syslinux/menu.cfg
if grep -qF 'menu master passwd' "$TAILSS";
then
echo && sleep 1 && echo "Has been touched ..." && echo && sleep 1 && echo "Put it who it should be ..." && sleep 1 && echo && pass && echo && sleep 1 && echo && sleep 1 && echo && rollback && echo && sleep 1 && echo && install
else
echo && sleep 1 && echo "Tails Untouched.. As New.." && echo && sleep 1 && pass && echo && sleep 1 && echo && install
fi
}

pass(){
echo "Starting the party..."
echo && echo && sleep 1
echo "Insere a password? (Encrypta em SHA-512):" && echo
mkpasswd -m sha-512
echo && sleep 1 && echo
echo "Copia/Copy STRING COMPLET...JA/NOW !!" && sleep 1
echo "COLA/PASTE the String and compare (You Win a Big SHIT.... If you IGNORE THIS !!!)"
read MyEncrPass
echo && echo "PASSWORD ENCRYPTED INTO SHA-512" && echo && echo && sleep 2
}

install(){
echo "Go into to matters ....." && echo && sleep 1
echo "config EFI..." && sleep 1
MyTailsEfi=/mnt/EFI/BOOT/
sed -i "/prompt 0/i menu master passwd $MyEncrPass" $MyTailsEfi/menu.cfg
sed -i '/prompt 0/a noescape 1' $MyTailsEfi/menu.cfg
sed -i '/noescape 1/a allowoptions 0' $MyTailsEfi/menu.cfg
sed -i 's/timeout 40/timeout 0/' $MyTailsEfi/menu.cfg
sed -i '/menu label Tails/a menu passwd' $MyTailsEfi/live.cfg
sed -i '/menu label Tails/a menu passwd' $MyTailsEfi/live64.cfg
echo && echo "EFI boot DONE !!!" && echo && echo && sleep 1
echo "config SYSlinux.." && sleep 1
MyTailsSys=/mnt/syslinux/
sed -i "/prompt 0/i menu master passwd $MyEncrPass" $MyTailsSys/menu.cfg
sed -i '/prompt 0/a noescape 1' $MyTailsSys/menu.cfg
sed -i '/noescape 1/a allowoptions 0' $MyTailsSys/menu.cfg
sed -i 's/timeout 40/timeout 0/' $MyTailsSys/menu.cfg
sed -i '/menu label Tails/a menu passwd' $MyTailsSys/live.cfg
sed -i '/menu label Tails/a menu passwd' $MyTailsSys/live64.cfg
echo && echo "SYSlinux boot DONE !!!" && echo && echo && sleep 1
}

rollback(){
echo && echo && echo "Someone are touching here before ..." && sleep 2
echo "RE-Config EFI..." && echo
MyTailsEfi=/mnt/EFI/BOOT/
sed -i "/menu master passwd/d" $MyTailsEfi/menu.cfg
sed -i "/noescape/d" $MyTailsEfi/menu.cfg
sed -i "/allowoptions/d" $MyTailsEfi/menu.cfg
sed -i "s/timeout 0/timeout 40/" $MyTailsEfi/menu.cfg
sed -i "/menu passwd/d" $MyTailsEfi/live.cfg
sed -i "/menu passwd/d" $MyTailsEfi/live64.cfg
echo && echo && echo "EFI Reverted !!!" && echo && sleep 1
echo "RE-Config SYSlinux..."
MyTailsSys=/mnt/syslinux/
sed -i "/menu master passwd/d" $MyTailsSys/menu.cfg
sed -i "/noescape/d" $MyTailsSys/menu.cfg
sed -i "/allowoptions/d" $MyTailsSys/menu.cfg
sed -i "s/timeout 0/timeout 40/" $MyTailsSys/menu.cfg
sed -i "/menu passwd/d" $MyTailsSys/live.cfg
sed -i "/menu passwd/d" $MyTailsSys/live64.cfg
echo && echo && echo "SysLinx Revertedi !!!" && echo && sleep 1
}

fim(){
echo && echo && echo "Umounting drives..." && sleep 2
umount /mnt/
echo "TAILS BOOT ENCRIPTED !!!"
sleep 1
echo
for i in {1..15}; do
 echo "NOW ........ Don´t FORGOT THE PASSWORD to That Device"
done
echo && echo && sleep 2 && echo && echo "A Reiniciar...." && counter && reboot
}

check
tag
inicio
fim

exiit 0
