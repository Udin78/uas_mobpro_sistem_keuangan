import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcampus/models/tagihan_model.dart';

class RiwayatPembayaranController extends GetxController {
  final riwayatPembayaran = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getTagihan() async {
    isLoading(true);
    try {
      var snapshot = await _firestore.collection('tagihan').get();
      riwayatPembayaran.value = snapshot.docs
          .where((doc) => doc.exists)
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((tagihan) => tagihan['status'] == 'Lunas')
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil riwayat pembayaran: $e');
    } finally {
      isLoading(false);
    }
  }
}
