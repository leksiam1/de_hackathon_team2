
create table cdm.buy_products(
    id serial primary key,
    hour_timestamp timestamp not null,
    count_products int8 not null
)

with confirmation_periods as (
    select
        coalesce (lag (event_timestamp::timestamp) 
            over (partition by page_url_path, user_domain_id 
                order by event_timestamp::timestamp), '1900-01-01'::timestamp) as previous_confirmation,        
        event_timestamp::timestamp,
        user_domain_id    
    from stage.events
    where page_url_path = '/confirmation' 
),
product_in_cart as (
    select 
    event_timestamp,
    user_domain_id,
    event_id
from
(select
    event_timestamp::timestamp as event_timestamp,
    user_domain_id,
    page_url_path,
    lag(page_url_path) over (partition by user_domain_id order by event_timestamp::timestamp) as previous_page,
    event_id 
from stage.events) as lag_pages
where page_url_path = '/cart' and previous_page like '/product%'
),
result_table as (
select
    date_trunc('hour', confirmation_periods.event_timestamp) as hour_timestamp,
    count(distinct product_in_cart.event_timestamp) as count_products
from confirmation_periods as confirmation_periods
inner join product_in_cart as product_in_cart
on confirmation_periods.user_domain_id = product_in_cart.user_domain_id
and product_in_cart.event_timestamp between confirmation_periods.previous_confirmation and confirmation_periods.event_timestamp
group by 
    date_trunc('hour', confirmation_periods.event_timestamp)
)
insert into cdm.buy_products(
    hour_timestamp,
    count_products)
select 
    hour_timestamp,
    count_products
from result_table
;