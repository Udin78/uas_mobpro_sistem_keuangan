import 'package:cloud_firestore/cloud_firestore.dart';

class LaporanPengeluaranModel {
  String? id;
  String? namaPengeluaran;
  double? jumlahPengeluaran;
  String? tanggalPengeluaran;

  LaporanPengeluaranModel({
    this.id,
    this.namaPengeluaran,
    this.jumlahPengeluaran,
    this.tanggalPengeluaran,
  });

  factory LaporanPengeluaranModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return LaporanPengeluaranModel(
      id: id ?? map['id'], // Ambil id jika ada
      namaPengeluaran: map['namaPengeluaran'],
      jumlahPengeluaran: map['jumlahPengeluaran']?.toDouble(),
      tanggalPengeluaran: map['tanggalPengeluaran'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'namaPengeluaran': namaPengeluaran,
      'jumlahPengeluaran': jumlahPengeluaran,
      'tanggalPengeluaran': tanggalPengeluaran,
    };
  }
}
