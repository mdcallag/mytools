
drop table if exists t0;

create table t0 (
  timestamp     bigint not null,
  deviceID      bigint not null,
  metricID      int    not null,
  metricValue   bigint not null,
  PRIMARY KEY(timestamp, deviceID, metricID)
); 

