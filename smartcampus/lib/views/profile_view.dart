import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  File? _profileImage;
  User? _currentUser = FirebaseAuth.instance.currentUser;
  bool _isBiometricEnabled = false;
  String? _role;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    await _loadProfileImage();
    await _loadBiometricPreference();
    await _loadUserData();
    if (_currentUser != null) {
      _emailController.text = _currentUser!.email ?? '';
    }
  }

  Future<void> _saveBiometricPreference(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricEnabled', isEnabled);
    setState(() {
      _isBiometricEnabled = isEnabled;
    });
  }

  Future<void> _loadBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricEnabled = prefs.getBool('biometricEnabled') ?? false;
    });
  }

  Future<void> _toggleBiometric() async {
    try {
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      if (!canCheckBiometrics) {
        Get.snackbar('Error', 'Biometric authentication is not available.');
        return;
      }
      setState(() {
        _isBiometricEnabled = !_isBiometricEnabled;
      });
      await _saveBiometricPreference(_isBiometricEnabled);
      Get.snackbar('Berhasil', _isBiometricEnabled ? 'Biometrik aktif.' : 'Biometrik nonaktif.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle biometric: $e');
    }
  }

  Future<void> _disableBiometricPreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricEnabled', false);
    setState(() {
      _isBiometricEnabled = false;
    });
  }

  Future<void> _loadProfileImage() async {
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final profilePath = userDoc['profile_image_path'] ?? '';
        if (profilePath.isNotEmpty) {
          setState(() {
            _profileImage = File(profilePath);
          });
        }
      }
    }
  }

  Future<void> _loadUserData() async {
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        final name = userDoc['name'] ?? '';
        final role = userDoc['role'] ?? '';
        setState(() {
          _nameController.text = name;
          _role = role;
        });
      }
    }
  }

  Future<void> _showResetPasswordDialog() async {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Reset Kata Sandi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Kata sandi lama'),
              ),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Kata sandi baru'),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Konfirmasi kata sandi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Kembali'),
            ),
            TextButton(
              onPressed: () async {
                if (newPasswordController.text == confirmPasswordController.text) {
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null && oldPasswordController.text.isNotEmpty) {
                      AuthCredential credential = EmailAuthProvider.credential(
                        email: user.email!,
                        password: oldPasswordController.text,
                      );
                      await user.reauthenticateWithCredential(credential);

                      await user.updatePassword(newPasswordController.text);

                      Get.snackbar('Success', 'Reset kata sandi berhasil.');
                      Navigator.of(context).pop();
                    } else {
                      Get.snackbar('Error', 'Kata sandi lama salah.');
                    }
                  } catch (e) {
                    Get.snackbar('Error', 'Gagal reset kata sandi: $e');
                  }
                } else {
                  Get.snackbar('Error', 'Kata sandi tidak sama.');
                }
              },
              child: Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            iconSize: 40,
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Center(
            child: GestureDetector(
              onTap: () async {
                await Get.toNamed('/edit-profile');
                await _loadProfileImage(); // Reload profile image after editing
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : AssetImage('assets/default_profile.png') as ImageProvider,
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _nameController.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            _currentUser?.email ?? 'No Email',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Edit Profil'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () async {
              await Get.toNamed('/edit-profile');
              _loadProfileData(); // Reload profile data after editing
            },
          ),
          if (_role == 'mahasiswa')
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Riwayat Akademik'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.toNamed('/academic-history');
              },
            ),
          ListTile(
            leading: Icon(Icons.key),
            title: Text('Reset Kata sandi'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: _showResetPasswordDialog,
          ),
          ListTile(
            leading: Icon(Icons.article),
            title: Text('Syarat & Ketentuan'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Bahasa'),
            trailing: Text('Indonesia'),
            onTap: () {},
          ),
          SwitchListTile(
            title: Text('Autentikasi Biometrik'),
            value: _isBiometricEnabled,
            onChanged: (value) => _toggleBiometric(),
            activeColor: Colors.blue,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async  {
              await _disableBiometricPreference();
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/login');
            },
            child: Text('Keluar'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
