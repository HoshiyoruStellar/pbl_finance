class Transaksi {
  const Transaksi({
    required this.id,
    required this.judul_transaksi,
    required this.nominal,
    required this.tanggal,
    required this.kategori_id,
  });

  final int id;
  final String judul_transaksi;
  final double nominal;
  final DateTime tanggal;
  final int kategori_id;
}
