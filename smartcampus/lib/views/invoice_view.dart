import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:smartcampus/models/tagihan_model.dart';

class InvoiceView extends StatelessWidget {
  final TagihanModel tagihan;

  InvoiceView({required this.tagihan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice Tagihan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'BUKTI PEMBAYARAN',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text('ID Tagihan: ${tagihan.id ?? "Tidak tersedia"}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Nama Tagihan: ${tagihan.namaTagihan}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Jumlah Tagihan: Rp ${tagihan.jumlahTagihan}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Tanggal Tagihan: ${tagihan.tanggalTagihan}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Status: ${tagihan.status ?? "Belum dibayar"}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  _printPdf(tagihan);
                },
                icon: Icon(Icons.print),
                label: Text('Cetak / Simpan Invoice'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Fungsi untuk membuat dokumen PDF
  Future<Uint8List> _generatePDF(TagihanModel tagihan) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'BUKTI PEMBAYARAN',
                  style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('ID Tagihan: ${tagihan.id ?? "Tidak tersedia"}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Nama Tagihan: ${tagihan.namaTagihan}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Jumlah Tagihan: Rp ${tagihan.jumlahTagihan}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Tanggal Tagihan: ${tagihan.tanggalTagihan}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.Text('Status: ${tagihan.status ?? "Belum dibayar"}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
// Menambahkan Tanggal Pembayaran
              pw.Text('Tanggal Pembayaran: ${tagihan.tanggalPembayaran ?? "Belum dibayar"}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Terima kasih atas pembayaran Anda!',
                  style: pw.TextStyle(fontSize: 14),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Fungsi untuk mencetak atau menyimpan PDF
  void _printPdf(TagihanModel tagihan) async {
    try {
      // Generate PDF dalam format Uint8List
      final pdfData = await _generatePDF(tagihan);

      // Tampilkan dialog cetak atau simpan
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfData,
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text("Gagal mencetak PDF: $e")),
      );
    }
  }
}
