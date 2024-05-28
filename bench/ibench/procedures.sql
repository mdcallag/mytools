create or replace procedure update_stats_snapshot() as $$
DECLARE
    temp_table_name text;
    ts timestamp;
BEGIN
    -- Get the current time
	SELECT current_timestamp INTO ts;
    
    -- Create a unique temporary table name using the current timestamp
    temp_table_name := 'pg_stat_snapshot_' || to_char(ts, 'YYYYMMDD_HH24MISS_US');
    
    -- Create the temporary table
    EXECUTE 'CREATE TEMPORARY TABLE ' || temp_table_name || ' AS SELECT userid, dbid, queryid, calls, total_exec_time FROM pg_stat_statements';
    
    -- raise notice 'will create temp table';
    -- Create the activity table if it doesn't exist
    CREATE temporary TABLE IF NOT EXISTS activity (ts timestamp, temp_table text);

    -- raise notice 'will insert to temp table %', current_time;
    -- Insert the name of the temporary table into the activity table
    INSERT INTO activity (ts, temp_table)
    VALUES (ts, temp_table_name);
    
    -- Optionally, you can print the table name and current time for verification
    RAISE NOTICE 'Temporary table created: %, Timestamp: %', temp_table_name, current_time;
end;
$$ language plpgsql

CREATE OR REPLACE FUNCTION compare_latest_snapshots() 
RETURNS TABLE (
    total_queries numeric,
    total_latency numeric,
    avg_latency_per_query numeric,
    transactions_per_second numeric
) AS $$
DECLARE
    latest_snapshot text;
    previous_snapshot text;
    snapshot_tables text[];
    snapshot_timestamps timestamp[];
    latest_timestamp timestamp;
    previous_timestamp timestamp;
    time_interval numeric;
BEGIN
    -- Retrieve the names of the latest two snapshot tables
    SELECT array_agg(temp_table), array_agg(ts) INTO snapshot_tables, snapshot_timestamps
    FROM (
        SELECT temp_table, ts
        FROM activity
        ORDER BY ts DESC
        LIMIT 2
    ) sub;
    
    -- Assign the latest and previous snapshot table names and timestamps
    latest_snapshot := snapshot_tables[1];
    previous_snapshot := snapshot_tables[2];
    latest_timestamp := snapshot_timestamps[1];
    previous_timestamp := snapshot_timestamps[2];

    -- Compute the time interval in seconds
    time_interval := EXTRACT(EPOCH FROM (latest_timestamp - previous_timestamp));

    -- Compute the latencies
    IF latest_snapshot IS NOT NULL AND previous_snapshot IS NOT NULL THEN
        RETURN QUERY EXECUTE format('
            WITH filtered_statements AS (
                SELECT 
                    l.queryid,
                    l.calls AS latest_calls,
                    l.total_exec_time AS latest_total_exec_time,
                    p.calls AS previous_calls,
                    p.total_exec_time AS previous_total_exec_time
                FROM 
                    %I l
                JOIN 
                    %I p ON l.queryid = p.queryid
            )
            SELECT 
                SUM(latest_calls) - SUM(previous_calls) AS total_queries,
                (SUM(latest_total_exec_time) - SUM(previous_total_exec_time))::numeric AS total_latency,
                ((SUM(latest_total_exec_time) - SUM(previous_total_exec_time)) / NULLIF((SUM(latest_calls) - SUM(previous_calls)), 0))::numeric AS avg_latency_per_query,
                ((SUM(latest_calls) - SUM(previous_calls)) / %L)::numeric AS transactions_per_second
            FROM 
                filtered_statements;', latest_snapshot, previous_snapshot, time_interval);
    ELSE
        RETURN QUERY SELECT NULL::integer, NULL::numeric, NULL::numeric, NULL::numeric;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE drop_old_activity_tables() AS $$
DECLARE
    table_to_drop text;
BEGIN
    -- Loop through all but the last two entries in the activity table
    FOR table_to_drop IN
        SELECT temp_table
        FROM activity
        ORDER BY ts DESC
        OFFSET 2
    LOOP
        -- Drop the table
        EXECUTE 'DROP TABLE IF EXISTS ' || table_to_drop;
        
        -- Remove the entry from the activity table
        DELETE FROM activity WHERE temp_table = table_to_drop;
        commit;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION active_vacuum_ct()
RETURNS integer AS $$
DECLARE
    vacuum_count integer;
BEGIN
    -- Query to count the number of running VACUUM jobs
    SELECT COUNT(*) INTO vacuum_count
    FROM pg_stat_activity
    WHERE (query ILIKE 'vacuum%' or query ilike 'autovacuum%')
      AND state = 'active';
      
    RETURN vacuum_count;
END;
$$ LANGUAGE plpgsql;