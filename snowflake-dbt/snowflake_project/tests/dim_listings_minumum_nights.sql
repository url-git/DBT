SELECT
    *
FROM
    {{ ref('dim_listings_cleansed') }}
WHERE minimum_nights < 1
LIMIT 10

{# Powyższy test "dim_listings_minumum_nights.sql" moze zostać usunięte, bo zastępuje go makro "positive_value"#}