select distinct
    user_id,
    "timestamp",
    type_id,
    {{ updated_at() }}
from {{ source("scooters_raw", "events") }}
Where
{% if is_incremental() %}
    "timestamp" > (select max("timestamp") from {{ this }})
{% else %}
    "timestamp" < '2023-08-01'::timestamp
{% endif %}