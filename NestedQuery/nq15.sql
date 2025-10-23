SELECT nama_supplier, rata_harga
FROM (
    SELECT s.id_supplier, s.nama_supplier, ROUND(AVG(h.harga_akhir), 2) AS rata_harga
    FROM supplier s
    JOIN produk p ON s.id_supplier = p.id_supplier
    JOIN harga h ON h.id_produk = p.id_produk
    GROUP BY s.id_supplier, s.nama_supplier
) AS harga_supplier
WHERE rata_harga < (
    SELECT AVG(harga_akhir) FROM harga
)
ORDER BY rata_harga ASC
LIMIT 5;