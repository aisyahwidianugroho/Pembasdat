SELECT 
    s.nama_spbu,
    COALESCE(sub.jumlah_karyawan_aktif, 0) AS jumlah_karyawan_aktif
FROM spbu_cabang s
LEFT JOIN (
    SELECT 
        k.id_spbu,
        COUNT(DISTINCT CASE WHEN kh.status = 'hadir' THEN k.id_karyawan END) AS jumlah_karyawan_aktif
    FROM karyawan k
    LEFT JOIN kehadiran kh ON kh.id_karyawan = k.id_karyawan
    GROUP BY k.id_spbu
) AS sub ON s.id_spbu = sub.id_spbu
ORDER BY jumlah_karyawan_aktif DESC
LIMIT 5;