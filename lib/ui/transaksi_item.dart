import 'package:flutter/material.dart';

import '../model/transaksi.dart';

class TransaksiItem extends StatelessWidget {
  const TransaksiItem({
    super.key,
    required this.transaksi,
    required this.namaKategori,
    required this.onTap,
  });

  final Transaksi transaksi;
  final String namaKategori;
  final VoidCallback onTap;

  String _formatTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.receipt_long_outlined)),
        title: Text(
          transaksi.judul_transaksi,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('$namaKategori • ${_formatTanggal(transaksi.tanggal)}'),
        trailing: Text(
          'Rp ${transaksi.nominal.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      ),
    );
  }
}
