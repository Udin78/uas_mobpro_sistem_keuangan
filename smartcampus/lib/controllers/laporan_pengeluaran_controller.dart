import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartcampus/models/laporan_pengeluaran_model.dart';

class LaporanPengeluaranController extends GetxController {
  var laporanPengeluaranList = <LaporanPengeluaranModel>[].obs;
  var isLoading = false.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    getLaporanPengeluaran(); // Load data saat controller diinisialisasi
  }

  // Ambil semua laporan pengeluaran dari Firestore
  Future<void> getLaporanPengeluaran() async {
    isLoading(true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        var snapshot = await _firestore
            .collection('pengeluaran')
            .where('dosenId', isEqualTo: user.uid)
            .get();

        var data = snapshot.docs.map((doc) {
          return LaporanPengeluaranModel.fromMap(
            doc.data() as Map<String, dynamic>,
            id: doc.id,
          );
        }).toList();

        laporanPengeluaranList.value = data;
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat laporan pengeluaran: $e');
    } finally {
      isLoading(false);
    }
  }

  // Tambah pengeluaran baru
  Future<void> addPengeluaran(LaporanPengeluaranModel pengeluaran) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        pengeluaran.id = user.uid; // Tambahkan ID dosen
        var docRef = await _firestore.collection('pengeluaran').add(pengeluaran.toMap());
        pengeluaran.id = docRef.id; // Update ID berdasarkan Firestore
        laporanPengeluaranList.add(pengeluaran); // Tambahkan ke daftar
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah pengeluaran: $e');
    }
  }
}
