Select
    "date",
    age,
    count(*) As trips,
    sum(price_rub) As revenue_rub
From
    {{ ref("trips_users") }}
Group By
    1,
    2
