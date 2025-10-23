SELECT nama_produk, total_transaksi
FROM (
    SELECT p.nama_produk, COUNT(t.id_transaksi) AS total_transaksi
    FROM produk p
    JOIN transaksi t ON t.id_produk = p.id_produk
    GROUP BY p.nama_produk
) AS frek
ORDER BY total_transaksi DESC
LIMIT 10;