SELECT 
    s.nama_supplier AS nama_supplier,
    hasil.total_transaksi
FROM (
    SELECT 
        p.id_supplier,
        COUNT(t.id_transaksi) AS total_transaksi
    FROM transaksi t
    JOIN produk p ON t.id_produk = p.id_produk
    GROUP BY p.id_supplier
) AS hasil
JOIN supplier s ON s.id_supplier = hasil.id_supplier
ORDER BY hasil.total_transaksi DESC
LIMIT 5;