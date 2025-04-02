{#
	Test "primary_key" sprawdza, czy dana kolumna spełnia warunki klucza głównego:
	1. Nie zawiera wartości NULL (czyli każda wartość musi być obecna).
	2. Jest unikalna (brak duplikatów).

	Jeśli którakolwiek z tych zasad zostanie naruszona, test zwróci błędne wiersze,
	co oznacza, że test nie został zaliczony.
#}

{% test primary_key(model, column_name) %}  -- Definicja niestandardowego testu dbt

WITH validation AS (
	SELECT
		{{ column_name }} AS primary_key,  -- Pobieramy wartości z testowanej kolumny
		COUNT(1) AS occurrences  -- Liczymy, ile razy każda wartość występuje
	FROM {{ model }}  -- Źródło danych to testowany model
	GROUP BY 1  -- Grupujemy po wartościach w kolumnie
)

SELECT *
FROM validation
WHERE primary_key IS NULL  -- Sprawdzamy, czy występują wartości NULL
	OR occurrences > 1  -- Sprawdzamy, czy są duplikaty (więcej niż 1 wystąpienie)

{% endtest %}