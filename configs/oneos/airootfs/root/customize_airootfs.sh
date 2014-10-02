#!/bin/bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

usermod -s /usr/bin/zsh root
cp -aT /etc/skel/ /root/
chmod 700 /root

useradd -m -p "" -g users -G "adm,audio,floppy,log,network,rfkill,scanner,storage,optical,power,wheel" -s /usr/bin/zsh oneos

chmod 750 /etc/sudoers.d
chmod 440 /etc/sudoers.d/g_wheel

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf
sed -i "s/root-image/airootfs/" /usr/share/calamares/modules/unpackfs.conf
glib-compile-schemas /usr/share/glib-2.0/schemas
systemctl enable  graphical.target gdm.service pacman-init.service choose-mirror.service NetworkManager ModemManager  dhcpcd.service
systemctl set-default multi-user.target
rm -rf /etc/systemd/system/default.target
glib-compile-schemas /usr/share/glib-2.0/schemas
