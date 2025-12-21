#!/bin/bash
set -e

echo "mongo-replica-setup.sh starting"
mongosh --host mongo01:27017 <<EOF
  var cfg = {
    "_id": "rs0",
    "version": 1,
    members: [
        {
            "_id": 0,
            "host": "mongo01:27017",
            "priority": 3
        }
    ]
  };
  rs.initiate(cfg);
EOF