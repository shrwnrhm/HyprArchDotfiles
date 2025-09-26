#!/bin/bash

# TODO: replace/check/improve this code

# Define your dotfiles directory
DOTFILES="$HOME/dotfiles"

# Example configs to link: (adjust as needed)
declare -A configs=(
    ["$HOME/.config/hypr/hyprland.conf"]="$DOTFILES/hyprland/.config/hypr/hyprland.conf"
    # Add other configs here in ["link_path"]="target_path" format
)

for link in "${!configs[@]}"; do
    target="${configs[$link]}"
    
    # Remove existing symlink or file if present
    if [ -L "$link" ] || [ -e "$link" ]; then
        echo "Removing existing $link"
        rm -rf "$link"
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$link")"
    
    # Create the symlink
    ln -s "$target" "$link"

    echo "Symlink created: $link -> $target"
done
