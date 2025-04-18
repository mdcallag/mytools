
drop table if exists frag_temp;

create temporary table frag_temp as
SELECT
  ROUND(sum(m.num_rows) / (1000*1000), 1) as Mrows,
  ROUND(sum(m.data_size)/(1024*1024), 1) as sizeMB,
  ROUND(sum(m.entry_deletes) / (1000*1000), 2) as Mdels,
  ROUND(sum(m.entry_singledeletes) / (1000*1000), 2) as Msdels,
  sum(m.entry_merges) as merges,
  sum(m.entry_others) as others,
  ROUND(sum(m.distinct_keys_prefix) / (1000*1000), 1) as distkey,
  ROUND(sum(m.entry_deletes) / sum(m.num_rows) * 100, 2) as pctdel,
  ROUND(sum(m.entry_singledeletes) / sum(m.num_rows) * 100, 2) as pctsdel,
  ROUND(sum(m.entry_deletes + m.entry_singledeletes) / sum(m.num_rows) * 100, 2) as pctbdel,
  ROUND((sum(m.data_size) / (1024*1024))  * (sum(m.entry_deletes + m.entry_singledeletes) / sum(m.num_rows)), 1) as fragMB,
  d.table_schema as tschema,
  d.table_name as tname,
  m.index_number as idxnum
FROM
  INFORMATION_SCHEMA.ROCKSDB_INDEX_FILE_MAP m JOIN INFORMATION_SCHEMA.ROCKSDB_DDL d ON m.index_number = d.index_number
GROUP BY
  d.table_schema,
  d.table_name,
  m.index_number;

# alter table frag_temp add index x (tschema, tname, idxnum);

select "BY tschema, tname, idxnum";
select * from frag_temp ORDER BY tschema, tname, idxnum;

select "By pctdel";
select * from frag_temp ORDER BY pctdel desc;

select "By pctsdel";
select * from frag_temp ORDER BY pctsdel desc;

select "By pctbdel";
select * from frag_temp ORDER BY pctbdel desc;

select "By fragMB";
select * from frag_temp ORDER BY fragMB desc;

drop table frag_temp;
