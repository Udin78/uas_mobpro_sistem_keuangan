import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampus/controllers/tagihan_controller.dart';
import 'package:smartcampus/models/tagihan_model.dart';

class AddBillView extends StatefulWidget {
  @override
  _AddBillViewState createState() => _AddBillViewState();
}

class _AddBillViewState extends State<AddBillView> {
  final TagihanController controller = Get.put(TagihanController());

  final _namaTagihanController = TextEditingController();
  final _jumlahTagihanController = TextEditingController();
  final _tanggalTagihanController = TextEditingController();

  // Validasi input form
  bool _validateInput() {
    if (_namaTagihanController.text.isEmpty ||
        _jumlahTagihanController.text.isEmpty ||
        _tanggalTagihanController.text.isEmpty) {
      Get.snackbar('Error', 'Semua kolom harus diisi.');
      return false;
    }
    return true;
  }

  // Bersihkan input form
  void _clearInputFields() {
    _namaTagihanController.clear();
    _jumlahTagihanController.clear();
    _tanggalTagihanController.clear();
  }

  // Menambahkan tagihan ke database
  Future<void> _addTagihan() async {
    if (_validateInput()) {
      TagihanModel tagihan = TagihanModel(
        namaTagihan: _namaTagihanController.text,
        jumlahTagihan: int.parse(_jumlahTagihanController.text),
        tanggalTagihan: _tanggalTagihanController.text,
      );
      await controller.tambahTagihan(tagihan);
      _clearInputFields();
      Get.snackbar('Sukses', 'Tagihan berhasil ditambahkan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tambah Tagihan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _namaTagihanController,
              decoration: InputDecoration(labelText: 'Nama Tagihan'),
            ),
            TextFormField(
              controller: _jumlahTagihanController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Jumlah Tagihan'),
            ),
            TextFormField(
              controller: _tanggalTagihanController,
              decoration: InputDecoration(labelText: 'Tanggal Tagihan'),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  _tanggalTagihanController.text =
                  "${selectedDate.day.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.year}";
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTagihan,
              child: Text('Tambah Tagihan'),
            ),
          ],
        ),
      ),
    );
  }
}
