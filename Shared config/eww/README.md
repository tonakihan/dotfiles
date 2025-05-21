# EWW
Перед запуском проверьте зависимости
```
  ./checkDependencies.sh
```
Запуск рекомендован с помощью launch.sh

## Env var
`EWW_CONFIG_ROOT` - Указывает на папку где находится launch.sh. Нужен для доступа к modules, utils  
`EWW_CONFIG_HOME` - Указывает на window. Нужен для utils/toggle. То же самое, что и `EWW_CONFIG_DIR` (но он не выходит за рамки eww).

## BUGS
modules/Bar/interact-time.yuck - постоянно спамит ошибками. Использую
logrotate&cron для ограничения размера `~/.cache/eww/eww_xxx.log` файла.
config for logrotate - `Shared Config/logrotate`
