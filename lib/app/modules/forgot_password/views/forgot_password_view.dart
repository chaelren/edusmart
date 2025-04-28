import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ForgotPasswordView extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  ForgotPasswordView({super.key});

  void sendResetLink() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      Get.snackbar(
        "Berhasil",
        "Link reset password telah dikirim ke email kamu.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Gagal",
        e.message ?? "Terjadi kesalahan",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lupa Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Masukkan email kamu dan kami akan mengirim link untuk mengganti password.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendResetLink,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: Text("Kirim Link Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
