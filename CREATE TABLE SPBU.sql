-- ========================================
-- DATABASE: pertamina_pembas (versi PDM baru)
-- ========================================

-- 1. Tabel jabatan
CREATE TABLE jabatan (
    id_jabatan VARCHAR(10) PRIMARY KEY,
    nama_jabatan VARCHAR(50) NOT NULL,
    jobdesc TEXT
);

-- 2. Tabel spbu_cabang
CREATE TABLE spbu_cabang (
    id_spbu VARCHAR(10) PRIMARY KEY,
    nama_spbu VARCHAR(100) NOT NULL,
    alamat TEXT,
    no_telp VARCHAR(20),
    jam_operasional VARCHAR(50)
);

-- 3. Tabel supplier
CREATE TABLE supplier (
    id_supplier VARCHAR(10) PRIMARY KEY,
    nama_supplier VARCHAR(100) NOT NULL,
    no_telpon VARCHAR(20)
);

-- 4. Tabel jenis
CREATE TABLE jenis (
    kode_jenis VARCHAR(10) PRIMARY KEY,
    nama_jenis VARCHAR(50) NOT NULL
);

-- 5. Tabel pompa
CREATE TABLE pompa (
    id_pompa VARCHAR(10) PRIMARY KEY,
    nama_pompa VARCHAR(50),
    kapasitas NUMERIC(12,2),
    status VARCHAR(20)
);

-- 6. Tabel produk
CREATE TABLE produk (
    id_produk VARCHAR(10) PRIMARY KEY,
    nama_produk VARCHAR(100) NOT NULL,
    kode_jenis VARCHAR(10) REFERENCES jenis(kode_jenis) ON DELETE SET NULL,
    id_pompa VARCHAR(10) REFERENCES pompa(id_pompa) ON DELETE SET NULL,
    satuan VARCHAR(20),
    harga_beli NUMERIC(12,2),
    id_supplier VARCHAR(10) REFERENCES supplier(id_supplier) ON DELETE SET NULL
);

-- 7. Tabel harga
CREATE TABLE harga (
    id_harga VARCHAR(10) PRIMARY KEY,
    id_produk VARCHAR(10) REFERENCES produk(id_produk) ON DELETE CASCADE,
    harga_akhir NUMERIC(12,2) NOT NULL,
    tanggal DATE NOT NULL
);

-- 8. Tabel karyawan
CREATE TABLE karyawan (
    id_karyawan VARCHAR(10) PRIMARY KEY,
    nama_depan VARCHAR(50) NOT NULL,
    nama_belakang VARCHAR(50) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    id_jabatan VARCHAR(10) REFERENCES jabatan(id_jabatan) ON DELETE SET NULL,
    id_spbu VARCHAR(10) REFERENCES spbu_cabang(id_spbu) ON DELETE SET NULL
);

-- 9. Tabel kehadiran
CREATE TABLE kehadiran (
    id_kehadiran VARCHAR(10) PRIMARY KEY,
    tanggal_kehadiran DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('hadir', 'izin', 'sakit', 'alpa')),
    shift VARCHAR(10),
    id_karyawan VARCHAR(10) REFERENCES karyawan(id_karyawan) ON DELETE CASCADE
);

-- 10. Tabel produk_cabang
CREATE TABLE produk_cabang (
    id_produk VARCHAR(10) REFERENCES produk(id_produk) ON DELETE CASCADE,
    id_spbu VARCHAR(10) REFERENCES spbu_cabang(id_spbu) ON DELETE CASCADE,
    PRIMARY KEY (id_produk, id_spbu)
);

-- 11. Tabel pembelian
CREATE TABLE pembelian (
    id_pembelian VARCHAR(10) PRIMARY KEY,
    id_karyawan VARCHAR(10) REFERENCES karyawan(id_karyawan) ON DELETE SET NULL,
    id_supplier VARCHAR(10) REFERENCES supplier(id_supplier) ON DELETE SET NULL,
    id_produk VARCHAR(10) REFERENCES produk(id_produk) ON DELETE SET NULL,
    stok_masuk NUMERIC(12,2),
    harga_awal NUMERIC(12,2),
    tanggal DATE NOT NULL
);

-- 12. Tabel transaksi
CREATE TABLE transaksi (
    id_transaksi VARCHAR(10) PRIMARY KEY,
    metode VARCHAR(20),
    tanggal TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_karyawan VARCHAR(10) REFERENCES karyawan(id_karyawan) ON DELETE SET NULL,
    id_harga VARCHAR(10) REFERENCES harga(id_harga) ON DELETE SET NULL,
    id_produk VARCHAR(10) REFERENCES produk(id_produk) ON DELETE SET NULL,
    jumlah NUMERIC(12,2)
);
