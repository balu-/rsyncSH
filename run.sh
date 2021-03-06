#!/bin/bash

#get path for config files
LOCAL_PATH=`dirname ${0}`
LOCAL_PATH="${LOCAL_PATH}/"

# call echo $OUTPUT_DEBUG_LEVEL $OUTPUT
function print
{
    if [ $DEBUG -ge $1 ]
    then
        echo $2
    fi
}

######## get Config #########
# 0 - no output
# 1 - error
# 2 - info
# 3 - debug
DEBUG=3

DEFAULT_CONF_FILE="${LOCAL_PATH}conf.conf"
LOCAL_CONF_FILE="${LOCAL_PATH}conf.local"

if [ -f $DEFAULT_CONF_FILE ]
then
        source "$DEFAULT_CONF_FILE"
else
        print 1 "The default configfile ($DEFAULT_CONF_FILE) is missing"
        exit -1
fi

if [ -f $LOCAL_CONF_FILE ]
then
        source "$LOCAL_CONF_FILE"
else
        print 2 "The default configfile ($LOCAL_CONF_FILE) is missing"
        exit -1
fi

BACKUP_INCLUDE_FILE="${LOCAL_PATH}${INCLUDE}"
BACKUP_EXCLUDE_FILE="${LOCAL_PATH}${EXCLUDE}"

if [ ! -f $BACKUP_INCLUDE_FILE ]
then 
    touch $BACKUP_INCLUDE_FILE
fi

if [ ! -f $BACKUP_EXCLUDE_FILE ]
then 
    touch $BACKUP_EXCLUDE_FILE
fi

##### ende Config #####

while [[ $PING_COUNT -ne 0 ]] ; do
    ${PING} ${REMOTE} > /dev/null                      # Try once.
    RC=$?
    if [ $RC -eq 0 ]
    then
        PING_COUNT=1                          # If okay, flag to exit loop.
    fi
    PING_COUNT=$PING_COUNT-1                  # So we don't go forever.
done

if [ $RC -eq 1 ] ; then                  # Make final determination.
    print 1 "Could not reach $REMOTE."
    exit -2
else
    print 3 "Ping $REMOTE successful"
fi


print 3 "$RSYNC $RSYNC_OPTIONS $SOURCE $REMOTEUSER\\@$REMOTE\\:$TARGET --files-from=$BACKUP_INCLUDE_FILE --exclude-from=$BACKUP_EXCLUDE_FILE"

eval "$RSYNC $RSYNC_OPTIONS $SOURCE $REMOTEUSER\\@$REMOTE\\:$TARGET --files-from=$BACKUP_INCLUDE_FILE --exclude-from=$BACKUP_EXCLUDE_FILE"
