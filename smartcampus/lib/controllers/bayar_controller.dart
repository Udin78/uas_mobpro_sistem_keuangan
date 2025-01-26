import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:smartcampus/models/tagihan_model.dart';
import 'dart:io';

class BayarController extends GetxController {
  final tagihanBelumLunas = <TagihanModel>[].obs;
  final isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getTagihanBelumLunas() async {
    isLoading(true);
    try {
      var snapshot = await _firestore
          .collection('tagihan')
          .where('status', isEqualTo: 'Belum Lunas')
          .get();
      tagihanBelumLunas.value = snapshot.docs.map((doc) {
        return TagihanModel.fromMap(
          doc.data() as Map<String, dynamic>,
          id: doc.id,
        );
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data tagihan: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> bayarTagihan(
      TagihanModel tagihan,
      String metodePembayaran,
      String detailPembayaran, {
        String? imageUrl,
      }) async {
    if (metodePembayaran.isEmpty || detailPembayaran.isEmpty) {
      Get.snackbar('Error', 'Metode pembayaran dan detail pembayaran tidak boleh kosong.');
      return;
    }
    try {
      final doc = await _firestore.collection('tagihan').doc(tagihan.id).get();
      if (doc.exists) {
        final tanggalPembayaran = DateTime.now().toIso8601String();
        await _firestore.collection('tagihan').doc(tagihan.id).update({
          'status': 'Lunas',
          'metodePembayaran': metodePembayaran,
          'detailPembayaran': detailPembayaran,
          'tanggalPembayaran': tanggalPembayaran,
          if (imageUrl != null) 'buktiTransfer': imageUrl,
        });
        tagihanBelumLunas.removeWhere((item) => item.id == tagihan.id);
        Get.snackbar('Sukses', 'Tagihan berhasil dibayar menggunakan $metodePembayaran.');
      } else {
        Get.snackbar('Error', 'Tagihan tidak ditemukan.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal membayar tagihan: ${e.toString()}');
    }
  }
}
