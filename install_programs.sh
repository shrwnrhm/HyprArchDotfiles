#!/bin/bash

# install_programs.sh

# Run this script after a base Arch install:
# pacstrap -K /mnt base linux linux-firmware networkmanager git

# Must be run with sudo.

set -e

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run with sudo or as root." 
   exit 1
fi

# Ask for CPU type
echo "Which CPU drivers do you want to install? (intel/amd)"
read cpu_type

# Check for invalid CPU option
if [[ "$cpu_type" != "intel" && "$cpu_type" != "amd" ]]; then
    echo "Unknown option. Please run the script again and choose 'intel' or 'amd'."
    exit 1
fi

# Ask for GPU type
echo "Which GPU drivers do you want to install? (intel/amd)"
read gpu_type

# Check for invalid GPU option
if [[ "$gpu_type" != "intel" && "$gpu_type" != "amd" ]]; then
    echo "Unknown option. Please run the script again and choose 'intel' or 'amd'."
    exit 1
fi

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing essential base packages..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    networkmanager network-manager-applet \
    wget \
    curl \
    unzip zip unrar file-roller \
    openssh \
    pipewire pipewire-pulse pavucontrol \
    xdg-user-dirs xdg-utils \
    thunar thunar-volman \
    gvfs gvfs-smb tumbler ffmpegthumbnailer \
    ntfs-3g \
    bluez bluez-utils blueman

echo "Installing CPU dependant programs"
if [[ "$cpu_type" == "intel" ]]; then
    echo "Installing Intel CPU microcode updates..."
    sudo pacman -S --needed intel-ucode
elif [[ "$cpu_type" == "amd" ]]; then
    echo "Installing AMD CPU microcode updates..."
    sudo pacman -S --needed amd-ucode
if

echo "Installing GPU dependant programs"
if [[ "$gpu_type" == "intel" ]]; then
    echo "Installing Intel Vulkan driver..."
    sudo pacman -S --needed vulkan-intel
elif [[ "$gpu_type" == "amd" ]]; then
    echo "Installing AMD Vulkan driver..."
    sudo pacman -S --needed vulkan-radeon
if

echo "Installing Hyprland ecosystem..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    hyprpaper \
    waybar \
    rofi-wayland \
    brightnessctl \
    hyprlock \
    dunst
    
echo "Installing terminal..."
sudo pacman -S --needed --noconfirm \
    zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting
    kitty \
	htop

echo "Installing editors..."
sudo pacman -S --needed --noconfirm \
    vim \
    geany \
    code

echo "Installing web browser and media apps..."
sudo pacman -S --needed --noconfirm \
    firefox \
    thunderbird \
    mpv

echo "Installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-dejavu \
    ttf-liberation \
    noto-fonts \
    noto-fonts-emoji \
    ttf-fira-code

echo "Installing yay (AUR helper)..."
if ! command -v yay &> /dev/null; then
    cd /opt
    git clone https://aur.archlinux.org/yay-bin.git
    chown -R $(logname):$(logname) yay-bin
    cd yay-bin
    sudo -u $(logname) makepkg -si --noconfirm
fi

echo "Enabling essential services..."
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable dunst

echo "Creating user directories..."
xdg-user-dirs-update

echo "Change Default Shell..."
sudo chsh -s /usr/bin/zsh

echo "All programs installed. You may now reboot and log into Hyprland!"
