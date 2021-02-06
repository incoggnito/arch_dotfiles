#!/bin/sh -e

# Lock screen displaying this image.
i3lock -i ~/.config/i3/lock.png

# Turn the screen off after a delay.
sleep 60; pgrep i3lock && xset dpms force off
