--* artinya semua kolom
SELECT
	order_id
    , customer_id
    , postal_code
    , category
    , sales
FROM orders_new_edited



--distinct = berbeda/unique
--memanggil row dengan nilai yang berbeda
SELECT DISTINCT subcategory FROM orders_new_edited


--filter baris menggunakan WHERE
SELECT * FROM orders_new_edited where category = 'Furniture'

-- <, >, >=, <=, <>
SELECT * FROM orders_new_edited where profit < 0

--filter semua transaksi yang revenue diatas 500
SELECT * FROM orders_new_edited where sales > 500

--menampilkan data transaksi di kategori furniture dan transaksinya rugitabel_data_diri
SELECT * FROM orders_new_edited WHERE category = 'Furniture' AND profit<0

--tampilkan semua transaksi yang berasal dari 2 kota, Houston dan Los Angeles
SELECT*FROM orders_new_edited WHERE city = 'Houston' OR city = 'Los Angeles'

--tampilkan transaksi Furniture di Los Angeles dan Technology di Houston
SELECT 
	
FROM 
	orders_new_edited 
WHERE 
    (category = 'Furniture' AND city = 'Los Angeles') 
    OR 
    (category = 'Technology' AND city = 'Houston')

--tampilkan penjualan furniture di kota los angeles dan houston
SELECT
	category
    , city
    , order_id
FROM
	orders_new_edited
WHERE
	(category = 'Furniture') 
    AND 
    city IN ('Los Angeles','Houston','California')
    
-- not digunakan untuk membalikan kondisi
SELECT*
FROM
	orders_new_edited
    WHERE NOT
    category = 'Furniture'

--cara mengubah tipe data varchar to date
ALTER TABLE orders_tokopaedi
ALTER COLUMN order_date TYPE DATE USING order_date::DATE

ALTER TABLE order
ALTER COLUMN ship_date TYPE DATE USING ship_date::DATE

ALTER TABLE orders_tokopaedi
ALTER COLUMN sales TYPE NUMERIC USING sales::NUMERIC

SELECT sales::FLOAT AS sales
FROM orders_tokopaedi

--mencuplik data yang belakang nya s
SELECT DISTINCT(customer_name) FROM orders_tokopaedi WHERE customer_name LIKE '%s'

--memilih data penjualan pada bulan Desember 
SELECT * FROM orders_tokopaedi WHERE EXTRACT (MONTH FROM order_date)=12

--membuat tabel coba_coba dengan user id menggunakan serial
CREATE TABLE
	coba_coba 
    	(user_id serial,
         nama VARCHAR
         )

INSERT INTO coba_coba (nama) VALUES ('Riski')
INSERT INTO coba_coba (nama) VALUES ('Andi')
INSERT INTO coba_coba (nama) VALUES ('Farhan')

SELECT * FROM coba_coba


UPDATE coba_coba
set user_id = 2
WHERE nama = 

--IN
--transaksi di 3 kota (in digunakan untuk menyederhanakan OR berantai)
SELECT 
* 
FROM orders_tokopaedi
WHERE city IN ('Waterloo','Iowa City','Dubuque')

--BETWEEN
SELECT 
* 
FROM 
	orders_tokopaedi 
 WHERE 
    order_date 
 BETWEEN '2018-01-01' AND '2018-12-31'


SELECT 
* 
FROM 
	orders_realdata 
 WHERE 
    sales 
 BETWEEN 1000 AND 2000

--mengurutkan 2 (ascending A - Z, descending Z - A)
SELECT*FROM orders_tokopaedi order BY customer_name DESC

--mengurutkan transaksi dari yang paling baru
SELECT*FROM orders_tokopaedi order BY order_date DESC, customer_name ASC

--LIMIT (membatasi banyaknya row yang ditampilkan, dari baris teratas)
SELECT
*
FROM orders_tokopaedi 
order BY order_date DESC
LIMIT 5


--ALIAS (nama lain)
--'SKU' (kode barang)
SELECT
	customer_id Nomor_Member 
    , product_id SKU
FROM orders_tokopaedi

SELECT*FROM orders_tokopaedi
--mengetahui banyaknya baris pada tabel/data
SELECT 
	COUNT (sales) 
FROM orders_tokopaedi

--hitung berapa banyak transaksi yang terjadi
SELECT COUNT (DISTINCT order_id) FROM orders_tokopaedi

--hitung berapa banyak konsumen bertransaksi di tahun 2017
SELECT
	COUNT (DISTINCT customer_id)
    FROM orders_tokopaedi
    WHERE 
    EXTRACT (year FROM order_date) = 2017
    
    
--min
SELECT MIN (sales)
FROM orders_tokopaedi

--max
SELECT MAX (sales)
FROM orders_tokopaedi

--sum
SELECT SUM (sales)
FROM orders_tokopaedi

--average
SELECT AVG (sales)
FROM orders_tokopaedi


--GROUP BY
-- jumlah penjualan per area

SELECT
	region,
    category,
    SUM (sales) total_sales
FROM 
	orders_tokopaedi
GROUP BY 
	region, category
order BY 
	sum (sales) desc
    
--10 konsumen dengan total belanja terbesar, total prof, dan menghitung GPM (total profit/total sales)
SELECT
    customer_name,
    SUM (sales) total_sales,
    SUM (profit) total_profit,
    SUM (profit)/SUM(sales)*100.0 GPM
FROM
	orders_tokopaedi
GROUP BY 
	1
ORDER BY
	2 DESC 
limit 10
    

--menghitung MATU dari data 
--kolom bulan, tahun, banyaknya user yang bertransaksi
SELECT
	EXTRACT (MONTH FROM order_date) Bulan, 
    EXTRACT (YEAR FROM order_date) Tahun,
    COUNT (DISTINCT customer_id) MATU
FROM
	orders_tokopaedi
GROUP BY
	1,2
order BY
	2,1 ASC


--konsumen dengan total transaksi diatas 10.000
--WHERE tidak boleh mengandung Agregat
--comand yang digunakan = HAVING
SELECT
	customer_name,
    SUM (sales) total_transaksi
FROM
	orders_tokopaedi
GROUP BY
	customer_name
HAVING
	SUM (sales) > 10000 ORDER BY 2 DESC






