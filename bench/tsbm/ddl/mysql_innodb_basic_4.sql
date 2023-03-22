
drop database if exists tsbm;
create database tsbm;
use tsbm;

create table t1 (
  timestamp     bigint unsigned not null,
  deviceID      bigint unsigned not null,
  metricID      int    unsigned not null,
  metricValue   bigint unsigned not null,
  PRIMARY KEY(deviceID, timestamp, metricID)
) engine=innodb;

create table t2 (
  timestamp     bigint unsigned not null,
  deviceID      bigint unsigned not null,
  metricID      int    unsigned not null,
  metricValue   bigint unsigned not null,
  PRIMARY KEY(deviceID, timestamp, metricID)
) engine=innodb;

create table t3 (
  timestamp     bigint unsigned not null,
  deviceID      bigint unsigned not null,
  metricID      int    unsigned not null,
  metricValue   bigint unsigned not null,
  PRIMARY KEY(deviceID, timestamp, metricID)
) engine=innodb;

create table t4 (
  timestamp     bigint unsigned not null,
  deviceID      bigint unsigned not null,
  metricID      int    unsigned not null,
  metricValue   bigint unsigned not null,
  PRIMARY KEY(deviceID, timestamp, metricID)
) engine=innodb;
