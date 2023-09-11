# Hyprland

## Install
Dependencies
    - waybar
    - wlogout
    - hyprpaper 
    - corectrl (optional)
    - wofi
    - grim
    - slurp
    - alacritty
    - swaylock
    - tuigreet (optional)
    - greetd (optional)

``` bash
curl -L -o dotfiles.tar.gz https://github.com/tonakihan/dotfiles/archive/main.tar.gz
tar -xvzf dotfiles.tar.gz 
cd dotiles-main

cp -ri .config $HOME/
```

Optional 
``` bash
### Login Manager ###
sudo cp -ri etc/greetd /etc/
systemctl enable greetd.service
```
