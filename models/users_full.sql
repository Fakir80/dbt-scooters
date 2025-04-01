select
    u.id,
    u.first_name,
    u.last_name,
    u.phone,
    u.birth_date,
    COALESCE(u.sex, fns.sex, afns.sex) as sex2
from {{ source("scooters_raw", "users") }} as u
left join {{ ref("first_name_sex") }} as fns on u.first_name = fns.first_name
left join
    {{ ref("add_first_name_sex") }} as afns
    on u.first_name = afns.first_name
