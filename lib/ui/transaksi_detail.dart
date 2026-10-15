import 'package:flutter/material.dart';

import '../model/kategori.dart';
import '../model/transaksi.dart';
import 'transaksi_update_form.dart';

class TransaksiDetail extends StatelessWidget {
  const TransaksiDetail({
    super.key,
    required this.transaksi,
    required this.namaKategori,
    required this.kategori,
  });

  final Transaksi transaksi;
  final String namaKategori;
  final List<Kategori> kategori;

  String _formatTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${tanggal.year}';
  }

  Future<void> _ubah(BuildContext context) async {
    final updated = await Navigator.of(context).push<Transaksi>(
      MaterialPageRoute<Transaksi>(
        builder: (_) => TransaksiUpdateForm(
          transaksi: transaksi,
          kategori: kategori,
        ),
      ),
    );
    if (context.mounted && updated != null) {
      Navigator.pop(context, updated);
    }
  }

  Future<void> _hapus(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus transaksi?'),
        content: Text('Transaksi "${transaksi.judul_transaksi}" akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (context.mounted && confirmed == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Transaksi')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Judul transaksi', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Text(
                      transaksi.judul_transaksi,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    Text('Nominal', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Text('Rp ${transaksi.nominal.toStringAsFixed(0)}'),
                    const SizedBox(height: 16),
                    Text('Tanggal', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Text(_formatTanggal(transaksi.tanggal)),
                    const SizedBox(height: 16),
                    Text('Kategori', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Text(namaKategori),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => _ubah(context),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Ubah'),
            ),
            OutlinedButton.icon(
              onPressed: () => _hapus(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Hapus'),
            ),
          ],
        ),
      ),
    );
  }
}
