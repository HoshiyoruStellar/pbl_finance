import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/kategori.dart';
import '../model/transaksi.dart';

class TransaksiUpdateForm extends StatefulWidget {
  const TransaksiUpdateForm({
    super.key,
    required this.transaksi,
    required this.kategori,
  });

  final Transaksi transaksi;
  final List<Kategori> kategori;

  @override
  State<TransaksiUpdateForm> createState() => _TransaksiUpdateFormState();
}

class _TransaksiUpdateFormState extends State<TransaksiUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulController;
  late final TextEditingController _nominalController;
  late final TextEditingController _tanggalController;
  late DateTime _tanggal;
  late int _kategoriId;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(
      text: widget.transaksi.judul_transaksi,
    );
    _nominalController = TextEditingController(
      text: widget.transaksi.nominal.toStringAsFixed(0),
    );
    _tanggal = widget.transaksi.tanggal;
    _tanggalController = TextEditingController(text: _formatTanggal(_tanggal));
    _kategoriId = widget.transaksi.kategori_id;
  }

  @override
  void dispose() {
    _judulController.dispose();
    _nominalController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  String _formatTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    return '$hari/$bulan/${tanggal.year}';
  }

  Future<void> _pilihTanggal() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _tanggal,
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
    Navigator.pop(
      context,
      Transaksi(
        id: widget.transaksi.id,
        judul_transaksi: _judulController.text.trim(),
        nominal: double.parse(_nominalController.text.trim()),
        tanggal: _tanggal,
        kategori_id: _kategoriId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubah Transaksi')),
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
              onChanged: (value) {
                if (value != null) setState(() => _kategoriId = value);
              },
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _simpan,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
