select "id1, link_type, id2 from linktable where id2 > 10000000 limit 20";
select id1, link_type, id2 from linktable where id2 > 10000000 limit 20;

select "round(id2 / 1000000) as M, count(*) as ct from linktable group by M order by M desc";
select round(id2 / 1000000) as M, count(*) as ct from linktable group by M order by M desc;

select "id, link_type, count from counttable where count >= 10000 order by count desc";
select id, link_type, count from counttable where count >= 10000 order by count desc;

select "round(count/1000) as K, count(*) as ct from counttable group by K order by K desc";
select round(count/1000) as K, count(*) as ct from counttable group by K order by K desc;

select "count, count(*) as ct from counttable where count < 10 group by count order by count desc";
select count, count(*) as ct from counttable where count < 10 group by count order by count desc;

select "count(*) from counttable";
select count(*) from counttable;

select "max(count) from counttable";
select max(count) from counttable;

select "id, count from counttable order by count desc limit 20";
select id, count from counttable order by count desc limit 20;

select "id, ltagg.lid, link_type, count, ltagg.lct as cct "
select id, ltagg.lid, link_type, count, ltagg.lct as cct from counttable ct left join (select id1 as lid, link_type as llt, count(*) as lct from linktable where visibility=1 group by id1, link_type) ltagg on ct.id = ltagg.lid and ct.link_type = ltagg.llt where ltagg.lct != count;

select "id, ltagg.lid, link_type, count, ltagg.lct as cct "
select id, ltagg.lid, link_type, count, ltagg.lct as cct from counttable ct right join (select id1 as lid, link_type as llt, count(*) as lct from linktable where visibility=1 group by id1, link_type) ltagg on ct.id = ltagg.lid and ct.link_type = ltagg.llt where ltagg.lct != count;
