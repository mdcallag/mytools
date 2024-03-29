
drop table if exists t0;
create table t0 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(timestamp, deviceID, metricID)
); 

drop table if exists t1;
create table t1 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(timestamp, deviceID, metricID)
); 

drop table if exists t2;
create table t2 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(timestamp, deviceID, metricID)
); 

drop table if exists t3;
create table t3 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(timestamp, deviceID, metricID)
); 
