# bitcoin_scripts

## Channel Backup

Backup your lightning channels to a remote server. Run it out of cron.

crontab -e 

```# backup the channels
#min, hour, day, month, day of week
*/5 * * * *    bash ~/bin/channel_backup.sh
```

## fee_checker
Checks for unbalanced channels that should have a higher fee set so they won't be used.


Run it with a working lncli and it will exit 0 normally, or print a message and exit 1. This would be good to run as a cron job or maybe a Nagios script.


## short2longchan.py

usage short2longchan.py SHORT_CHAN_ID
