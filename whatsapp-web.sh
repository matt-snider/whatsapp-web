#!/bin/bash

# Create a FIFO file to manage the I/O redirection from shell
# Attach a file descriptor to the file
PIPE=$(mktemp -u --tmpdir ${0##*/}.XXXXXXXX)
mkfifo $PIPE
exec 3<> $PIPE

# Close yad on process shutdown
function on_exit() {
    echo "quit" >&3
    rm -f $PIPE
}
trap on_exit EXIT


# Add click handler for tray icon
function on_click() {
    echo "clicked"
}
export -f on_click


# Create tray icon
yad --notification                   \
    --listen                         \
    --no-middle	                     \
    --image="gtk-help"               \
    --text="WhatsApp"                \
    --command="bash -c on_click" <&3 &


# Run WhatsApp as a chromium app and get its pid
chromium-browser \
	--app="https://web.whatsapp.com/" \
	--profile-directory="Default"
chromium_pid=$(pgrep -n chromium)


# Wait for chrome to exit
while [ -e /proc/$chromium_pid ]
do 
	echo "whatsapp: chromium ($chromium_pid) is still running" 
	sleep 1
done
echo "whatsapp: chromium ($chromium_pid) has exited"

