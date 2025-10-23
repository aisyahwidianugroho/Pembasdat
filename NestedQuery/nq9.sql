SELECT nama_supplier, total_cabang
FROM (
    SELECT s.id_supplier, s.nama_supplier, COUNT(DISTINCT p.id_pompa) AS total_cabang
    FROM supplier s
    JOIN produk p ON p.id_supplier = s.id_supplier
    GROUP BY s.id_supplier, s.nama_supplier
) AS coverage
ORDER BY total_cabang DESC
LIMIT 5;