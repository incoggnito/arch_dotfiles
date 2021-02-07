#!/bin/sh

xrdb ~/.Xresources

xbindkeys

xset r rate 220 38

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

numlockx &

exec dbus-launch i3
