{%- if grains['os_family'] == 'Debian' %}
logstash-repo-key:
  cmd.run:
    - name: wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
    - unless: apt-key list | grep 'Elasticsearch (Elasticsearch Artifacts Signing Key)'

logstash-repo:
  pkgrepo.managed:
    - humanname: Logstash Debian Repository
    - name: deb https://artifacts.elastic.co/packages/6.x/apt stable main
    - require:
      - cmd: logstash-repo-key
{%- elif grains['os_family'] == 'RedHat' %}
logstash-repo-key:
  cmd.run:
    - name:  rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - unless: rpm -qi gpg-pubkey-d88e42b4-52371eca

logstash-repo:
  pkgrepo.managed:
    - humanname: logstash repository for 6.x packages
    - baseurl: https://artifacts.elastic.co/packages/6.x/yum
    - gpgcheck: 1
    - gpgkey: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - enabled: 1
    - require:
      - cmd: logstash-repo-key
{%- endif %}