import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampus/controllers/tagihan_controller.dart';
import 'package:smartcampus/views/riwayat_pembayaran_view.dart';

class TagihanView extends StatefulWidget {
  @override
  _TagihanViewState createState() => _TagihanViewState();
}

class _TagihanViewState extends State<TagihanView> {
  final TagihanController controller = Get.put(TagihanController());

  @override
  void initState() {
    super.initState();
    controller.getTagihan(); // Mengambil semua tagihan, termasuk yang sudah lunas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tagihan'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              // Navigasi ke RiwayatPembayaranView
              Get.to(() => RiwayatPembayaranView());
            },
            tooltip: 'Riwayat Pembayaran',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else {
          // Filter tagihan yang belum lunas
          var tagihanBelumLunas = controller.tagihanList
              .where((tagihan) => tagihan.status == 'Belum Lunas')
              .toList();

          if (tagihanBelumLunas.isEmpty) {
            return Center(child: Text('Tidak ada tagihan yang perlu dibayar.'));
          } else {
            return ListView.builder(
              itemCount: tagihanBelumLunas.length,
              itemBuilder: (context, index) {
                final tagihan = tagihanBelumLunas[index];
                return Card(
                  child: ListTile(
                    title: Text(tagihan.namaTagihan ?? ''),
                    subtitle: Text(
                      'Rp ${tagihan.jumlahTagihan?.toString() ?? '0'}',
                    ),
                    trailing: Text(tagihan.tanggalTagihan ?? ''),
                  ),
                );
              },
            );
          }
        }
      }),
    );
  }
}
