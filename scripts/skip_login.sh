#!/bin/zsh

# TODO: test script

# Ask the user for a username
read "username?Enter the username to configure for autologin: "

override_dir="/etc/systemd/system/getty@tty1.service.d"
override_file="$override_dir/autologin.conf"
shell_profile="${HOME}/.zshrc"

# Create override directory for getty@tty1 service
sudo mkdir -p $override_dir

# Create override.conf for autologin # TODO: verify \$TERM works as intended, it should result in linux
sudo tee $override_file > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --noreset --noclear --autologin $username - \$TERM
Type=simple
EOF

# Reload systemd daemon
sudo systemctl daemon-reload

# Enable getty@tty1 service
sudo systemctl enable getty@tty1.service

echo "Auto login configured for user $username and Hyprland will start on tty1 login."
