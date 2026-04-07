CREATE TABLE kimia_farma.Tabel_analisis AS
SELECT
--Data dari Tabel final_transaction
  f.date AS tanggal_transaksi,
  f.transaction_id AS id_transaksi,
  f.customer_name AS nama_customer,
  f.rating AS rating_transaksi,
  f.branch_id AS id_cabang,
--Data dari Tabel kantor_cabang
  k.branch_name AS nama_cabang,
  k.kota AS kota,
  k.provinsi AS provinsi,
  k.rating AS rating_cabang,
--Sisipan dari Tabel final_transaction
  f.product_id AS id_produk,
--Data dari Tabel product
  p.product_name AS nama_produk,
  p.price AS harga_produk,
-- Sisipan dari tabel lain
  f.discount_percentage AS discount_percentage,
-- Membuat kolom baru dengan CASE WHEN
CASE
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    WHEN p.price > 50000 THEN 0.3
    ELSE 0
END AS persentase_gross_laba,
-- Menghitung dan membuat kolom harga setelah diskon (Nett Sales)
(p.price * (1-discount_percentage)) AS nett_sales,
-- Menghitung dan membuat kolom laba yang didapat (Nett Profit)
((p.price * (1-discount_percentage)) * (CASE
    WHEN p.price <= 50000 THEN 0.1
    WHEN p.price > 50000 AND p.price <= 100000 THEN 0.15
    WHEN p.price > 100000 AND p.price <= 300000 THEN 0.2
    WHEN p.price > 300000 AND p.price <= 500000 THEN 0.25
    WHEN p.price > 50000 THEN 0.3
    ELSE 0 
    END)
) AS nett_profit

FROM `kimia_farma.final_transaction` AS f
LEFT JOIN `kimia_farma.kantor_cabang` AS k
  ON f.branch_id = k.branch_id
LEFT JOIN `kimia_farma.product` AS p
  ON f.product_id = p.product_id

ORDER BY tanggal_transaksi ASC;

SELECT nama_cabang, provinsi FROM `kimia_farma.Tabel_analisis` WHERE id_transaksi = 'TRX7039576';
SELECT count(Distinct id_transaksi) FROM `kimia_farma.Tabel_analisis`;

SELECT 
  nama_cabang,
  provinsi,
  AVG(rating_cabang) AS avg_rating_cabang,
  AVG(rating_transaksi) AS avg_rating_transaksi
FROM `kimia_farma.Tabel_analisis`
GROUP BY nama_cabang, provinsi
ORDER BY avg_rating_transaksi ASC
LIMIT 5;