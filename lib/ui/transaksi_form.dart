import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/kategori.dart';
import '../model/transaksi.dart';

class TransaksiForm extends StatefulWidget {
  const TransaksiForm({super.key, required this.kategori});

  final List<Kategori> kategori;

  @override
  State<TransaksiForm> createState() => _TransaksiFormState();
}

class _TransaksiFormState extends State<TransaksiForm> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _nominalController = TextEditingController();
  final _tanggalController = TextEditingController();
  DateTime? _tanggal;
  int? _kategoriId;

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime? tanggal) {
    if (tanggal == null) return '';
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${tanggal.year}';
  }

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _tanggal ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 10),
    );
    if (selected != null) {
      setState(() {
        _tanggal = selected;
        _tanggalController.text = _formatTanggal(selected);
      });
    }
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;
    if (_tanggal == null || _kategoriId == null) return;
    Navigator.pop(
      context,
      Transaksi(
        id: DateTime.now().microsecondsSinceEpoch,
        judul_transaksi: _judulController.text.trim(),
        nominal: double.parse(_nominalController.text.trim()),
        tanggal: _tanggal!,
        kategori_id: _kategoriId!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Transaksi')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulController,
              decoration: const InputDecoration(labelText: 'Judul transaksi'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Judul transaksi wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nominalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: const InputDecoration(
                labelText: 'Nominal',
                prefixText: 'Rp ',
              ),
              validator: (value) {
                final nominal = double.tryParse(value?.trim() ?? '');
                if (nominal == null || nominal <= 0) {
                  return 'Masukkan nominal yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              readOnly: true,
              controller: _tanggalController,
              decoration: const InputDecoration(
                labelText: 'Tanggal',
                suffixIcon: Icon(Icons.calendar_month_outlined),
              ),
              onTap: _pilihTanggal,
              validator: (_) => _tanggal == null ? 'Tanggal wajib dipilih' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: _kategoriId,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: widget.kategori
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.nama_kategori),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _kategoriId = value),
              validator: (value) => value == null ? 'Kategori wajib dipilih' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _simpan, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
