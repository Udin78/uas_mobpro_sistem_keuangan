import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?; // Ambil data dari arguments
    final role = arguments?['role'] ?? 'Unknown'; // Role dari arguments

    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(user?.uid).snapshots(),
      builder: (context, snapshot) {
        final userName = (snapshot.hasData && snapshot.data != null)
            ? (snapshot.data!['name'] as String? ?? 'User')
            : 'User'; // Nama user default jika kosong

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, color: Colors.blue),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: TextStyle(fontSize: 16, color: Colors.black)),
                    Text(role, style: TextStyle(fontSize: 14, color: Colors.grey)), // Role ditampilkan
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.notifications, color: Colors.black),
                onPressed: () {
                  Get.toNamed('/notifications');
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Informasi Tagihan dan SKS
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tagihan Kuliah', style: TextStyle(color: Colors.grey)),
                          Text('Rp.200.000', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SKS Sekarang', style: TextStyle(color: Colors.grey)),
                          Text('155 / 172', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                if (role == 'mahasiswa') _buildMahasiswaMenu(),
                if (role == 'staff') _buildStaffMenu(),
                if (role == 'dosen') _buildDosenMenu(),
                SizedBox(height: 16),
                // Informasi & Berita
                Text('Informasi & Berita', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(child: Text('Banner Informasi & Berita')),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
              BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Kelas'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            ],
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              switch (index) {
                case 0:
                // Beranda
                  break;
                case 4:
                // Profil
                  Get.toNamed('/profile');
                  break;
                default:
                  break;
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMahasiswaMenu() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildMenuIcon(Icons.person, 'Profil', () {
          Get.toNamed('/profile');
        }),
        _buildMenuIcon(Icons.book, 'KRS', () {}),
        _buildMenuIcon(Icons.grade, 'Nilai', () {}),
        _buildMenuIcon(Icons.schedule, 'Jadwal', () {
          Get.toNamed('/schedule');
        }),
        _buildMenuIcon(Icons.payment, 'Bayar', () {
          Get.toNamed('/bayar');
        }),
        _buildMenuIcon(Icons.receipt, 'Tagihan', () {
          Get.toNamed('/tagihan');
        }),
        _buildMenuIcon(Icons.event, 'Kegiatan', () {}),
        _buildMenuIcon(Icons.holiday_village_sharp, 'Peminjaman Fasilitas', () {
          Get.toNamed('/facility');
        }),
      ],
    );
  }

  Widget _buildStaffMenu() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildMenuIcon(Icons.meeting_room, 'Peminjaman Tempat', () {
          Get.toNamed('/add-room');
        }),
        _buildMenuIcon(Icons.construction, 'Peminjaman Alat', () {
          Get.toNamed('/add-tool');
        }),
        _buildMenuIcon(Icons.history, 'History Peminjaman', () {
          Get.toNamed('/history');
        }),
        _buildMenuIcon(Icons.location_on, 'Tracking Peminjaman', () {}),
        _buildMenuIcon(Icons.report, 'Pelaporan Kerusakan', () {
          Get.toNamed('/report');
        }),
        _buildMenuIcon(Icons.feedback, 'Feedback System', () {}),
        _buildMenuIcon(Icons.attach_money, 'tambah tagihan', () {
          Get.toNamed('/add-bill');
        }),
      ],
    );
  }

  Widget _buildDosenMenu() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _buildMenuIcon(Icons.analytics, 'Report Generator', () {}),
        _buildMenuIcon(Icons.school, 'Academic Performa', () {}),
        _buildMenuIcon(Icons.holiday_village_sharp, 'Peminjaman Fasilitas', () {
          Get.toNamed('/facility');
        }),
        _buildMenuIcon(Icons.monetization_on, 'Finansial Overview', () {
          Get.toNamed('/laporan-pengeluaran');
        }),
        _buildMenuIcon(Icons.book, 'KRS', () {}),
        _buildMenuIcon(Icons.grade, 'KHS', () {}),
      ],
    );
  }

  Widget _buildMenuIcon(IconData icon, String label, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(icon, color: Colors.blue),
            ),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
