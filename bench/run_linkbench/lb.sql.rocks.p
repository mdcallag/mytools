drop database if exists linkdb0;
create database linkdb0;
use linkdb0;

    CREATE TABLE `linktable` (
      `id1` bigint(20) unsigned NOT NULL DEFAULT '0',
      `id2` bigint(20) unsigned NOT NULL DEFAULT '0',
      `link_type` bigint(20) unsigned NOT NULL DEFAULT '0',
      `visibility` tinyint(3) NOT NULL DEFAULT '0',
      `data` varchar(255) NOT NULL DEFAULT '',
      `time` bigint(20) unsigned NOT NULL DEFAULT '0',
      `version` int(11) unsigned NOT NULL DEFAULT '0',
      PRIMARY KEY (link_type, `id1`,`id2`) COMMENT 'cf_link_pk',
      KEY `id1_type` (`id1`,`link_type`,`visibility`,`time`,`id2`,`version`,`data`) COMMENT 'rev:cf_link_id1_type'
    ) ENGINE=RocksDB DEFAULT COLLATE=latin1_bin
partition by key(id1) partitions 32;

    CREATE TABLE `counttable` (
      `id` bigint(20) unsigned NOT NULL DEFAULT '0',
      `link_type` bigint(20) unsigned NOT NULL DEFAULT '0',
      `count` bigint(20) unsigned NOT NULL DEFAULT '0',
      `time` bigint(20) unsigned NOT NULL DEFAULT '0',
      `version` bigint(20) unsigned NOT NULL DEFAULT '0',
      PRIMARY KEY (`id`,`link_type`) COMMENT 'cf_count_pk'
    ) ENGINE=RocksDB DEFAULT COLLATE=latin1_bin
partition by key(id) partitions 32;
    
    CREATE TABLE `nodetable` (
        `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
        `type` int(10) unsigned NOT NULL,
        `version` bigint(20) unsigned NOT NULL,
        `time` int(10) unsigned NOT NULL,
        `data` mediumtext NOT NULL,
        primary key(`id`) COMMENT 'cf_node_pk'
    ) ENGINE=RocksDB DEFAULT COLLATE=latin1_bin
partition by key(id) partitions 32;

