{% test positive_value(model, column_name) %}
SELECT
    *
FROM
    {{ model }}
WHERE
    {{ column_name}} < 1
{% endtest %}

{# Powyższe makro "positive_value" wielokrotnego użytku to refaktor dla models/tests/dim_listings_minumum_nights.sql, które moze zostać usunięte #}