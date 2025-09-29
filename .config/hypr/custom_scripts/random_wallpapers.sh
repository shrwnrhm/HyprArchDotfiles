#!/bin/bash
check_lock() {
	lockfile="/tmp/$(basename "$0").lock"

	# Check if lock exists and if the process is still running
	if [ -f "$lockfile" ] && ps -p $(cat "$lockfile") > /dev/null 2>&1; then
		echo "Script is already running."
		exit 1
	fi

	# Write current PID to lockfile
	echo $$ > "$lockfile"

	# Ensure lockfile is removed on script exit or interruption
	trap 'rm -f "$lockfile"' EXIT	
} 
check_lock



# directory for every other workspace not defined
dir="~/Pictures/wallpapers/Universe Sunflare"

# Path to store the last change time
last_time_file="$HOME/.cache/custom_scipts/last_wallpaper_change"
mkdir -p "$(dirname "$last_time_file")"



# exit if time difference is less then input (floating point in seconds)
# echoes current time
check_time() {
	# Get current epoch time
	current_time=$(date +%s.%N)

	# Read last execution time from file, if it exists
	if [ -f "$last_time_file" ]; then
		last_time=$(cat "$last_time_file")
	else
		last_time=0
	fi
	
	# Calculate time difference
	time_diff=$(echo "$current_time - $last_time" | bc)

	# If less than 1 second has passed, exit
	if (( $(echo "$time_diff < $1" | bc -l) )); then
		exit 0
	fi
	
    echo "$current_time"
}



# Get the current workspace name
#wsname=$(hyprctl activeworkspace -j | jq -r .name)
#wsname=$1
#notify-send -t 3000 "wsname" "$wsname" #tmp

# Send notification for debugging
#notify-send -t 3000 "Workspace switched" "workspace: $wsname" #tmp

# Check if directory value (passed as the second argument) exists for this workspace name
if [[ "$2"+_} ]]; then
	dir="$2"
fi

# Expand tilde in directory path
expand_path() {
    eval echo "$1"
}
dir=$(expand_path "$dir")

# Check if directory exists
if [ -d "$dir" ]; then

    # Get a random wallpaper from the directory
    wallpaperRandom=$(find "$dir" -type f | shuf -n 1)

	# Save the current time for next execution and check time again
	current_time=$(check_time 0.5)
	echo "$current_time" > "$last_time_file"

    # Change the wallpaper
    hyprctl hyprpaper reload ,"$wallpaperRandom"
    
    # With Pywal, generate a color pallete of the wallpaper and save it in ~/.cache/wal/
    wal -i "$wallpaperRandom"
    
    # Update the Firefox theme with pywalfox
    pywalfox update
    
    # Execute the workspace change command passed as the first argument
	$1
fi
