SELECT wilayah, nama_produk, total_penjualan
FROM (
    SELECT sp.nama_spbu AS wilayah, p.nama_produk, SUM(t.jumlah) AS total_penjualan
    FROM transaksi t
    JOIN produk p ON t.id_produk = p.id_produk
    JOIN karyawan k ON t.id_karyawan = k.id_karyawan
    JOIN spbu_cabang sp ON k.id_spbu = sp.id_spbu
    GROUP BY wilayah, p.nama_produk
) AS wilayah_produk
ORDER BY total_penjualan DESC
LIMIT 10;