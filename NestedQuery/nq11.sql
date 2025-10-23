SELECT nama_depan, nama_belakang, total_transaksi
FROM (
    SELECT 
        k.nama_depan, 
        k.nama_belakang, 
        COUNT(t.id_transaksi) AS total_transaksi
    FROM karyawan k
    LEFT JOIN transaksi t 
        ON k.id_karyawan = t.id_karyawan
        AND t.tanggal >= CURRENT_DATE - INTERVAL '1 month'
    JOIN jabatan j 
        ON k.id_jabatan = j.id_jabatan
    WHERE LOWER(j.nama_jabatan) = 'operator'
    GROUP BY k.nama_depan, k.nama_belakang
) AS recent_perf
ORDER BY total_transaksi ASC
LIMIT 5;