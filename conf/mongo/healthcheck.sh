#!/bin/sh
set -e

mongosh --host localhost:27017 --quiet \
  --eval "
    const ping = db.runCommand({ ping: 1 });
    if (ping.ok !== 1) {
      print('Ping failed:', tojson(ping));
      quit(1);
    }
  "