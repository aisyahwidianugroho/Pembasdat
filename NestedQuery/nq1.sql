SELECT s.nama_spbu, total_pendapatan
FROM (
    SELECT k.id_spbu, SUM(t.jumlah * h.harga_akhir) AS total_pendapatan
    FROM transaksi t
    JOIN harga h ON t.id_harga = h.id_harga
    JOIN produk p ON t.id_produk = p.id_produk
    JOIN karyawan k ON t.id_karyawan = k.id_karyawan
    GROUP BY k.id_spbu
) AS pendapatan
JOIN spbu_cabang s ON s.id_spbu = pendapatan.id_spbu
ORDER BY total_pendapatan DESC
LIMIT 5;