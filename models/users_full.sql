select
    u.id,
    u.first_name,
    u.last_name,
    u.phone,
    COALESCE(u.sex, fns.sex, afns.sex) as sex2,
    u.birth_date
from {{ source("scooters_raw", "users") }} u
left join {{ ref("first_name_sex") }} fns on u.first_name = fns.first_name
left join {{ ref("add_first_name_sex") }} afns on u.first_name = afns.first_name
