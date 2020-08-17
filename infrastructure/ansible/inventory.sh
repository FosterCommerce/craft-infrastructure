#!/bin/bash
set e;

# A utility script to allow setting webserver hosts from CI

GROUPED_WEBSERVER_HOSTS=""
IFS=',' read -ra HOSTS <<< "$WEBSERVER_HOSTS"
for HOST in "${HOSTS[@]}"
do
    GROUPED_WEBSERVER_HOSTS="$GROUPED_WEBSERVER_HOSTS,\"$HOST\""
done

cat << EOH
{
  "webservers": {
    "hosts": [${GROUPED_WEBSERVER_HOSTS:1}]
  }
}
EOH
