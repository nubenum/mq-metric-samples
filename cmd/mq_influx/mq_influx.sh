#!/bin/sh

# This is used to start the IBM MQ monitoring service for InfluxDB

# The queue manager name comes in from the service definition as the
# only command line parameter
qMgr=$1

# Set the environment to ensure we pick up libmqm.so etc
# If this is a client connection, then deal with no known qmgr of the given name.
. /opt/mqm/bin/setmqenv -m $qMgr -k >/dev/null 2>&1
if [ $? -ne 0 ]
then
  . /opt/mqm/bin/setmqenv -s -k
fi

# A list of queues to be monitored is given here.
# It is a set of names or patterns ('*' only at the end, to match how MQ works),
# separated by commas. When no queues match a pattern, it is reported but
# is not fatal.
queues="APP.*,MYQ.*"

# An alternative is to have a file containing the patterns, and named
# via the ibmmq.monitoredQueuesFile option.

# And other parameters that may be needed
# See config.go for all recognised flags
database="MQDB"
userid="admin"
password="admin" # Probably get from an environment variable in reality
passwordFile="/tmp/mqinfluxpw.$$.txt"
svr="http://klein.hursley.uk.ibm.com:8086"
interval="10s"

ARGS="-ibmmq.queueManager=$qMgr"
ARGS="$ARGS -ibmmq.databaseName=$database"
ARGS="$ARGS -ibmmq.databaseAddress=$svr"
ARGS="$ARGS -ibmmq.databaseUserID=$userid"
ARGS="$ARGS -ibmmq.interval=$interval"
ARGS="$ARGS -ibmmq.monitoredQueues=$queues"
ARGS="$ARGS -ibmmq.monitoredChannels=*"
ARGS="$ARGS -ibmmq.pwFile=$passwordFile"
ARGS="$ARGS -ibmmq.useStatus=true"
ARGS="$ARGS -log.level=error"

# Start via "exec" so the pid remains the same. The queue manager can
# then check the existence of the service and use the MQ_SERVER_PID value
# to kill it on shutdown.
# Using exec makes it harder to use stdin redirect, hence the use of
# a file to hold a password.  The program will delete the file immediately
# after reading it.

rm -f $passwordFile
umask 077
echo $password > $passwordFile
exec /usr/local/bin/mqgo/mq_influx  $ARGS
