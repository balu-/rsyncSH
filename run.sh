#!/bin/sh
######## Config #########
REMOTE="qope.de" 					# Rechner auf den gesichert wird
REMOTEUSER="backup-mailman" 	# User, auf den via ssh ohne Passwort zugegriffen wird
TARGET="/media/data/backup/mailman/backup"   # Verzeichnis, wohin das Backup geschoben wird
SUBJECT="Backup_fehlgeschlagen!"    # im Subject kein Leerzeichen!
INCLUDE="/root/backup/backup.include"    # Dateien, von denen ein Backup gemacht wird
EXCLUDE="/root/backup/backup.exclude"    # Dateien, von denen kein Backup gemacht wird

RSYNC='/usr/bin/rsync'
RSYNC_OPTIONS="-rv --compress --numeric-ids --owner --group --times --perms --links --delete-after --ignore-errors -e 'ssh -i /root/.ssh/id_rsa -p 222  -o \"CheckHostIP no\"' --rsync-path='/usr/local/bin/sudo /usr/local/bin/rsync'"
##### ende Config #####


eval "$RSYNC $RSYNC_OPTIONS $SOURCE $REMOTEUSER\\@$REMOTE\\:$TARGET --files-from=$INCLUDE --exclude-from=$EXCLUDE"
