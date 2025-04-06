{% snapshot snapshot__distribution_centers %}

{{
	config(
		target_schema='snapshots_project',
		unique_key='id',
		strategy='check',
		check_cols=['name', 'latitude', 'longitude']
	)
}}

SELECT
	id,
	name,
	latitude,
	longitude

FROM {{ source('thelook_ecommerce', 'distribution_centers') }}

{% endsnapshot %}