#! /bin/bash
#
# Author: Sven Festersen <sven@sven-festersen.de>
#
# Tests whether a host can be reached by pinging it once. Example:
#
#   check-online.sh <HOST>
#
# If the ping is successful, "1" is written to /tmp/online-hosts/<HOST>,
# "0" otherwise.
# This script is most useful if run periodically (e.g. by cron).
#
online_dir="/tmp/online-hosts";
addr="$1";
ping -c1 -W1 "$addr" >& /dev/null
ec=$?;
if [ $ec -eq 0 ]
then
    echo "Host '$addr' is online."
    mkdir -p "$online_dir"
    echo 1 > $online_dir/$addr
else
    echo "Host '$addr' is offline."
    mkdir -p "$online_dir"
    echo 0 > $online_dir/$addr
fi
