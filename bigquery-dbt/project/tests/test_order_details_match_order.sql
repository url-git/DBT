{# Ta konfiguracja jest opcjonalna, ponieważ już ustawiliśmy domyślną powagę na 'warn' #}
{{ config(severity='warn') }}  -- Ustawia poziom powagi testu na 'warn', co oznacza, że wynik testu będzie traktowany jako ostrzeżenie, a nie błąd.

 /*
    Sprawdza, czy dla każdego zamówienia liczba pozycji w tabeli order_items
    odpowiada wartości num_items_ordered w tabeli orders.

    Zwraca wszystkie wiersze, w których nie uzyskano zgodności.

    Można przeprowadzić inne testy (np. sprawdzić, czy dla jednego zamówienia jest tylko jeden user_id,
    czy znaczniki czasowe 'shipped_at' są takie same dla danego zamówienia), ale to jest tylko przykład testu niestandardowego.
*/

WITH order_details AS (  -- Tworzy tymczasową tabelę 'order_details' zawierającą liczbę pozycji w zamówieniu.
    SELECT
        order_id,  -- Pobiera identyfikator zamówienia
        COUNT(*) AS num_of_items_in_order  -- Liczy liczbę pozycji w każdym zamówieniu (zlicza wiersze dla każdego order_id)

    FROM {{ ref('stg_ecommerce__order_items') }}  -- Odwołuje się do tabeli 'stg_ecommerce__order_items' (zdefiniowanej jako model w DBT)
    GROUP BY 1  -- Grupuje wyniki po order_id, aby uzyskać liczbę pozycji dla każdego zamówienia
)

SELECT
    o.*,  -- Zwraca wszystkie kolumny z tabeli orders
    od.*  -- Zwraca wszystkie kolumny z tymczasowej tabeli 'order_details'

FROM {{ ref('stg_ecommerce__orders') }} AS o  -- Odwołuje się do tabeli 'stg_ecommerce__orders' (zdefiniowanej jako model w DBT)
FULL OUTER JOIN order_details AS od USING(order_id)  -- Łączy tabele orders i order_details po identyfikatorze zamówienia
WHERE
    -- Wszystkie zamówienia powinny mieć co najmniej 1 pozycję, a każda pozycja powinna być powiązana z zamówieniem
    o.order_id IS NULL  -- Sprawdza, czy zamówienie z tabeli 'orders' nie ma odpowiadającej pozycji w 'order_details'
    OR od.order_id IS NULL  -- Sprawdza, czy pozycja w 'order_details' nie ma odpowiadającego zamówienia w 'orders'
    -- Liczba pozycji w zamówieniu nie zgadza się
    OR o.num_items_ordered != od.num_of_items_in_order  -- Sprawdza, czy liczba zamówionych pozycji w orders nie zgadza się z liczbą pozycji w order_items