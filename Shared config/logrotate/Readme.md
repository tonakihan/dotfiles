# logrotate
Нужно вручную через crontab настроить автозапуск
```crontab
@hourly mark logrotate -fs "$HOME/.cache/logrotate.status" "$HOME/.config/logrotate/eww.conf"
```
