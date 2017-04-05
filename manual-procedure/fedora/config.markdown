#注意顺序是有意义的!
- mouse speed:
    xinput --set-prop 'pointer:Lenovo Multi-function Mouse M300' 'libinput Accel Speed' -0.8
- yum-plugin-fastestmirror
- dnf update
- config grub
    #disable visible menu countdown
    GRUB_TIMEOUT=0
    #disable invisible countdown
    GRUB_HIDDEN_TIMEOUT=0
    GRUB_HIDDEN_TIMEOUT_QUIET=true
    GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
    GRUB_DEFAULT=saved
    GRUB_DISABLE_SUBMENU=true
    GRUB_TERMINAL_OUTPUT="console"
    #GRUB_CMDLINE_LINUX="rd.lvm.lv=fedora/swap rd.lvm.lv=fedora/root rhgb quiet"
    #disable fedora logo
    GRUB_CMDLINE_LINUX="rd.lvm.lv=fedora/swap rd.lvm.lv=fedora/root quiet"
    GRUB_DISABLE_RECOVERY="true"

    grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
- reboot
- dnf copr enable librehat/shadowsocks
- dnf install shadowsocks-qt5
    载入 gui-config.json
    autostart hk02 on system startup
- 配置所有系统配置
    online account -- google
    Privacy -- Purge temporary files
    search
        weather on
        add Dropbox
    regions and language
        formats -- english hong kong
    keyboard
        custom shortcut -- gnome-terminal -- Super+T
        windows -- close window -- super+K
    Power
        dim screen when inactive -- off
    Details
        device name
    Users
        photo
- firefox
    帐号同步
    foxyproxy 导入配置
    theme black
- rpmfusion free/nonfree
- 字体
    复制 .fonts 字体文件夹
    gnome-tweak-tool -- font
        window title -- ubuntu bold
        interface -- ubuntu regular
        document -- sans regular
        monospace -- ubuntu mono regular
    infinality -- rpm -Uvh http://www.infinality.net/fedora/linux/infinality-repo-1.0-1.noarch.rpm
        修改 /etc/yum.repos.d/infinality.repo 两个 url 为
            20/x86_64
            20/noarch
    dnf install freetype-infinality fontconfig-infinality
    cd /etc/fonts/infinality/styles.conf.avail
    mkdir fedora
    cp linux/* fedora
    cd fedora
    修改个文件如本目录下所示

    cd /etc/fonts/infinality
    sudo ./infctl.sh setstyle
    reboot

    设置 terminal 字体为 ubuntu mono
- gnome-terminal disable `show menu bar in new terminal`
- gnome-terminal -- profile -- disable `terminal bell`
- gnome-tweak-tool
    typing -- caps lock key behavior
    desktop -- icons on desktop
- nautilus
    list view
    list columns -- size, type, modified, owner, group, permissions, mime type
- dconf-editor
    nautilus address bar: org-gnome-nautilus-preferences-(always-use-location-entiry)
- 可以先尝试一下 ibus 是否较好地支持 gvim?
- remove ibus
- fcitx fcitx-configtool
- fcitx-rime librime (install/build `fcitx-rime` manually if not available in repo)
- 复制 rime 配置文件
- 配置 fcitx 各种配置, 以后可以复制配置文件
- 如果不行, 安装 im-chooser, imsettings, imsettings-gsettings, 重启后通过 im-chooser 选择 fcitx
- xsel
- vim, gvim
- gcc-c++
- youcompleteme
    git pull --recurse-submodules
    git submodule update --recursive
    编译:
        下载 llvm-clang binary
        解压至 ~/ycm_temp
        在 ~/ycm_build 下执行 `cmake -G "Unix Makefiles" -DPATH_TO_LLVM_ROOT=~/ycm_temp/llvm_root_dir . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp`
        在 ~/ycm_build 下执行 `make ycm_support_libs`
- nautilus-open-terminal
- 复制 bashrc
- proxychains-ng
    修改 /etc/proxychains.conf 末尾修改为 `socks5 127.0.0.1 1080`
- dropbox
    download rpm from official site
    复制 Dropbox dir
    ctrl+d bookmark dropbox folder
    从 /usr/bin/dropbox 代码中找到下载链接 (https://www.dropbox.com/download?plat=lnx.x86_64) 手动下载 daemon
    解压至 ~
    使用 ~/start_dropbox.sh 执行
    添加本目录文件至 ~/.config/autostart
    uncheck start on startup
- screen
- ctags
- cscope
- unrar
- postgresql
- mongodb-org (from official repo, see mongodb website)
- pgadmin3
- kernel-devel
- dkms
- oracle 官方下载 rpm 和 extension
    安装 virtualbox package
    编译 vboxdrv kernel module
        /etc/init.d/vboxdrv setup
    关闭 bios secure boot
- cmake
- python-devel
- libxml2-devel
- zlib-devel
- libxslt-devel
- python3-devel
- python3-virtualenv
- python-ipython
- python3-ipython python3-ipython-qtconsole python3-ipython-notebook
- vsftpd
- gparted
- libcurl-devel
- expect
- dark theme 使 title bar 成为深色 -- gnome tweak tool
- desktop icon size -- nautilus -- views -- icon view defaults -- zoom level -- small
- okular
    复制配置文件 ~/.kde
- texlive-scheme-full
    复制 ~/texmf
- dnf update
- sudo timeout across ttys
    visudo Defaults  !tty_tickets
- disable root SSH login
    /etc/ssh/sshd_config
    PermitRootLogin no
- startup applications -- gnome tweak tool
    shadowsocks-qt5
- nautilus icon
    gnome tweak tool -- appearance -- icon theme --breeze
?- tune boot time
- smartmontools
    /dev/sda -a -o on -S on -r 7 -r 194 -s (S/../.././11|L/../../6/12) -m naitree@workstation.localdomain -M exec /usr/libexec/smartmontools/smartdnotify -n standby,10,q
- mailx
- postfix
    sudo systemctl enable postfix.service
    sudo systemctl restart postfix.service
- wxPython
- gstreamer1 gstreamer1-plugins-good gstreamer1-plugins-bad-freeworld gstreamer1-plugins-ugly gstreamer1-libav (various codecs)
- sshpass
- dnf remove bijiben
- LUKS on LVM configuration: ##NOTE## THIS PROCEDURE may be PARTIALLY INCORRECT, it's here only for reference.
    1. shrink existing logical volume:
        reboot to rescue mode
        e2fsck -f /dev/mapper/home
        resize2fs /dev/mapper/home 450G
        lvreduce -L 470G /dev/mapper/home
        resize2fs /dev/mapper/home
        reboot to default mode
    2. create logical volume on free space
        lvcreate -l 100%FREE -n secrecy fedora
    3. create LUKS on logical volume
        cryptsetup open --type plain /dev/fedora/secrecy container --key-file /dev/urandom
        dd if=/dev/zero of=/dev/mapper/container
        cryptsetup close container
        cryptsetup luksFormat -c aes-xts-plain64 -s 512 /dev/fedora/secrecy
        cryptsetup open --type luks /dev/fedora/secrecy secrecy
        mkfs -t ext4 /dev/mapper/secrecy
        tune2fs -m 0 /dev/mapper/secrecy
    4. mount on boot
        /etc/crypttab:
        secrecy /dev/fedora/secrecy -
        /etc/fstab:
        /dev/mapper/secrecy /home/naitree/Desktop/secrecy ext4 defaults 0 2

- suspend even when external display is connected
- install thunderbird, remove evolution
