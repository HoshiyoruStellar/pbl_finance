import 'package:flutter/material.dart';

import '../model/kategori.dart';
import '../widget/sidebar.dart';
import 'kategori_detail.dart';
import 'kategori_form.dart';
import 'kategori_item.dart';

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  final List<Kategori> _kategori = [
    const Kategori(
      id: 1,
      nama_kategori: 'Makanan',
      tipe_transaksi: 'Pengeluaran',
    ),
    const Kategori(
      id: 2,
      nama_kategori: 'Gaji',
      tipe_transaksi: 'Pemasukan',
    ),
    const Kategori(
      id: 3,
      nama_kategori: 'Transport',
      tipe_transaksi: 'Pengeluaran',
    ),
  ];

  Future<void> _tambahKategori() async {
    final kategori = await Navigator.of(context).push<Kategori>(
      MaterialPageRoute<Kategori>(builder: (_) => const KategoriForm()),
    );
    if (kategori != null && mounted) {
      setState(() => _kategori.add(kategori));
    }
  }

  Future<void> _bukaDetail(Kategori kategori) async {
    final result = await Navigator.of(context).push<Object>(
      MaterialPageRoute<Object>(
        builder: (_) => KategoriDetail(kategori: kategori),
      ),
    );
    if (!mounted) return;

    if (result == true) {
      setState(() => _kategori.removeWhere((item) => item.id == kategori.id));
    } else if (result is Kategori) {
      final index = _kategori.indexWhere((item) => item.id == result.id);
      if (index != -1) setState(() => _kategori[index] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori')),
      drawer: const Sidebar(currentPage: 'Kategori'),
      body: _kategori.isEmpty
          ? const Center(child: Text('Belum ada kategori. Tambahkan kategori baru.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _kategori.length,
              itemBuilder: (context, index) => KategoriItem(
                kategori: _kategori[index],
                onTap: () => _bukaDetail(_kategori[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahKategori,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Kategori'),
      ),
    );
  }
}
