
drop database if exists tsbm;
create database tsbm;
use tsbm;

create table t0 (
  timestamp     bigint unsigned not null,
  deviceID      bigint unsigned not null,
  metricID      int    unsigned not null,
  metricValue   bigint unsigned not null,
  PRIMARY KEY(timestamp, deviceID, metricID)
) engine=innodb;

create table t1 (
  timestamp     bigint unsigned not null,
  deviceID      bigint unsigned not null,
  metricID      int    unsigned not null,
  metricValue   bigint unsigned not null,
  PRIMARY KEY(timestamp, deviceID, metricID)
) engine=innodb;

create table t2 (
  timestamp     bigint unsigned not null,
  deviceID      bigint unsigned not null,
  metricID      int    unsigned not null,
  metricValue   bigint unsigned not null,
  PRIMARY KEY(timestamp, deviceID, metricID)
) engine=innodb;
