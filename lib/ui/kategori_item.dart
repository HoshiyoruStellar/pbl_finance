import 'package:flutter/material.dart';

import '../model/kategori.dart';

class KategoriItem extends StatelessWidget {
  const KategoriItem({
    super.key,
    required this.kategori,
    required this.onTap,
  });

  final Kategori kategori;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPemasukan = kategori.tipe_transaksi == 'Pemasukan';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPemasukan
              ? Colors.green.withValues(alpha: 0.12)
              : Colors.orange.withValues(alpha: 0.12),
          child: Icon(
            isPemasukan ? Icons.south_west : Icons.north_east,
            color: isPemasukan ? Colors.green.shade700 : Colors.orange.shade800,
          ),
        ),
        title: Text(
          kategori.nama_kategori,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(kategori.tipe_transaksi),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
