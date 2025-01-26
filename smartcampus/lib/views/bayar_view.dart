import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartcampus/controllers/bayar_controller.dart';
import 'package:smartcampus/models/tagihan_model.dart';
import 'package:smartcampus/views/grafik_pengeluaran_view.dart';
import 'package:smartcampus/views/payment_reminder_view.dart';
import 'package:smartcampus/views/budget_planning_view.dart';

class BayarView extends StatefulWidget {
  @override
  _BayarViewState createState() => _BayarViewState();
}

class _BayarViewState extends State<BayarView> with SingleTickerProviderStateMixin {
  final BayarController controller = Get.put(BayarController());
  String selectedPaymentMethod = 'Transfer Bank';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    controller.getTagihanBelumLunas();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Keuangan'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Bayar Tagihan'),
            Tab(text: 'Laporan Finansial'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBayarTagihan(),
          _buildFinansialReport(),
        ],
      ),
    );
  }

  Widget _buildBayarTagihan() {
    return Obx(() {
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
                title: Text(tagihan.namaTagihan ?? ''),
                subtitle: Text(
                    'Rp ${tagihan.jumlahTagihan?.toString() ?? '0'}'),
                trailing: Text(tagihan.tanggalTagihan ?? ''),
                onTap: () {
                  _confirmBayarDialog(tagihan);
                },
              ),
            );
          },
        );
      }
    });
  }

  Widget _buildFinansialReport() {
    return ListView(
      children: [
        ListTile(
          title: Text('Grafik Pengeluaran'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GrafikPengeluaranView()),
            );
          },
        ),
        ListTile(
          title: Text('Pengingat Pembayaran'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PaymentReminderView()),
            );
          },
        ),
        ListTile(
          title: Text('Perencanaan Anggaran'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BudgetPlanningView()),
            );
          },
        ),
      ],
    );
  }

  void _confirmBayarDialog(TagihanModel tagihan) {
    String selectedPaymentMethod = 'Transfer Bank';
    String detailPembayaran = '';
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Konfirmasi Pembayaran'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apakah Anda yakin ingin membayar tagihan "${tagihan.namaTagihan}" sebesar Rp ${tagihan.jumlahTagihan}?',
                  ),
                  SizedBox(height: 16),
                  Text('Pilih Metode Pembayaran:'),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedPaymentMethod = 'Transfer Bank';
                            detailPembayaran = 'Bank BRI, No. Rekening: 0023 0113 1577 500, A.N: Muhammad Syarifuddin';
                          });
                        },
                        child: Text('Transfer Bank'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPaymentMethod == 'Transfer Bank' ? Colors.blue : Colors.transparent,
                          side: BorderSide(
                            color: selectedPaymentMethod == 'Transfer Bank' ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedPaymentMethod = 'E-wallet';
                            detailPembayaran = 'Dana/Gopay, No. HP: 085975385215, A.N: Muhammad Syarifuddin';
                          });
                        },
                        child: Text('E-wallet'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedPaymentMethod == 'E-wallet' ? Colors.blue : Colors.transparent,
                          side: BorderSide(
                            color: selectedPaymentMethod == 'E-wallet' ? Colors.blue : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text('Detail Pembayaran:'),
                  Text(detailPembayaran),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Batal'),
                ),
                TextButton(
                  onPressed: () async {
                    await controller.bayarTagihan(
                      tagihan,
                      selectedPaymentMethod,
                      detailPembayaran,
                    );
                    Navigator.pop(context);
                  },
                  child: Text('Bayar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}