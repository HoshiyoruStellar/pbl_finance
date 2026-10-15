import 'package:flutter/material.dart';

import '../ui/beranda.dart';
import '../ui/kategori_page.dart';
import '../ui/login.dart';
import '../ui/transaksi_page.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key, this.currentPage = ''});

  final String currentPage;

  void _navigate(BuildContext context, String page) {
    Navigator.pop(context);
    if (page == currentPage) return;

    final destination = switch (page) {
      'Beranda' => const BerandaPage(),
      'Kategori' => const KategoriPage(),
      'Transaksi' => const TransaksiPage(),
      _ => null,
    };
    if (destination == null) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => destination),
    );
  }

  void _showProfile(BuildContext context) {
    Navigator.pop(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profil'),
        content: const Text('Profil pengguna belum tersedia pada demo statis.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'PBL Finance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            _menuItem(context, 'Beranda', Icons.home_outlined),
            _menuItem(context, 'Kategori', Icons.category_outlined),
            _menuItem(context, 'Transaksi', Icons.receipt_long_outlined),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Profil'),
              onTap: () => _showProfile(context),
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Keluar'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String page, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(page),
      selected: currentPage == page,
      onTap: () => _navigate(context, page),
    );
  }
}
