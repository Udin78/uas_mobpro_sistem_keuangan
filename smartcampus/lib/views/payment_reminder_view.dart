import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampus/controllers/bayar_controller.dart';
import 'package:smartcampus/models/tagihan_model.dart';

class PaymentReminderView extends StatelessWidget {
  final BayarController controller = Get.put(BayarController());

  @override
  Widget build(BuildContext context) {
    controller.getTagihanBelumLunas(); // Fetch unpaid bills

    return Scaffold(
      appBar: AppBar(
        title: Text('Pengingat Pembayaran'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.tagihanBelumLunas.isEmpty) {
          return Center(child: Text('Tidak ada tagihan yang perlu dibayar.'));
        } else {
          return ListView.builder(
            itemCount: controller.tagihanBelumLunas.length,
            itemBuilder: (context, index) {
              final tagihan = controller.tagihanBelumLunas[index];
              return Card(
                child: ListTile(
                  title: Text(tagihan.namaTagihan ?? 'Nama tagihan tidak tersedia'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah: Rp ${tagihan.jumlahTagihan?.toString() ?? '0'}'),
                      Text('Tanggal Tagihan: ${tagihan.tanggalTagihan ?? ''}'),
                      Text('Status: ${tagihan.status ?? ''}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.notifications, color: Colors.red),
                    onPressed: () {
                      _showReminderNotification(tagihan);
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  // Fungsi untuk menampilkan notifikasi pengingat
  void _showReminderNotification(TagihanModel tagihan) {
    Get.snackbar(
      'Pengingat Pembayaran',
      'Tagihan "${tagihan.namaTagihan}" sebesar Rp ${tagihan.jumlahTagihan} belum dibayar. Harap segera lakukan pembayaran!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 5),
    );
  }
}
