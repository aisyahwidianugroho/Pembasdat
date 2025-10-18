-- ==============================
-- DATABASE: PERTAMINA_PEMBAS
-- ==============================

-- 1. Tabel JABATAN
CREATE TABLE jabatan (
    id_jabatan VARCHAR(10) PRIMARY KEY,
    nama_jabatan VARCHAR(50) NOT NULL,
    jobdesc TEXT
);

-- 2. Tabel SPBU_CABANG
CREATE TABLE spbu_cabang (
    id_spbu VARCHAR(10) PRIMARY KEY,
    nama_spbu VARCHAR(100) NOT NULL,
    alamat TEXT,
    kota VARCHAR(50)
);

-- 3. Tabel LOGIN (1:1 dengan karyawan)
CREATE TABLE login (
    id_login VARCHAR(10) PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

-- 4. Tabel KARYAWAN
CREATE TABLE karyawan (
    id_kary VARCHAR(10) PRIMARY KEY,
    nama_depan VARCHAR(50) NOT NULL,
    nama_belakang VARCHAR(50) NOT NULL,
    id_jabatan VARCHAR(10) REFERENCES jabatan(id_jabatan) ON DELETE SET NULL,
    id_spbu VARCHAR(10) REFERENCES spbu_cabang(id_spbu) ON DELETE SET NULL,
    id_login VARCHAR(10) UNIQUE REFERENCES login(id_login) ON DELETE CASCADE
);

-- 5. Tabel JENIS
CREATE TABLE jenis (
    kode_jenis VARCHAR(10) PRIMARY KEY,
    nama_jenis VARCHAR(50) NOT NULL
);

-- 6. Tabel SUPPLIER
CREATE TABLE supplier (
    id_supplier VARCHAR(10) PRIMARY KEY,
    nama_sup VARCHAR(100) NOT NULL,
    no_telpon VARCHAR(20)
);

-- 7. Tabel POMPA
CREATE TABLE pompa (
    id_pompa VARCHAR(10) PRIMARY KEY,
    nama_pompa VARCHAR(50),
    kapasitas NUMERIC(12,2),
    status VARCHAR(20)
);

-- 8. Tabel PRODUK
CREATE TABLE produk (
    id_produk VARCHAR(10) PRIMARY KEY,
    nama_produk VARCHAR(100) NOT NULL,
    kode_jenis VARCHAR(10) REFERENCES jenis(kode_jenis) ON DELETE SET NULL,
    id_pompa VARCHAR(10) REFERENCES pompa(id_pompa) ON DELETE SET NULL,
    satuan VARCHAR(20),
    harga_beli NUMERIC(12,2),
    id_supplier VARCHAR(10) REFERENCES supplier(id_supplier) ON DELETE SET NULL
);

-- 9. Tabel HARGA
CREATE TABLE harga (
    id_harga VARCHAR(10) PRIMARY KEY,
    harga_akhir NUMERIC(12,2) NOT NULL,
    id_produk VARCHAR(10) REFERENCES produk(id_produk) ON DELETE CASCADE,
    tanggal DATE NOT NULL
);

-- 10. Tabel PRODUK_CABANG (stok produk di tiap cabang)
CREATE TABLE produk_cabang (
    id_produk VARCHAR(10) REFERENCES produk(id_produk) ON DELETE CASCADE,
    id_spbu VARCHAR(10) REFERENCES spbu_cabang(id_spbu) ON DELETE CASCADE,
    stok NUMERIC(12,2) DEFAULT 0,
    PRIMARY KEY (id_produk, id_spbu)
);

-- 11. Tabel PEMBELIAN
CREATE TABLE pembelian (
    id_pembelian VARCHAR(10) PRIMARY KEY,
    id_karyawan VARCHAR(10) REFERENCES karyawan(id_kary) ON DELETE SET NULL,
    stok_masuk NUMERIC(12,2),
    tanggal DATE NOT NULL,
    id_supplier VARCHAR(10) REFERENCES supplier(id_supplier) ON DELETE SET NULL,
    id_produk VARCHAR(10) REFERENCES produk(id_produk) ON DELETE SET NULL
);

-- 12. Tabel KEHADIRAN
CREATE TABLE kehadiran (
    id_kehadiran VARCHAR(10) PRIMARY KEY,
    tanggal_kehadiran DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Hadir', 'Izin', 'Sakit', 'Alpa')),
    shift VARCHAR(10),
    id_petugas VARCHAR(10) REFERENCES karyawan(id_kary) ON DELETE CASCADE
);

-- 13. Tabel TRANSAKSI
CREATE TABLE transaksi (
    id_transaksi VARCHAR(10) PRIMARY KEY,
    metode VARCHAR(20),
    tanggal TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_karyawan VARCHAR(10) REFERENCES karyawan(id_kary) ON DELETE SET NULL,
    id_harga VARCHAR(10) REFERENCES harga(id_harga) ON DELETE SET NULL,
    id_produk VARCHAR(10) REFERENCES produk(id_produk) ON DELETE SET NULL,
    jumlah NUMERIC(12,2)
);
