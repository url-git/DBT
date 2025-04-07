{% macro more_example_jinja() %}
  {% set columns = adapter.get_columns_in_relation(ref('dim_orders')) %}

  {% set selected_columns = [] %}
  {% for column in columns %}
    {% if column.name.startswith('total') %}
      {% do selected_columns.append(column.name.upper()) %}
    {% endif %}
  {% endfor %}

  {% set values = dbt_utils.get_column_values(ref('dim_orders'), 'order_status') %}

  {{ log("Kolumny: " ~ selected_columns | join(', '), info=True) }}
  {{ log("Wartości z order_status: " ~ values | join(', '), info=True) }}

  {{ return("Makro wykonane – sprawdź log powyżej.") }}
{% endmacro %}