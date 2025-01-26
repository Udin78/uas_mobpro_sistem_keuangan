import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:smartcampus/controllers/grafik_pengeluaran_controller.dart';

class GrafikPengeluaranView extends StatelessWidget {
  final GrafikPengeluaranController controller = Get.put(GrafikPengeluaranController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grafik Pengeluaran'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (controller.chartData.isEmpty) {
          return Center(child: Text('Tidak ada data pengeluaran.'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grafik Pengeluaran', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 250, child: _buildGrafik(controller.chartData)),
                Text('Total Pengeluaran: Rp ${controller.chartData.map((e) => e.y).reduce((a, b) => a + b)}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }
      }),
    );
  }

  // Fungsi untuk membangun grafik
  Widget _buildGrafik(List<FlSpot> chartData) {
    return chartData.isNotEmpty
        ? LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: chartData.length.toDouble(),
        minY: 0,
        maxY: chartData.isNotEmpty ? chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b) : 0,
        lineBarsData: [
          LineChartBarData(
            spots: chartData,
            isCurved: true,
            color: Color(0xFF42A5F5),
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    )
        : Center(child: Text('Tidak ada data untuk grafik.'));
  }
}
