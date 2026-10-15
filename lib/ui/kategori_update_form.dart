import 'package:flutter/material.dart';

import '../model/kategori.dart';

class KategoriUpdateForm extends StatefulWidget {
  const KategoriUpdateForm({super.key, required this.kategori});

  final Kategori kategori;

  @override
  State<KategoriUpdateForm> createState() => _KategoriUpdateFormState();
}

class _KategoriUpdateFormState extends State<KategoriUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late String _tipeTransaksi;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(
      text: widget.kategori.nama_kategori,
    );
    _tipeTransaksi = widget.kategori.tipe_transaksi;
  }

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
        id: widget.kategori.id,
        nama_kategori: _namaController.text.trim(),
        tipe_transaksi: _tipeTransaksi,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Kategori')),
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
            FilledButton(onPressed: _simpan, child: const Text('Simpan Perubahan')),
          ],
        ),
      ),
    );
  }
}
