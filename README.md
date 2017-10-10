# whatsapp-web

A simple shell script that runs WhatsApp Web and a tray icon.

I created this because I needed an alternative after the Whatsie project was abandoned.


## Dependencies
This project uses:

* chromium-browser - to run WhatsApp web
* [yad](http://manpages.ubuntu.com/manpages/xenial/man1/yad.1.html) - to create the tray icon
* Whatsie - icons
* xdotool - window operations (e.g. switch to WhatsApp when icon is clicked)


## Usage
* Make sure the script is on your path. I like to alias it as `whatsapp`.
* Copy icon to /usr/share/icons

  $ sudo xdg-icon-resource install --mode system --size 48 resources/icons/48.png whatsapp-default