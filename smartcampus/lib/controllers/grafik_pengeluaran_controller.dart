import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartcampus/controllers/riwayat_pembayaran_controller.dart';
import 'package:smartcampus/models/tagihan_model.dart';

class GrafikPengeluaranController extends GetxController {
  var isLoading = true.obs;
  var chartData = <FlSpot>[].obs;
  final RiwayatPembayaranController riwayatPembayaranController = Get.put(RiwayatPembayaranController());

  @override
  void onInit() {
    super.onInit();
    getGrafikPengeluaran();
  }

  Future<void> getGrafikPengeluaran() async {
    try {
      isLoading(true);
      await riwayatPembayaranController.getTagihan();
      _processChartData();
    } finally {
      isLoading(false);
    }
  }

  void _processChartData() {
    var lunasTagihan = riwayatPembayaranController.riwayatPembayaran
        .where((tagihan) => tagihan['status'] == 'Lunas')
        .toList();

    chartData.assignAll(lunasTagihan.map((tagihan) {
      DateTime tanggalPembayaran = DateTime.tryParse(tagihan['tanggalPembayaran'] ?? '') ?? DateTime(2000, 1, 1);
      return FlSpot(
        tanggalPembayaran.millisecondsSinceEpoch.toDouble(),
        (tagihan['jumlahTagihan']?.toDouble() ?? 0),
      );
    }).toList());
  }
}
