{#
	Ta funkcja tworzy funkcję w docelowym schemacie, która może być użyta do wyodrębnienia nazwy marki
	z kolumny linku w tabeli zdarzeń.

	W tym przykładzie wyodrębniamy wszystko, co znajduje się po "/brand/", ponieważ wszystkie odpowiednie linki
	kończą się nazwą marki.

	Przykład: weźmy link: "/department/men/category/active/brand/columbia"
	Nasze wyrażenie regularne ".+/brand/(.+)" działa w następujący sposób:
	- ".+" oznacza DOWOLNY ciąg znaków 1 lub więcej razy. Samodzielnie, zwróciłoby cały ciąg!
	- "/brand/" dokładnie pasuje do tego fragmentu w linku.
		Jakbyśmy użyli ".+/brand/", zwróciłoby "/department/men/category/active/brand/"
	- "(.+)" wykonuje dwie rzeczy:
		1. Nawiasy oznaczają, że to jest część, którą chcemy zwrócić
		2. ".+" ponownie pasuje do DOWOLNEGO ciągu znaków po "/brand/"
#}

{% macro get_brand_name() %}
	-- Tworzymy lub zastępujemy funkcję w docelowym schemacie, która wyodrębnia nazwę marki z linku
	CREATE OR REPLACE FUNCTION {{ target.schema }}.get_brand_name(web_link STRING)
	RETURNS STRING
	AS (
		-- Funkcja REGEXP_EXTRACT służy do wyodrębnienia nazwy marki z linku (web_link)
		-- Wyrażenie regularne r'.+/brand/(.+)' pasuje do tekstu po "/brand/"
		REGEXP_EXTRACT(web_link, r'.+/brand/(.+)')
	)
{% endmacro %}