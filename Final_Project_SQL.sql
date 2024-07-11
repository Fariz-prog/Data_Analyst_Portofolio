--Nomor 1
--Q: Selama transaksi yang terjadi selama 2021, pada bulan apa total nilai transaksi
--(after_discount) paling besar? Gunakan is_valid = 1 untuk memfilter data transaksi.

--CTE
WITH
	complete_transaction as (
    SELECT
        *
    FROM
        order_detail AS o
    LEFT JOIN sku_detail AS s ON o.sku_id = s.id
    LEFT JOIN customer_detail as c ON o.customer_id = c.id
    LEFT join payment_detail as p on o.payment_id = p.id
)

SELECT
	TO_CHAR (order_date, 'month') month_2021,
    round(SUM (after_discount)) transaction_total
FROM
	complete_transaction
WHERE 
	to_char(order_date,'yyyy-mm-dd') between '2021-01-01' and '2021-12-31'
    AND
    is_valid = 1
GROUP BY
	1
ORDER by 2 DESC227862744


--Nomor 2
--Q: Selama transaksi pada tahun 2022, kategori apa yang menghasilkan nilai transaksi paling
--besar? Gunakan is_valid = 1 untuk memfilter data transaksi.
	
SELECT
	category,
    round(SUM (after_discount)) transaction_total
FROM
	order_detail od
left join sku_detail sd on sd.id = od.sku_id
WHERE 
	to_char(order_date,'yyyy-mm-dd') between '2022-01-01' and '2022-12-31'
    AND
    is_valid = 1
GROUP BY
	1
ORDER by 2 DESC
LIMIT 1

--Nomor 3
--Q: Bandingkan nilai transaksi dari masing-masing kategori pada tahun 2021 dengan 2022.
--Sebutkan kategori apa saja yang mengalami peningkatan dan kategori apa yang mengalami
--penurunan nilai transaksi dari tahun 2021 ke 2022. Gunakan is_valid = 1 untuk memfilter data
--transaksi.
	
WITH tt AS (
SELECT
	sd.category,
    round (SUM (CASE WHEN to_char(order_date, 'YYYY-MM-DD') 
                BETWEEN '2021-01-01' AND '2021-12-31' THEN od.after_discount END)) total_sales_2021,
    round (SUM (CASE WHEN to_char(order_date, 'YYYY-MM-DD') 
                BETWEEN '2022-01-01' AND '2022-12-31' THEN od.after_discount END)) total_sales_2022
FROM
	order_detail od
LEFT JOIN sku_detail sd ON od.sku_id = sd.id
WHERE
    is_valid = 1
GROUP BY
	1
ORDER by 2 DESC
)

SELECT
*,
round(total_sales_2022 - total_sales_2021) growth_value,
CASE
      WHEN (total_sales_2022 > total_sales_2021) 
      	THEN 'INCREASE'
      WHEN (total_sales_2022 < total_sales_2021) 
      	THEN 'DECREASE'
      ELSE 'SAME'
    END AS Growth_Status
FROM
	tt
order BY 4 DESC

--Nomor 4
--Q: Tampilkan top 5 metode pembayaran yang paling populer digunakan selama 2022
--(berdasarkan total unique order). Gunakan is_valid = 1 untuk memfilter data transaksi.

SELECT
	payment_method,
    COUNT(DISTINCT od.id) Total_unique_order
FROM
	order_detail AS od
JOIN payment_detail pd ON od.payment_id = pd.id
WHERE
	to_char(order_date,'yyyy-mm-dd') between '2022-01-01' and '2022-12-31' 
    AND 
    is_valid = 1
GROUP BY
	1
ORDER by 2 DESC
LIMIT 5

--Nomor 5
--Q: Urutkan dari ke-5 produk ini berdasarkan nilai transaksinya.
--1. Samsung
--2. Apple
--3. Sony
--4. Huawei
--5. Lenovo
--Gunakan is_valid = 1 untuk memfilter data transaksi.
	
WITH tt AS (    
    SELECT
        CASE
      		WHEN LOWER (sd.sku_name) LIKE '%samsung%' THEN 'SAMSUNG'
      		WHEN LOWER (sd.sku_name) LIKE '%apple%' OR
      			LOWER (sd.sku_name) LIKE '%iphone%' OR
      			LOWER (sd.sku_name) LIKE '%macbook%' THEN 'APPLE'
      		WHEN LOWER (sd.sku_name) LIKE '%lenovo%' THEN 'LENOVO'
      		WHEN LOWER (sd.sku_name) LIKE '%sony%' THEN 'SONY'
      		WHEN LOWER (sd.sku_name) LIKE '%huawei%' THEN 'HUAWEI'
      	END Product_brand,
      	round (SUM (od.after_discount)) total_sales
    FROM
        order_detail AS od
    LEFT JOIN sku_detail AS sd ON od.sku_id = sd.id
    WHERE 
    is_valid = 1
    group BY 1
    ORDER by 2 DESC
)

SELECT
	tt.*
FROM
	tt
WHERE
	Product_brand NOTNULL
order by 
	2 DESC


