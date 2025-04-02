/*
    Sprawdza, czy dla każdego zamówienia liczba pozycji w tabeli order_items
    zgadza się z kolumną num_items_ordered w tabeli orders.

    Zwraca wszystkie wiersze, w których liczba pozycji w zamówieniu się nie zgadza.

    Można przeprowadzić wiele innych kontroli, np. sprawdzić, czy dla każdego order_id
    jest tylko jeden user_id, czy znaczniki czasowe 'shipped_at' są takie same dla danego zamówienia,
    ale ten przykład to po prostu przykład niestandardowego testu.
*/

WITH order_details AS (  -- Tworzymy tymczasową tabelę order_details z liczbą pozycji w zamówieniu
    SELECT
        order_id,  -- Identyfikator zamówienia
        COUNT(*) AS num_of_items_in_order  -- Liczba pozycji w zamówieniu

    FROM {{ ref('stg_ecommerce__order_items') }}  -- Odwołujemy się do tabeli order_items
    GROUP BY 1  -- Grupujemy po order_id, aby uzyskać liczbę pozycji per zamówienie
)

SELECT
    o.*,  -- Zwracamy wszystkie kolumny z tabeli orders
    od.*  -- Zwracamy wszystkie kolumny z tabeli order_details

FROM {{ ref('stg_ecommerce__orders') }} AS o  -- Odwołujemy się do tabeli orders
FULL OUTER JOIN order_details AS od USING(order_id)  -- Łączymy order_details z orders po order_id
WHERE
    -- Sprawdzamy, czy wszystkie zamówienia mają przynajmniej 1 pozycję, a każda pozycja jest przypisana do zamówienia
    o.order_id IS NULL  -- Jeżeli nie ma pasującego zamówienia w orders
    OR od.order_id IS NULL  -- Jeżeli nie ma pasującej pozycji w order_details
    -- Sprawdzamy, czy liczba pozycji w zamówieniu nie zgadza się z wartością w orders
    OR o.num_items_ordered != od.num_of_items_in_order  -- Jeżeli liczba zamówionych pozycji nie zgadza się z liczbą pozycji w order_items