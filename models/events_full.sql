select *, date("timestamp") as "date" from
{{ ref("events_clean") }} as e
left join {{ ref("event_types") }} as t
using (type_id)