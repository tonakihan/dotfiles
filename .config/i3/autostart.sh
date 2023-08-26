#!/bin/bash

udiskie -aN &disown
corectrl &disown
dunst &disown

# Для того, чтобы не уходил в спячку экран
xset s off; xset dpms 0 0 0 

