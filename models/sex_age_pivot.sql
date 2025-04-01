select
    age,
    {{ dbt_utils.pivot('sex',["M", "F"]) }}
from {{ ref('trips_users') }}
group by age
order by age
