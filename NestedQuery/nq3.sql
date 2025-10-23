SELECT nama_depan, nama_belakang, total_transaksi
FROM (
    SELECT k.id_karyawan, k.nama_depan, k.nama_belakang,
           COUNT(t.id_transaksi) AS total_transaksi
    FROM karyawan k
    JOIN transaksi t ON k.id_karyawan = t.id_karyawan
    JOIN jabatan j ON k.id_jabatan = j.id_jabatan
WHERE LOWER(j.nama_jabatan) = 'operator'
GROUP BY k.id_karyawan, k.nama_depan, k.nama_belakang
) AS aktivitas
ORDER BY total_transaksi DESC
LIMIT 10;
