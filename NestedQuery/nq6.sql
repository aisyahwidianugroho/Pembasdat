SELECT 
    p.nama_produk,
    ROUND(prod.avg_stok - total.avg_stok_global, 2) AS selisih_stok
FROM (
    SELECT id_produk, AVG(stok_masuk) AS avg_stok
    FROM pembelian
    GROUP BY id_produk
) AS prod
CROSS JOIN (
    SELECT AVG(stok_masuk) AS avg_stok_global FROM pembelian
) AS total
JOIN produk p ON p.id_produk = prod.id_produk
WHERE prod.avg_stok > total.avg_stok_global
ORDER BY selisih_stok DESC 
LIMIT 10;