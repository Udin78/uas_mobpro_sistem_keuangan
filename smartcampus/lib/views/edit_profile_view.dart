import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfileView extends StatefulWidget {
  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  String? _role;
  User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    if (_currentUser != null) {
      _nameController.text = _currentUser!.displayName ?? '';
      _emailController.text = _currentUser!.email ?? '';

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _role = userDoc['role'];
          _nameController.text = userDoc['name'] ?? '';
          _dobController.text = userDoc['date_of_birth'] ?? '';
          _addressController.text = userDoc['address'] ?? '';
          final profilePath = userDoc['profile_image_path'] ?? '';
          if (profilePath.isNotEmpty) {
            _profileImage = File(profilePath);
          }
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final savedImage = File('${directory.path}/${pickedFile.name}');
      await File(pickedFile.path).copy(savedImage.path);

      setState(() {
        _profileImage = savedImage;
      });

      // Simpan path ke Firestore
      if (_currentUser != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid)
            .update({'profile_image_path': savedImage.path});
      }
    }
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _saveProfileToFirebase() async {
    try {
      if (_currentUser != null) {
        String uid = _currentUser!.uid;
        Map<String, dynamic> data = {
          'name': _nameController.text,
          'email': _emailController.text,
          'date_of_birth': _dobController.text,
          'address': _addressController.text,
          'profile_image_path': _profileImage?.path ?? '',
          'role': _role, // Use existing role if available
        };
        await FirebaseFirestore.instance.collection('users').doc(uid).set(data);
        Get.snackbar('Success', 'Profil berhsil diupdate.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengupdate profil: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/default_profile.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Tanggal Lahir',
                border: OutlineInputBorder(),
              ),
              onTap: () => _pickDateOfBirth(context),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfileToFirebase,
              child: Text('Simpan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
    );
  }
}
