# generator_spbu_jatim_v6.py
# Generates spbu_jatim_10000.sql (8 kota, 1000 SPBU, batching INSERTs for stability)
# Spec:
# - CITIES = ["Surabaya","Sidoarjo","Mojokerto","Gresik","Malang","Jombang","Kediri","Blitar"]
# - SPBU_N = 1000
# - SUPPLIER_N = 3
# - PUMP_N = 10000
# - KARYAWAN_N = 5000  (ratio 4:1 operator:supervisor)
# - TRANSAKSI_N = 180000
# - PEMBELIAN_N = 2000
# - KEHADIRAN_N = 150000
#
# Output: spbu_jatim_10000.sql

import random, datetime, itertools
from pathlib import Path

OUT = Path("spbu_jatim_10000.sql")
random.seed(77)

def z(n, width=5): 
    return str(n).zfill(width)

def random_date(start, end):
    delta = (end - start).days
    return (start + datetime.timedelta(days=random.randint(0, delta))).isoformat()

def write_insert_batches(f, table_name, rows, batch_size=500):
    for i in range(0, len(rows), batch_size):
        batch = rows[i:i+batch_size]
        f.write(f"INSERT INTO {table_name} VALUES\n" + ",\n".join(batch) + ";\n\n")

# Dates
start_date = datetime.date(2024, 9, 1)
end_date   = datetime.date(2025, 10, 1)

# Config
CITIES = ["Surabaya","Sidoarjo","Mojokerto","Gresik","Malang","Jombang","Kediri","Blitar"]
SPBU_N = 1000
SUPPLIER_N = 3
PUMP_N = 10000
KARYAWAN_N = 5000
TRANSAKSI_N = 180000
PEMBELIAN_N = 2000
KEHADIRAN_N = 150000

jabatan_roles = ["supervisor","operator"]

# Programmatically build many distinct names to ensure >= 5000 unique pairs
syllables_fn = ["Adi","Budi","Citra","Dewi","Eka","Fajar","Gita","Hendra","Indra","Joko",
                "Lina","Made","Nanda","Oka","Putri","Qory","Rafi","Sari","Tono","Umi",
                "Vino","Wulan","Yogi","Zahra","Rizky","Bayu","Novi","Sinta","Andra","Nadia",
                "Agus","Rina","Dian","Damar","Yoga","Tasya","Reno","Nisa","Hana","Farah",
                "Maul","Adit","Raka","Gilang","Bagas","Daffa","Irfan","Ilham","Lutfi","Hafiz"]
syllables_ln = ["Santoso","Pratama","Wijaya","Setiawan","Saputra","Hidayat","Wibowo","Hermawan","Nugroho","Kusuma",
                "Putra","Utama","Rahman","Siregar","Gunawan","Maulana","Ananda","Firmansyah","Syahputra","Halim",
                "Suhendra","Fauzan","Ramadhan","Permana","Prabowo","Mustofa","Nurdin","Firdaus","Harahap","Simanjuntak",
                "Suhartono","Kurniawan","Saputro","Prasetyo","Yulianto","Hartono","Susanto","Ardiansyah","Rohman","Wahyudi",
                "Subekti","Sugeng","Sulaiman","Mahendra","Cahyadi","Samsul","Kurnia","Arifin","Ridwan","Suharto"]

# Ensure at least 100 first and 100 last names by extending with indices
while len(syllables_fn) < 100:
    syllables_fn.append(f"Nama{len(syllables_fn)+1}")
while len(syllables_ln) < 100:
    syllables_ln.append(f"Keluarga{len(syllables_ln)+1}")

first_names = syllables_fn[:100]
last_names  = syllables_ln[:100]
full_name_pairs = list(itertools.islice(itertools.product(first_names, last_names), KARYAWAN_N))

# Products
bbm_list_raw = [
    "Pertalite","Pertamax","Pertamax Turbo","Solar","Bio Solar","Dexlite","Pertamina Dex","Premium","Diesel","Gasoline",
    "LPG 3kg","LPG 12kg","LPG 50kg","Oli Mesin Pertamina Fastron","Oli Enduro Racing","Oli Mesran Super",
    "Oli Shell Helix","Oli Top 1","Oli Castrol Power1","Oli Mobil Super","Oli Motul","Oli Yamalube","Oli AHM",
    "Oli Federal","Oli Suzuki Genuine","Grease Pelumas Rantai","Cairan Rem","Air Radiator Coolant","Minyak Rem DOT3",
    "Oli Transmisi","Oli Gardan","Oli Shockbreaker","Pembersih Karburator","LPG 5kg"
]
produk_list = list(dict.fromkeys(bbm_list_raw))

kode_jenis_map = {
    "Bahan Bakar Minyak (BBM)": "JN00001",
    "Gas & LPG": "JN00002",
    "Pelumas dan Oli": "JN00003"
}

def kategori_dan_satuan(nama):
    lower = nama.lower()
    if any(x in lower for x in ["pertalite","pertamax","turbo","solar","bio","dexlite","pertamina dex","premium","diesel","gasoline"]):
        return "Bahan Bakar Minyak (BBM)", "liter"
    if "lpg" in lower:
        return "Gas & LPG", "kg"
    return "Pelumas dan Oli", "ml"

def harga_beli_for(cat):
    if cat == "Bahan Bakar Minyak (BBM)": return round(random.uniform(8000,20000),2)
    if cat == "Gas & LPG": return round(random.uniform(15000,300000),2)
    return round(random.uniform(12000,200000),2)

with open(OUT, "w", encoding="utf-8") as f:
    f.write("-- SPBU DATASET (Jatim 8 kota — 1000 cabang, 10k pompa) \n\nBEGIN;\n\n")

    # Jabatan
    jabatan_rows = [f"('J{z(i)}','{role}','Deskripsi {role}')" for i, role in enumerate(jabatan_roles, 1)]
    write_insert_batches(f, "jabatan", jabatan_rows, batch_size=500)

    # SPBU (random kota)
    spbu_rows = []
    for i in range(1, SPBU_N + 1):
        kota = random.choice(CITIES)
        spbu_rows.append(f"('SP{z(i)}','SPBU {kota} #{i}','Jl. {kota} No.{i}','0812{random.randint(10000,99999)}','07:00-23:00')")
    write_insert_batches(f, "spbu_cabang", spbu_rows, batch_size=500)

    # Supplier
    supplier_rows = [f"('S{z(i)}','Supplier {i}','08{random.randint(10000000,99999999)}')" for i in range(1, SUPPLIER_N + 1)]
    write_insert_batches(f, "supplier", supplier_rows, batch_size=500)

    # Jenis
    jenis_rows = [("JN00001","Bahan Bakar Minyak (BBM)"),("JN00002","Gas & LPG"),("JN00003","Pelumas dan Oli")]
    jenis_rows = [f"('{k}','{v}')" for k,v in jenis_rows]
    write_insert_batches(f, "jenis", jenis_rows, batch_size=500)

    # Pompa
    pompa_rows = [f"('PM{z(i)}','Pompa {i}',{round(random.uniform(500,2000),2)},'aktif')" for i in range(1,PUMP_N+1)]
    write_insert_batches(f, "pompa", pompa_rows, batch_size=500)

    # Produk
    prod_rows = []
    for i, nama in enumerate(produk_list, 1):
        cat,sat = kategori_dan_satuan(nama)
        kode = kode_jenis_map[cat]
        id_pompa=f"PM{z(random.randint(1,PUMP_N))}"
        id_sup=f"S{z(random.randint(1,SUPPLIER_N))}"
        hbel = harga_beli_for(cat)
        prod_rows.append(f"('PR{z(i)}','{nama}','{kode}','{id_pompa}','{sat}',{hbel},'{id_sup}')")
    write_insert_batches(f, "produk", prod_rows, batch_size=500)

    # Harga (1 per produk)
    harga_rows = []
    for i in range(1,len(produk_list)+1):
        harga_akhir = round(random.uniform(9000,300000),2)
        tgl = random_date(start_date,end_date)
        harga_rows.append(f"('H{z(i)}','PR{z(i)}',{harga_akhir},'{tgl}')")
    write_insert_batches(f, "harga", harga_rows, batch_size=500)

    # Karyawan (4:1 operator-supervisor)
    karyawan_rows, operator_ids = [], []
    supervisor_count = max(1, KARYAWAN_N // 5)
    operator_count = KARYAWAN_N - supervisor_count
    roles = ["J00001"] * supervisor_count + ["J00002"] * operator_count
    random.shuffle(roles)

    for i, ((fn, ln), id_jab) in enumerate(zip(full_name_pairs, roles), 1):
        uname = f"user{z(i)}"
        pword = f"pass{z(i)}"
        id_sp = f"SP{z(random.randint(1, SPBU_N))}"
        karyawan_rows.append(f"('K{z(i)}','{fn}','{ln}','{uname}','{pword}','{id_jab}','{id_sp}')")
        if id_jab == "J00002":
            operator_ids.append(f"K{z(i)}")
    write_insert_batches(f, "karyawan", karyawan_rows, batch_size=500)

    # Kehadiran
    hadir_rows = []
    for i in range(1,KEHADIRAN_N+1):
        tgl=random_date(start_date,end_date)
        st=random.choice(["hadir","izin","sakit","alpa"])
        sh=random.choice(["pagi","siang","malam"])
        kid=f"K{z(random.randint(1,KARYAWAN_N))}"
        hadir_rows.append(f"('KH{z(i)}','{tgl}','{st}','{sh}','{kid}')")
    write_insert_batches(f, "kehadiran", hadir_rows, batch_size=500)

    # Produk cabang
    prodcab_rows = []
    for sp in range(1, SPBU_N+1):
        for pr in range(1, len(produk_list)+1):
            prodcab_rows.append(f"('PR{z(pr)}','SP{z(sp)}')")
    write_insert_batches(f, "produk_cabang", prodcab_rows, batch_size=500)

    # Pembelian
    pemb_rows=[]
    for i in range(1,PEMBELIAN_N+1):
        kid=f"K{z(random.randint(1,KARYAWAN_N))}"
        sid=f"S{z(random.randint(1,SUPPLIER_N))}"
        pid=f"PR{z(random.randint(1,len(produk_list)))}"
        stok=round(random.uniform(100,5000),2)
        harga_awal=round(random.uniform(7000,200000),2)
        tgl=random_date(start_date,end_date)
        pemb_rows.append(f"('PB{z(i)}','{kid}','{sid}','{pid}',{stok},{harga_awal},'{tgl}')")
    write_insert_batches(f, "pembelian", pemb_rows, batch_size=500)

    # Transaksi (operator only)
    trans_rows=[]
    for i in range(1,TRANSAKSI_N+1):
        kid=random.choice(operator_ids)
        hid_idx=random.randint(1,len(produk_list))
        pid=f"PR{z(hid_idx)}"; hid=f"H{z(hid_idx)}"
        qty=round(random.uniform(1,200),2)
        tstamp=random_date(start_date,end_date)+" 12:00:00"
        metode=random.choice(["cash","non-cash","qr","debit","kredit"])
        trans_rows.append(f"('TR{z(i)}','{metode}','{tstamp}','{kid}','{hid}','{pid}',{qty})")
    write_insert_batches(f, "transaksi", trans_rows, batch_size=500)

    f.write("COMMIT;\n")

print(f"✅ SQL generated: {OUT.resolve()}")
