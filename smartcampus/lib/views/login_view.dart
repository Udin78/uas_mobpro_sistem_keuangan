import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final isPasswordVisible = ValueNotifier<bool>(false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
            children: [
            SizedBox(height: screenHeight * 0.12),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang,',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Masuk untuk melanjutkan!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            Spacer(),
            Image.asset(
              'assets/UNIPDU.png',
              height: 80,
              width: 80,
            ),
          ],
        ),
        SizedBox(height: screenHeight * 0.1),

        // Input Email
        TextField(
          controller: authController.emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: screenHeight * 0.02),

        // Input Password
        ValueListenableBuilder(
          valueListenable: isPasswordVisible,
          builder: (context, value, child) {
            return TextField(
              controller: authController.passwordController,
              decoration: InputDecoration(
                labelText: 'Kata sandi',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    value ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    isPasswordVisible.value = !value;
                  },
                ),
              ),
              obscureText: !value,
            );
          },
        ),
        SizedBox(height: screenHeight * 0.05),

        // Tombol Login
        Obx(() => authController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ElevatedButton(
          onPressed: () {
            if (authController.emailController.text.isEmpty ||
                authController.passwordController.text.isEmpty) {
              Get.snackbar('Error', 'Harap isi semua kolom');
              return;
            }

            // Panggil fungsi login
            authController.login(
              authController.emailController.text.trim(),
              authController.passwordController.text.trim(),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Masuk'),
        )),
        SizedBox(height: screenHeight * 0.02),

        // Tombol Login dengan Biometrik
        Obx(() {
          if (authController.isBiometricEnabled.value) {
            return ElevatedButton.icon(
              onPressed: () {
                authController.loginWithBiometrics();
              },
              icon: Icon(Icons.fingerprint, color: Colors.white,),
              label: Text('Masuk dengan Biometrik'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          } else {
            return SizedBox.shrink(); // Tidak menampilkan tombol jika biometrik tidak aktif
          }
        }),
        SizedBox(height: screenHeight * 0.02),

        // Navigasi ke halaman Register
        TextButton(
          onPressed: () {
            Get.toNamed('/register');
          },
          child: RichText(
            text: TextSpan(
                text: "Belum memiliki akun? ",
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'Daftar',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      ],
    ),
    ),
    );
  }
}
