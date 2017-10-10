#!/bin/bash

# Looks for the active window
function find_window() {
    xdotool search --classname  "web.whatsapp.com"
}
export -f find_window;


# Switches to WhatsApp window
function activate() {
    xdotool windowactivate `find_window`;
}
export -f activate;


# Closes window
function close() {
    xdotool windowkill `find_window`;
}
export -f close;


# Check if exists, if so, activate and exit
if [[ $(find_window) ]]; then
    activate
    exit 0;
fi


# Create a FIFO file to manage the I/O redirection from shell
# Attach a file descriptor to the file
PIPE=$(mktemp -u --tmpdir ${0##*/}.XXXXXXXX)
mkfifo $PIPE
exec 3<> $PIPE


# Closes yad on process shutdown
function on_exit() {
    echo "quit" >&3
    rm -f $PIPE
    close
}
trap on_exit EXIT


# Handles click on tray icon
function on_click() {
    activate;
}
export -f on_click


# Create tray icon
yad --notification                   \
    --listen                         \
    --no-middle	                     \
    --image="whatsapp"               \
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
on_exit
