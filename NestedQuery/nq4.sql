SELECT nama_produk, total_penjualan
FROM (
    SELECT p.nama_produk, SUM(t.jumlah) AS total_penjualan
    FROM transaksi t
    JOIN produk p ON t.id_produk = p.id_produk
    GROUP BY p.nama_produk
) AS penjualan
ORDER BY total_penjualan DESC
LIMIT 10;