/*
    Oryginalny kod źródłowy z dbt, który został zmodyfikowany w celu dostosowania do potrzeb zadania.
    Źródło: https://github.com/dbt-labs/dbt-codegen/blob/0.9.0/macros/generate_base_model.sql
*/

{% macro generate_base_model(source_name, table_name, case_sensitive_cols=False, materialized=None) %}
-- Makro `generate_base_model` tworzy bazowy model SQL dla wskazanego źródła danych i tabeli.

{%- set source_relation = source(source_name, table_name) -%}
-- Tworzymy obiekt `source_relation`, który reprezentuje źródło danych (schemat + tabela).

{%- set columns = adapter.get_columns_in_relation(source_relation) -%}
-- Pobieramy listę kolumn z podanej tabeli w źródle danych.

{% set column_names=columns | map(attribute='name') %}
-- Tworzymy listę nazw kolumn, przekształcając listę obiektów kolumn na same nazwy.

{% set base_model_sql %}
-- Definiujemy zmienną `base_model_sql`, w której budujemy zapytanie SQL.

{%- if materialized is not none -%}
    {{ "{{ config(materialized='" ~ materialized ~ "') }}" }}
    -- Jeśli `materialized` zostało przekazane, ustawiamy typ materializacji modelu dbt (np. `table`, `view`).
{%- endif %}

WITH source AS (
    SELECT *
    FROM {% raw %}{{ source({% endraw %}'{{ source_name }}', '{{ table_name }}'{% raw %}) }}{% endraw %}
    -- Tworzymy CTE `source`, który odwołuje się do źródłowej tabeli w dbt za pomocą funkcji `source()`.
)

SELECT
{%- for column in column_names %}
    {%- if column == 'id' -%}
    {# Jeśli kolumna ma nazwę "id", tworzymy klucz główny w standardowym formacie.
       Usuwamy ostatnią literę z nazwy tabeli, aby utworzyć formę liczby pojedynczej (np. "orders" → "order").
       Następnie dodajemy "_id", co jest spójnym standardem dla kluczy głównych i obcych. #}
    id AS {{ table_name[:-1] }}_id{{"," if not loop.last}}
    {%- else -%}
    {# W przeciwnym razie po prostu zwracamy nazwę kolumny bez zmian. #}
    {{ column }}{{"," if not loop.last}}
    {%- endif -%}
{%- endfor %}

FROM source
-- Pobieramy wszystkie kolumny z CTE `source`, przy czym jeśli kolumna nazywa się "id",
-- to zmieniamy jej nazwę zgodnie z opisanym schematem.

{% endset %}

{% if execute %}
-- Jeśli kod jest wykonywany, logujemy wynikowe zapytanie SQL i zwracamy je.
{{ log(base_model_sql, info=True) }}
{% do return(base_model_sql) %}
{% endif %}

{% endmacro %}

/*
Podsumowanie działania i zastosowania:
Makro `generate_base_model` automatyzuje generowanie bazowych modeli SQL w dbt.
Dzięki temu użytkownik może łatwo utworzyć standardowy model na podstawie tabeli źródłowej,
bez potrzeby ręcznego definiowania wszystkich kolumn.

Najważniejsze funkcje makra:
- Pobiera listę kolumn z podanej tabeli źródłowej.
- Automatycznie zmienia nazwę klucza głównego `id` na format `{nazwa_tabeli}_id`,
  co zapewnia spójność w modelowaniu danych.
- Umożliwia opcjonalne określenie sposobu materializacji modelu (`table`, `view`).
- Loguje wygenerowane zapytanie SQL w celu weryfikacji.

Makro to jest szczególnie przydatne w dużych projektach dbt,
ponieważ upraszcza proces tworzenia spójnych modeli danych i minimalizuje powtarzalność kodu.
*/