#!/usr/bin/env bash

clear
printf "*** RUN TEST ***\n\n"

# get pwd
printf "PWD = $PWD\n\n"

# change dir
#echo "Change current dir" && \
#cd /opt && \
#printf "PWD = $PWD\n\n"

# view list of files in current dir
printf "ls current dir:\n" && \
ls -la && \
echo

# test user is not root
if [ $(id -u) -eq 0 ]; then
  echo "CRITICAL ERROR: Script should not run as root user"
  exit 1
fi

# start installer
sleep 3
./setup.sh

# view list of files ~
printf "ls home:\n" && \
cd && \
ls -la && \
echo

# view list of files ~/.config
printf "ls ~/.config:\n" && \
cd $HOME/.config && \
ls -la && \
echo

printf "*** END TEST ***"
