# Hyprland
## Рекомендации
Для Arch Linux советую собирать из git, т.к. в официальном репозитории
встречаются плохие сборки.

## Install
``` bash
curl -L -o dotfiles.tar.gz https://github.com/tonakihan/dotfiles/archive/main.tar.gz
tar -xvzf dotfiles.tar.gz 
cd dotiles-main
./setup.sh
```
___
Optional 
``` bash
### Login Manager ###
sudo cp -ri etc/greetd /etc/
systemctl enable greetd.service
```
