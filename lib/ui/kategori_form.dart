import 'package:flutter/material.dart';

import '../model/kategori.dart';

class KategoriForm extends StatefulWidget {
  const KategoriForm({super.key});

  @override
  State<KategoriForm> createState() => _KategoriFormState();
}

class _KategoriFormState extends State<KategoriForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  String _tipeTransaksi = 'Pengeluaran';

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Kategori(
        id: DateTime.now().microsecondsSinceEpoch,
        nama_kategori: _namaController.text.trim(),
        tipe_transaksi: _tipeTransaksi,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kategori')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama kategori'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama kategori wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _tipeTransaksi,
              decoration: const InputDecoration(labelText: 'Tipe transaksi'),
              items: const [
                DropdownMenuItem(value: 'Pengeluaran', child: Text('Pengeluaran')),
                DropdownMenuItem(value: 'Pemasukan', child: Text('Pemasukan')),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _tipeTransaksi = value);
              },
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _simpan, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
