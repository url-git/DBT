{% macro logging_and_variables() %}
    {{ log("Call your mom!") }}
    {{ log("Call your mom!", info=True) }}
    -- {{ log("This shouldn't be printed", info=True) }}
    {# log("This really shouldn't be printed", info=True) #}

    {% set your_name = "Piotr" %}
    {{ log("Hello " ~ your_name ~ ", call your Mom!", info=true) }}


    {# log("Now, hello " ~ var("user_name") ~ "!", info=true) #}
    {{ log("Now, hello " ~ var("user_name", "...mmmhmmm...") ~ "!", info=true) }}

    {% if var("user_name", False) %}
        {{ log("User name defined:" ~ var("user_name", False), info=True) }}
    {% else %}
        {{ log("User name not defined", info=True) }}
    {% endif %}
{% endmacro %}

{#
dbt run-operation logging_and_variables --profiles-dir .
dbt run-operation logging_and_variables --profiles-dir . --args '{"user_name": "Piotr"}'

15:54:35  Call your mom!
15:54:35  This shouldn't be printed
15:54:35  Hello Piotr, call your Mom!
15:54:35  Now, hello PIOTR!
15:54:35  User name defined:PIOTR
#}