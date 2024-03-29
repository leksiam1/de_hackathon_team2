# de_hackathon_team2

# Создать хранилище сырых данных в Postgres

de_student.stage - Слой сырых данных
    events - события, загружаем из источника как есть

    	id serial - уникальный id
        event_id  varchar - id события
        event_timestamp  varchar - врмя события
        event_type  varchar - тип события
        page_url  varchar - адрес ресурса 
        page_url_path  varchar - директория посещаемой пользователем страницы
        referer_url  varchar - 
        referer_url_scheme  varchar - 
        referer_url_port int4 - 
        referer_medium  varchar - 
        utm_medium  varchar - 
        utm_source  varchar - 
        utm_content  varchar - 
        utm_campaign  varchar - 
        click_id  varchar - 
        geo_latitude float - 
        geo_longitude float - 
        geo_country  varchar - 
        geo_timezone  varchar - 
        geo_region_name  varchar - 
        ip_address  varchar - 
        browser_name  varchar - 
        browser_user_agent  varchar - 
        browser_language  varchar - 
        os varchar - 
        os_name  varchar - 
        os_timezone  varchar - 
        device_type  varchar - 
        device_is_mobile boolean - 
        user_custom_id  varchar - id пользователя
        user_domain_id  varchar - 
      


## Задача 1 - Показать распределение событий по часам.

События берём из page_url_path, по типу посещаемой страницы.

de_student.cdm - витрина распределение событий по часам
    	id serial4 - id записи,
        hour_timestamp timestamp - час события,
        count_events int8 - количество событий,
        event_type text - по типу.

загрузка напрямую в виду простой реализации.

Визуализация в metabase выполнена в разрезе событий по часам.
Витрина "Распределение событий по часам" на dashboard "de_student"

# Инструкция
- подключиться к Jupyter Notebook 
- проверить подключение к spark по инструкции в start.ipunb
- подключиться r БД postgres 
- в postgres создать схему stage и таблицу для сырых данных events скриптом из de_hackathon\de_hackathon_team2\src\scripts\stage\events.sql
- в Jupyter Notebook, прогрузить сырые данные скриптом из de_hackathon\de_hackathon_team2\src\dags\load_events_stage.py
- в postgres создать слой cdm, создать таблицу витрины и заполнить витрину events_hours скриптом de_hackathon\de_hackathon_team2\src\scripts\cdm\events_hours.sql
- переходим в metabase
- подключаемся к нашему postgres
- витрина "Распределение событий по часам" на dashboard "de_student"


## Задача 2 - Показать количество купленных товаров в разрезе часа.
page_url_path - событие<br>
Нужно проанализировать последовательность событий чтобы посчитать купленные товары.<br>
Событие /cart после /product_* - считаем фактом добавления товара в корзину<br>
Событие confirmation - факт оплаты<br>
Количество купленных товаров есть количество добавлений в корзину перед оплатой.<br>
Количество товаров каждой оплаты вычисляется отдельно по пользователю (user_domain_id) и часу даты оплаты, затем всё суммируется.<br>
Витрина "Количество купленных товаров в разрезе часа"<br>

## Задача 3 - Показать топ-10 посещённых страниц, с которых был переход в покупку — список ссылок с количеством покупок.
Не сделано


## Задача 1* 
Проанализировать и визуализировать покупки по источникам. В данных заложены источники и рекламные
кампании, из которых пользователи переходили на портал. Создайте визуализацию, показывающую процентное
соотношение пользователей.

sources - витринаю, показывающуя процентное соотношение пользователей.
	id serial4 - id записи,
	referer_url varchar - url ресурса,
	utm_campaign varchar - компании,
	count_users int8 - количество посещений.

Скрипт - de_hackathon\de_hackathon_team2\src\scripts\cdm\sources.sql
Витрина "Sources, Sum of Count Users, Grouped by Referer URL" на dashboard "de_student"

