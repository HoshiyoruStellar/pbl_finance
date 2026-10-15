import 'package:flutter/material.dart';

import '../model/kategori.dart';
import 'kategori_update_form.dart';

class KategoriDetail extends StatelessWidget {
  const KategoriDetail({super.key, required this.kategori});

  final Kategori kategori;

  Future<void> _ubah(BuildContext context) async {
    final updated = await Navigator.of(context).push<Kategori>(
      MaterialPageRoute<Kategori>(
        builder: (_) => KategoriUpdateForm(kategori: kategori),
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
        title: const Text('Hapus kategori?'),
        content: Text('Kategori "${kategori.nama_kategori}" akan dihapus.'),
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
      appBar: AppBar(title: const Text('Detail Kategori')),
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
                    Text('Nama kategori', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Text(
                      kategori.nama_kategori,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    Text('Tipe transaksi', style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(height: 6),
                    Text(kategori.tipe_transaksi),
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
