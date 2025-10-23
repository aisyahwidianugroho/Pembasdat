SELECT nama_spbu, selisih_transaksi
FROM (
    SELECT s.nama_spbu,
           (SUM(CASE WHEN DATE_PART('month', t.tanggal) = DATE_PART('month', CURRENT_DATE) THEN t.jumlah ELSE 0 END) -
            SUM(CASE WHEN DATE_PART('month', t.tanggal) = DATE_PART('month', CURRENT_DATE - INTERVAL '1 month') THEN t.jumlah ELSE 0 END)
           ) AS selisih_transaksi
    FROM transaksi t
    JOIN karyawan k ON t.id_karyawan = k.id_karyawan
    JOIN spbu_cabang s ON k.id_spbu = s.id_spbu
    GROUP BY s.id_spbu, s.nama_spbu
) AS perubahan
ORDER BY selisih_transaksi ASC
LIMIT 5;