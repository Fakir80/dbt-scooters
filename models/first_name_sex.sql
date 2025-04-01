select distinct
    first_name,
    sex
from {{ source("scooters_raw", "users") }}
where sex is not null
