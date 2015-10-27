FROM debian:jessie

RUN apt-get update && \
  apt-get install -y curl libyajl2 curl rsyslog && \
  curl -o /etc/apt/sources.list.d/stackdriver.list https://repo.stackdriver.com/jessie.list && \
  curl --silent https://app.google.stackdriver.com/RPM-GPG-KEY-stackdriver | apt-key add - && \
  apt-get update && \
  echo "stackdriver-agent stackdriver-agent/apikey string PLACEHOLDER_API_KEY" | debconf-set-selections && \
  apt-get install stackdriver-agent -y

ADD elasticsearch.conf /opt/stackdriver/collectd/etc/collectd.d/elasticsearch.conf
ADD start_agent.sh /usr/local/bin/start_agent.sh

RUN chmod +x /usr/local/bin/start_agent.sh

CMD "/usr/local/bin/start_agent.sh"
