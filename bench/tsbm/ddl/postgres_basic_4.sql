
drop table if exists t1;
create table t1 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(deviceID, timestamp, metricID)
); 

drop table if exists t2;
create table t2 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(deviceID, timestamp, metricID)
); 

drop table if exists t3;
create table t3 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(deviceID, timestamp, metricID)
); 

drop table if exists t4;
create table t4 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(deviceID, timestamp, metricID)
); 
