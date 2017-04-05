#手动配置一遍所有系统设置
#grub
/etc/default/grub:
GRUB_DEFAULT=0
GRUB_HIDDEN_TIMEOUT=0
GRUB_HIDDEN_TIMEOUT_QUIET=true
#GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX_DEFAULT=
GRUB_CMDLINE_LINUX="noprompt persistent"

sudo update-grub

#capslock as another ctrl
gnome-tweak-tool
#change default editor system-wide
update-alternatives --config editor
#change sudo timeout:
visudo Defaults  !tty_tickets
#remove `gnome-screensaver`
apt-get remove gnome-screensaver
killall gnome-screensaver
#config smartmontools
/etc/smartd.conf: /dev/sda -d sat -n standby -a -o on -S on -r 194 -s (S/../.././11|L/../../6/12) -m naitree@naitree-machine -M test
#dconf-tools
nautilus address bar: org-gnome-nautilus-preferences-(always-use-location-entiry)
#compizconfig-settings-manager
disable "show desktop" in switcher: Ubuntu Unity Plugin-Switcher-Disable Show Desktop in the Switcher
#ctrl+alt+up/down/left/right:
settings-keyboard-shortcuts-windows-maximize window/restore window
ccms: window management-Grid-bindings
#firefox
about:config mousewheel.default.delta_multiplier_y 150
#gvim
`gtkrc-2.0` to fix white border
#crontab
DISPLAY=:0
XAUTHORITY=/home/naitree/.Xauthority
# m h  dom mon dow   command
`*/30 * * * * /usr/bin/notify-send 'take a break for your eyes'`
#virtualbox
copy ~/VirtualBox VMs
copy ~/.config/VirtualBox
#eclipse
add icon: copy to `~/.local/share/applications`
#tomcat
systemctl disable tomcat7.service
only required for eclipse:
  - sudo ln -s /var/lib/tomcat7/common common
  - sudo ln -s /var/lib/tomcat7/conf conf
  - sudo ln -s /var/log/tomcat7 log
  - sudo ln -s /var/lib/tomcat7/server server
  - sudo ln -s /var/lib/tomcat7/shared shared
  - sudo ln -s /etc/tomcat7/policy.d/03catalina.policy conf/catalina.policy
  - sudo mkdir webapps
  - sudo mkdir temp
  - optional: sudo chmod -R 777 /usr/share/tomcat7/conf
#disable service units
    - systemctl disable NetworkManager-wait-online.service
    - systemctl disable postgresql.service
    - systemctl disable ssh.service
    - systemctl disable vsftpd.service
#guake
sudo update-alternatives --config x-terminal-emulator 修改 ctrl-alt-t 触发的 terminal
guake preference
#startup applications
guake
ss-qt5
touchpad-indicator
moush.sh
