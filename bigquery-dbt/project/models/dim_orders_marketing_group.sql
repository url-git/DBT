{{ config(group = 'marketing') }}

select *

from {{ ref('dim_orders') }}


-- Node model.project.dim_orders_marketing_group attempted to reference node model.project.dim_orders, which is not allowed because the referenced node is private to the 'sales' group.
