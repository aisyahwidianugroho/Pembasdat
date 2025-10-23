SELECT nama_spbu, transaksi_per_karyawan
FROM (
    SELECT 
        s.nama_spbu,
        SUM(COALESCE(t_sub.jumlah_transaksi, 0))::float / COUNT(k.id_karyawan) AS transaksi_per_karyawan
    FROM spbu_cabang s
    JOIN karyawan k ON k.id_spbu = s.id_spbu
    JOIN jabatan j ON k.id_jabatan = j.id_jabatan
    LEFT JOIN (
        SELECT id_karyawan, COUNT(*) AS jumlah_transaksi
        FROM transaksi
        GROUP BY id_karyawan
    ) t_sub ON t_sub.id_karyawan = k.id_karyawan
    WHERE LOWER(j.nama_jabatan) = 'operator'
    GROUP BY s.nama_spbu
) AS hasil
ORDER BY transaksi_per_karyawan DESC
LIMIT 5;