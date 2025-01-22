select distinct first_name, sex
from {{ source("scooters_raw", "users") }}
Where sex is not null