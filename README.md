# bitcoin_scripts

## Channel Backup

Backup your lightning channels to a remote server. Run it out of cron.

crontab -e 

```# backup the channels
#min, hour, day, month, day of week
*/5 * * * *    bash ~/bin/channel_backup.sh
```

## fee_printer
Prints useful information about fees set on our side

Output (header added for documentation):
~~~
Node Public Key							   Node Alias			
0217890e3aad8d35bc054f43acc00084b25229ecff0ab68debd82883ad65ee8266 "1ML.com node ALPHA"    	MinHTLC:1000		FeeBase:1000		FeeRate:1		Disabled:false	813832510099346259
~~~

## fee_checker
This doesn't work well yet
Checks for unbalanced channels that should have a higher fee set so they won't be used.


Run it with a working lncli and it will exit 0 normally, or print a message and exit 1. This would be good to run as a cron job or maybe a Nagios script.


## short2longchan.py

usage short2longchan.py SHORT_CHAN_ID
