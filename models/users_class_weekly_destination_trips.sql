with prep_daily_trips_cte as (
/* Для каждого пользователя находим статистику поездок в каждую точку на каждый день:
morning_trips - количество утренних поездок */
    select
        user_id,
        st_snaptogrid(
            st_makepoint(finish_lon, finish_lat), 0.001
        ) as destination,
        "date",
        count(case
            when
                extract(
                    hour from started_at at time zone 'Europe/Moscow'
                ) between 6 and 10
                then 1
        end) as morning_trips
    from
        {{ ref('trips_prep') }}
    group by 1, 2, 3
),

prep_weekly_trip_days_cte as (
/* Для каждого пользователя находим статистику поездок в каждую точкуна каждую неделю:
morning_trip_days - количество дней с утренними поездками */
    select
        user_id,
        destination,
        date_trunc('week', "date") as "week",
        count(
            distinct case when morning_trips > 0 then "date" end
        ) as morning_trip_days
    from prep_daily_trips_cte
    group by 1, 2, 3
),

prep_weekly_destination_trips_cte as (
/* Подготовка данных для профилирования пользователей по поездкам в определенное место в течение недели.
Для каждого пользователя находим список уникальных точек назначения и статистику по поездкам туда:
avg_morning_trip_days - среднее число дней с утренними поездками в неделю */
    select
        user_id,
        destination,
        avg(morning_trip_days) as avg_morning_trip_days
    from prep_weekly_trip_days_cte
    group by 1, 2
)

/* Классификация пользователей по поездкам в течение недели с учетом точки назначения:
  to_work - в утреннее время ездит в одно и то же место (на работу) минимум три раза в неделю */
select
    user_id,
    max(avg_morning_trip_days) >= 3 as to_work
from
    prep_weekly_destination_trips_cte
group by
    1
