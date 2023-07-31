#!/bin/bash
# install arch depencdencies
# created by : cosmo (modified by tkaming)

# variables
$username = "tobiask"

# black arch mirrors
curl -O https://blackarch.org/strap.sh
chmod +x strap.sh
sudo ./strap.sh
rm -rf strap.sh
sudo pacman -Syu

# brightness with "brillo"
cd /home/$username/.config/i3/scripts/brillo
make
sudo make install
sudo setfacl -m u:$username:rx /bin/brillo
sudo chown $username /sys/class/backlight/intel_backlight/brightness

# packages
sudo pacman -S xclip flatpak flameshot python3 python-pip git feh arandr acpi breeze npm lxappearance materia-gtk-theme eom net-tools mesa 

# flatpaks
flatpak install com.spotify.Client

# add flatpaks to dmenu
sudo ln -s /var/lib/flatpak/exports/bin/com.spotify.Client /usr/bin/spotify

sudo usermod -a -G libvirt $(whoami)
newgrp libvirt

# nested virtualization

### Intel Processor ###
sudo modprobe -r kvm_intel
sudo modprobe kvm_intel nested=1
echo "options kvm-intel nested=1" | sudo tee /etc/modprobe.d/kvm-intel.conf
systool -m kvm_intel -v | grep nested

# neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
pip3 install jedi