--Total Pendapatan per SPBU
SELECT s.id_spbu, s.nama_spbu,
       (SELECT SUM(t.jumlah * h.harga_akhir)
        FROM transaksi t
        JOIN karyawan k2 ON t.id_karyawan = k2.id_karyawan
        JOIN harga h ON t.id_harga = h.id_harga
        WHERE k2.id_spbu = s.id_spbu
       ) AS total_pendapatan
FROM spbu_cabang s
ORDER BY total_pendapatan DESC;

--Total Transaksi per Jenis Produk
SELECT j.nama_jenis,
       (SELECT COUNT(*)
        FROM transaksi t
        JOIN produk p2 ON t.id_produk = p2.id_produk
        WHERE p2.kode_jenis = j.kode_jenis
       ) AS total_transaksi
FROM jenis j
ORDER BY total_transaksi DESC;

--SPBU dengan Omzet Tertinggi Bulan Ini
SELECT s.id_spbu, s.nama_spbu,
       (SELECT SUM(t.jumlah * h.harga_akhir)
        FROM transaksi t
        JOIN karyawan k2 ON t.id_karyawan = k2.id_karyawan
        JOIN harga h ON t.id_harga = h.id_harga
        WHERE k2.id_spbu = s.id_spbu
          AND DATE_PART('month', t.tanggal) = DATE_PART('month', CURRENT_DATE)
       ) AS omzet_bulan_ini
FROM spbu_cabang s
ORDER BY omzet_bulan_ini DESC
LIMIT 1;

--Total Stok Pembelian per Jenis Produk
SELECT j.nama_jenis,
       (SELECT SUM(pb.stok_masuk)
        FROM produk p2
        JOIN pembelian pb ON p2.id_produk = pb.id_produk
        WHERE p2.kode_jenis = j.kode_jenis
       ) AS total_stok
FROM jenis j
ORDER BY total_stok DESC;

--Karyawan dengan Total Transaksi Terbanyak
SELECT k.id_karyawan, k.nama_depan || ' ' || k.nama_belakang AS nama_karyawan,
       (SELECT COUNT(*) FROM transaksi t WHERE t.id_karyawan = k.id_karyawan) AS jumlah_transaksi
FROM karyawan k
ORDER BY jumlah_transaksi DESC
LIMIT 5;

--Supplier dengan Total Pembelian Tertinggi
SELECT s.id_supplier, s.nama_sup,
       (SELECT SUM(pb.stok_masuk)
        FROM pembelian pb
        WHERE pb.id_supplier = s.id_supplier
       ) AS total_pembelian
FROM supplier s
ORDER BY total_pembelian DESC;


--Rata-rata Harga Produk per Jenis
SELECT j.nama_jenis,
       (SELECT AVG(h.harga_akhir)
        FROM harga h
        JOIN produk p2 ON p2.id_produk = h.id_produk
        WHERE p2.kode_jenis = j.kode_jenis
       ) AS rata_harga
FROM jenis j
ORDER BY rata_harga DESC;

--SPBU dengan Jumlah Karyawan Terbanyak
SELECT s.id_spbu, s.nama_spbu,

       (SELECT COUNT(*) FROM karyawan k WHERE k.id_spbu = s.id_spbu) AS jumlah_karyawan
FROM spbu_cabang s
ORDER BY jumlah_karyawan DESC;


--Produk dengan Total Transaksi Tertinggi
SELECT p.id_produk, p.nama_produk,
       (SELECT COUNT(*) FROM transaksi t WHERE t.id_produk = p.id_produk) AS total_transaksi
FROM produk p
ORDER BY total_transaksi DESC
LIMIT 5;

--Rata-rata Pendapatan per Transaksi
SELECT ROUND((
    SELECT SUM(t.jumlah * h.harga_akhir)
    FROM transaksi t
    JOIN harga h ON t.id_harga = h.id_harga
) / (SELECT COUNT(*) FROM transaksi), 2) AS rata_pendapatan;

--Jumlah Kehadiran Karyawan per Bulan
SELECT k.id_karyawan, k.nama_depan || ' ' || k.nama_belakang AS nama_karyawan,
       (SELECT COUNT(*) 
        FROM kehadiran kh 
        WHERE kh.id_petugas = k.id_karyawan
          AND DATE_PART('month', kh.tanggal_kehadiran) = DATE_PART('month', CURRENT_DATE)
       ) AS jumlah_hadir_bulan_ini
FROM karyawan k
ORDER BY jumlah_hadir_bulan_ini DESC;

--Jenis Produk dengan Nilai Transaksi Tertinggi
SELECT j.nama_jenis,
       (SELECT SUM(t.jumlah * h.harga_akhir)
        FROM transaksi t
        JOIN produk p2 ON t.id_produk = p2.id_produk
        JOIN harga h ON t.id_harga = h.id_harga
        WHERE p2.kode_jenis = j.kode_jenis
       ) AS total_nilai
FROM jenis j
ORDER BY total_nilai DESC;

--SPBU dengan Rata-rata Harga Produk Tertinggi
SELECT s.id_spbu, s.nama_spbu,
       (SELECT AVG(h.harga_akhir)
        FROM harga h
        JOIN produk_cabang pc ON h.id_produk = pc.id_produk
        WHERE pc.id_spbu = s.id_spbu
       ) AS rata_harga_produk
FROM spbu_cabang s
ORDER BY rata_harga_produk DESC;

--Total Produk yang Dikelola per SPBU
SELECT s.id_spbu, s.nama_spbu,
       (SELECT COUNT(*) FROM produk_cabang pc WHERE pc.id_spbu = s.id_spbu) AS total_produk
FROM spbu_cabang s
ORDER BY total_produk DESC;

--Jabatan dengan Jumlah Karyawan Terbanyak
SELECT j.nama_jabatan,
       (SELECT COUNT(*) FROM karyawan k WHERE k.id_jabatan = j.id_jabatan) AS total_karyawan
FROM jabatan j
ORDER BY total_karyawan DESC;
