SELECT 
    p.nama_produk,
    (
        SELECT ROUND( (AVG(h.harga_akhir - p2.harga_beli) / AVG(p2.harga_beli)) * 100, 2)
        FROM harga h
        JOIN produk p2 ON h.id_produk = p2.id_produk
        WHERE p2.id_produk = p.id_produk
    ) AS margin_persen
FROM produk p
ORDER BY margin_persen DESC;