import 'package:flutter/material.dart';

import '../model/kategori.dart';
import '../model/transaksi.dart';
import '../widget/sidebar.dart';
import 'transaksi_detail.dart';
import 'transaksi_form.dart';
import 'transaksi_item.dart';

class TransaksiPage extends StatefulWidget {
  const TransaksiPage({super.key});

  @override
  State<TransaksiPage> createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  final List<Kategori> _kategori = const [
    Kategori(id: 1, nama_kategori: 'Makanan', tipe_transaksi: 'Pengeluaran'),
    Kategori(id: 2, nama_kategori: 'Gaji', tipe_transaksi: 'Pemasukan'),
    Kategori(id: 3, nama_kategori: 'Transport', tipe_transaksi: 'Pengeluaran'),
  ];

  final List<Transaksi> _transaksi = [
    Transaksi(
      id: 1,
      judul_transaksi: 'Makan siang',
      nominal: 35000,
      tanggal: DateTime(2026, 10, 14),
      kategori_id: 1,
    ),
    Transaksi(
      id: 2,
      judul_transaksi: 'Gaji bulanan',
      nominal: 5000000,
      tanggal: DateTime(2026, 10, 1),
      kategori_id: 2,
    ),
    Transaksi(
      id: 3,
      judul_transaksi: 'Ongkos perjalanan',
      nominal: 15000,
      tanggal: DateTime(2026, 10, 13),
      kategori_id: 3,
    ),
  ];

  String _namaKategori(int id) {
    for (final kategori in _kategori) {
      if (kategori.id == id) return kategori.nama_kategori;
    }
    return 'Kategori tidak ditemukan';
  }

  Future<void> _tambahTransaksi() async {
    final transaksi = await Navigator.of(context).push<Transaksi>(
      MaterialPageRoute<Transaksi>(
        builder: (_) => TransaksiForm(kategori: _kategori),
      ),
    );
    if (transaksi != null && mounted) {
      setState(() => _transaksi.add(transaksi));
    }
  }

  Future<void> _bukaDetail(Transaksi transaksi) async {
    final result = await Navigator.of(context).push<Object>(
      MaterialPageRoute<Object>(
        builder: (_) => TransaksiDetail(
          transaksi: transaksi,
          namaKategori: _namaKategori(transaksi.kategori_id),
          kategori: _kategori,
        ),
      ),
    );
    if (!mounted) return;

    if (result == true) {
      setState(() => _transaksi.removeWhere((item) => item.id == transaksi.id));
    } else if (result is Transaksi) {
      final index = _transaksi.indexWhere((item) => item.id == result.id);
      if (index != -1) setState(() => _transaksi[index] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi')),
      drawer: const Sidebar(currentPage: 'Transaksi'),
      body: _transaksi.isEmpty
          ? const Center(
              child: Text('Belum ada transaksi. Tambahkan transaksi baru.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _transaksi.length,
              itemBuilder: (context, index) {
                final transaksi = _transaksi[index];
                return TransaksiItem(
                  transaksi: transaksi,
                  namaKategori: _namaKategori(transaksi.kategori_id),
                  onTap: () => _bukaDetail(transaksi),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahTransaksi,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Transaksi'),
      ),
    );
  }
}
