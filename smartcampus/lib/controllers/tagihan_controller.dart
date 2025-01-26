import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartcampus/models/tagihan_model.dart';

class TagihanController extends GetxController {
  final tagihanList = <TagihanModel>[].obs; // Daftar tagihan
  final riwayatList = <TagihanModel>[].obs; // Daftar riwayat pembayaran
  final isLoading = false.obs; // Status loading
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    getTagihan();
    getRiwayatPembayaran();
  }

  /// Mengambil daftar tagihan
  Future<void> getTagihan() async {
    isLoading(true);
    try {
      var snapshot = await _firestore.collection('tagihan').get();
      tagihanList.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return TagihanModel.fromMap(data, id: doc.id); // Pastikan `id` disertakan
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat tagihan: $e');
    } finally {
      isLoading(false);
    }
  }

  /// Menambahkan tagihan baru
  Future<void> tambahTagihan(TagihanModel tagihan) async {
    try {
      // Tambahkan dokumen baru ke koleksi
      final docRef = await _firestore.collection('tagihan').add(tagihan.toMap());
      // Perbarui dokumen dengan ID otomatis
      await _firestore.collection('tagihan').doc(docRef.id).update({'id': docRef.id});
      // Simpan ID ke dalam objek lokal
      tagihan.id = docRef.id;
      tagihanList.add(tagihan);
      Get.snackbar('Success', 'Tagihan berhasil ditambahkan.');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah tagihan: $e');
    }
  }

  /// Membayar tagihan
  Future<void> bayarTagihan(TagihanModel tagihan) async {
    try {
      if (tagihan.id != null) {
        // Update status tagihan di Firestore
        await _firestore.collection('tagihan').doc(tagihan.id).update({
          'status': 'Lunas',
        });

        // Hapus tagihan dari koleksi `tagihan`
        await _firestore.collection('tagihan').doc(tagihan.id).delete();

        // Perbarui daftar lokal
        tagihanList.removeWhere((t) => t.id == tagihan.id);

        // Tambahkan ke riwayat pembayaran
        final riwayat = TagihanModel(
          id: tagihan.id!,
          namaTagihan: tagihan.namaTagihan!,
          jumlahTagihan: tagihan.jumlahTagihan!,
          tanggalTagihan: DateTime.now().toString(),
          status: 'Sukses',
          tanggalPembayaran: DateTime.now().toString(),
        );
        await _firestore.collection('riwayat_pembayaran').add(riwayat.toMap());

        Get.snackbar('Success', 'Tagihan berhasil dibayar dan dipindahkan ke riwayat.');
      } else {
        Get.snackbar('Error', 'ID Tagihan tidak ditemukan.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal membayar tagihan: $e');
    }
  }

  /// Mengambil riwayat pembayaran
  Future<void> getRiwayatPembayaran() async {
    isLoading(true);
    try {
      var snapshot = await _firestore.collection('riwayat_pembayaran').get();
      riwayatList.value = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return TagihanModel.fromMap(data, id: doc.id);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat pembayaran: $e');
    } finally {
      isLoading(false);
    }
  }
}
