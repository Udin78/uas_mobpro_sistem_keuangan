import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampus/controllers/riwayat_pembayaran_controller.dart';
import 'package:smartcampus/views/invoice_view.dart';
import 'package:smartcampus/models/tagihan_model.dart';

class RiwayatPembayaranView extends StatelessWidget {
  final RiwayatPembayaranController controller = Get.put(RiwayatPembayaranController());

  @override
  Widget build(BuildContext context) {
    controller.getTagihan();
    return Scaffold(
        appBar: AppBar(
          title: Text('Riwayat Pembayaran'),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (controller.riwayatPembayaran.isEmpty) {
            return Center(child: Text('Belum ada riwayat pembayaran.'));
          } else {
            final lunasTagihan = controller.riwayatPembayaran
                .where((tagihan) => tagihan['status'] == 'Lunas')
                .toList();

            if (lunasTagihan.isEmpty) {
              return Center(child: Text('Belum ada tagihan yang lunas.'));
            }

            return ListView.builder(
              itemCount: lunasTagihan.length,
              itemBuilder: (context, index) {
                final riwayat = lunasTagihan[index];
                final tagihan = TagihanModel.fromMap(riwayat);

                return Card(
                  child: ListTile(
                    title: Text('${tagihan.namaTagihan ?? 'Nama tagihan tidak tersedia'}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jumlah: Rp ${tagihan.jumlahTagihan.toString() ?? '0'}'),
                        Text('Tanggal Tagihan: ${tagihan.tanggalTagihan ?? 'Tanggal tagihan tidak tersedia'}'),
                        Text('Status Pembayaran: ${tagihan.status ?? 'Status tidak tersedia'}'),
                        Text('Tanggal Pembayaran: ${tagihan.tanggalPembayaran ?? 'Tanggal pembayaran tidak tersedia'}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.receipt),
                      onPressed: () {
                        Get.to(() => InvoiceView(tagihan: tagihan));
                      },
                      tooltip: 'Cetak Invoice',
                    ),
                  ),
                );
              },
            );
          }
        }),
    );
  }
}
