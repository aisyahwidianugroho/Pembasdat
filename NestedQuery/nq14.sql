SELECT nama_spbu, total_transaksi
FROM (
    SELECT s.nama_spbu, COUNT(t.id_transaksi) AS total_transaksi
    FROM spbu_cabang s
    JOIN karyawan k ON s.id_spbu = k.id_spbu
    JOIN transaksi t ON t.id_karyawan = k.id_karyawan
    GROUP BY s.nama_spbu
) AS totalan
ORDER BY total_transaksi DESC
LIMIT 5;