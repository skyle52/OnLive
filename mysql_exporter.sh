#! /bin/sh

cat <<EOF >/etc/.mysqld_exporter.cnf
[client]
user=monitor
password=Vietnam@123
EOF

chown node_exporter:node_exporter /etc/.mysqld_exporter.cnf

wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.1/mysqld_exporter-0.15.1.linux-amd64.tar.gz

tar -xvf mysqld_exporter-0.15.1.linux-amd64.tar.gz
cp mysqld_exporter-0.15.1.linux-amd64/mysqld_exporter /usr/local/bin
chown node_exporter:node_exporter /usr/local/bin/mysqld_exporter
cat <<EOF >/etc/systemd/system/mysqld_exporter.service 
[Unit]
Description=Prometheus MySQL Exporter
After=network.target
User=node_exporter
Group=node_exporter

[Service]
Type=simple
Restart=always
ExecStart=/usr/local/bin/mysqld_exporter \
--config.my-cnf /etc/.mysqld_exporter.cnf \
--collect.global_status \
--collect.info_schema.innodb_metrics \
--collect.auto_increment.columns \
--collect.info_schema.processlist \
--collect.binlog_size \
--collect.info_schema.tablestats \
--collect.global_variables \
--collect.info_schema.query_response_time \
--collect.info_schema.userstats \
--collect.info_schema.tables \
--collect.perf_schema.tablelocks \
--collect.perf_schema.file_events \
--collect.perf_schema.eventswaits \
--collect.perf_schema.indexiowaits \
--collect.perf_schema.tableiowaits \
--collect.slave_status \
--web.listen-address=0.0.0.0:9104

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl start mysqld_exporter
systemctl enable mysqld_exporter

#firewall-cmd --zone=public --add-port=9100/tcp --permanent
#firewall-cmd --reload

ufw allow 9104
