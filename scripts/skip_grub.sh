#!/bin/zsh

# Change GRUB_TIMEOUT and GRUB_TIMEOUT_STYLE values
sudo sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/' /etc/default/grub
sudo sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=hidden/' /etc/default/grub

# Regenerate GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "GRUB configuration updated: timeout set to 0 and style to hidden."
