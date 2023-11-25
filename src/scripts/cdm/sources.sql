create table cdm.sources(
    id serial primary key,
    referer_url varchar not null,
    utm_campaign varchar not null,
    count_users int8 not null)


insert into cdm.sources(referer_url, utm_campaign, count_users)
select
    referer_url,
    utm_campaign,
    count(distinct user_domain_id)    
from stage.events
group by referer_url, utm_campaign

