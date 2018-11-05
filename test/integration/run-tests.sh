#!/bin/bash

function cleanup()
{
    echo "Caught Signal ... cleaning up."
    # kill influx
    kill -9 "$INFLUXPID"
    echo "Done cleanup ... quitting."
    if [ "$1" -gt "0" ]; then
        echo "Error experienced on line $(caller)"
    fi
    exit $1
}
trap "cleanup 1" ERR

# spin up influx and wait for http interface to be ready
cat << EOF > /influx/influx.conf
[meta]
  dir = "/var/lib/influxdb/meta"

[data]
  dir = "/var/lib/influxdb/data"
  wal-dir = "/var/lib/influxdb/wal"

[http]
  # Determines whether user authentication is enabled over HTTP/HTTPS.
  bind-address = ":8086"
  auth-enabled = true
EOF

./influx/influxd &> /influxd.log & 
INFLUXPID=$!

{ tail -f -n +1 /influxd.log & echo $! > wpid ; } | { grep -q "Sending usage statistics" && kill -9 $(cat wpid) && rm wpid ; }

echo "Influx is now running as PID $INFLUXPID, moving on..."

#bash
#
## run our tests
#./influx/influx -execute "CREATE USER admin WITH PASSWORD 'dummy' WITH ALL PRIVILEGES"
#
#asdf
#
#./influx/influx -execute "CREATE DATABASE ShouldFail"
#
#./app
#
#cleanup 0