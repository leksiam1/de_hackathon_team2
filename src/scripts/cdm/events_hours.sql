create schema cdm;

CREATE TABLE cdm.events_hours (
    id serial primary key,
    hour_timestamp timestamp not null,
    event_type varchar not NULL,
    count_events int8 not null
);

insert into cdm.events_hours(
    hour_timestamp,
    event_type,
    count_events)
select 
    date_trunc('hour', event_timestamp::timestamp) as hour_timestamp,
    split_part(page_url_path, '/', 2) as event_type,
    count(*) as count_events
from stage.events 
group by 
date_trunc('hour', event_timestamp::timestamp),
split_part(page_url_path, '/', 2)    
;