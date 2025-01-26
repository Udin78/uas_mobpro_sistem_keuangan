import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampus/controllers/laporan_pengeluaran_controller.dart';
import 'package:smartcampus/models/laporan_pengeluaran_model.dart';

class LaporanPengeluaranView extends StatelessWidget {
  final LaporanPengeluaranController _controller = Get.put(LaporanPengeluaranController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Pengeluaran Pribadi'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_controller.laporanPengeluaranList.isEmpty) {
          return Center(child: Text('Tidak ada pengeluaran yang tercatat.'));
        } else {
          return ListView.builder(
            itemCount: _controller.laporanPengeluaranList.length,
            itemBuilder: (context, index) {
              var laporan = _controller.laporanPengeluaranList[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(laporan.namaPengeluaran ?? 'Nama Pengeluaran'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${laporan.tanggalPengeluaran ?? 'Tanggal Tidak Tersedia'}'),
                      Text('Jumlah: Rp. ${laporan.jumlahPengeluaran?.toStringAsFixed(2) ?? '0.00'}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddPengeluaranDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Dialog untuk menambah pengeluaran
  void _showAddPengeluaranDialog(BuildContext context) {
    TextEditingController namaController = TextEditingController();
    TextEditingController jumlahController = TextEditingController();
    TextEditingController tanggalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Pengeluaran'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Pengeluaran'),
              ),
              TextField(
                controller: jumlahController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Jumlah Pengeluaran'),
              ),
              TextField(
                controller: tanggalController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Pengeluaran',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    tanggalController.text = "${pickedDate.toLocal()}".split(' ')[0];
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                var pengeluaran = LaporanPengeluaranModel(
                  namaPengeluaran: namaController.text,
                  jumlahPengeluaran: double.tryParse(jumlahController.text) ?? 0.0,
                  tanggalPengeluaran: tanggalController.text,
                );
                _controller.addPengeluaran(pengeluaran);
                Get.back();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
