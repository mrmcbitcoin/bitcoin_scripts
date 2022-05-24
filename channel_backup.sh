#!/bin/bash

LND_HOME=/var/lib/lnd
BACKUP_HOST=192.168.1.5
BACKUP_USER=
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME=${BACKUP_DATE}_channel.backup

scp $LND_HOME/.lnd/data/chain/bitcoin/mainnet/channel.backup $BACKUP_HOST:channel_states/$BACKUP_NAME
