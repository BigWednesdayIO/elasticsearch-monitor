#!/bin/bash

set -e

if [ -z ${GCLOUD_MONITORING_API_KEY} ]; then
  echo 'Required variable GCLOUD_MONITORING_API_KEY not set.';
  exit 1;
fi

# set stats url in configuration
perl -pi -e 's/\{\{(\w+)\}\}/$ENV{$1}/eg' /opt/stackdriver/collectd/etc/collectd.d/elasticsearch.conf

# pass api key
/opt/stackdriver/stack-config --api-key=${GCLOUD_MONITORING_API_KEY}

# use rsyslog for logging and keeping container alive
rsyslogd

/etc/init.d/stackdriver-agent start

tail -f /var/log/messages
