W dbt istnieją 2 rodzaje testów, które możesz tworzyć:

1.	Niestandardowe testy pojedyncze (Singular Tests)
* Są to pliki SQL umieszczone w katalogu tests/.
* Każdy test to po prostu zapytanie SQL, które zwraca wiersze w przypadku niezgodności.
* Nie wymagają specjalnej składni {% test %}, wystarczy użyć ref('model_name') do wskazania modelu do testowania.
2.	Niestandardowe testy ogólne (Generic Tests)
* Są używane w plikach YAML jako część definicji modeli i kolumn.
* Powinny być umieszczone w folderze macros/ lub tests/generic/ (zaleca się tests/generic/).
* Wymagają zdefiniowania makra z {% test test_name(arguments) %} ... {% endtest %}.
* Mogą być wielokrotnie używane w różnych modelach.

Podsumowując: Testy niestandardowe pojedyncze są po prostu zapytaniami SQL, a testy ogólne są makrami wykorzystywanymi w YAML.
