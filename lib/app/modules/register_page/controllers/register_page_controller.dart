import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- Tambahkan ini

class RegisterPageController extends GetxController {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Password dan Konfirmasi Password tidak sama.");
      return;
    }

    try {
      isLoading.value = true;

      // Buat akun di Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // Simpan nama lengkap ke profil user Firebase Auth
      await userCredential.user!.updateDisplayName(
        fullNameController.text.trim(),
      );

      // Setelah itu, simpan ke Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'uid': userCredential.user!.uid,
            'name': fullNameController.text.trim(),
            'email': emailController.text.trim(),
            'photoUrl': '', // Default kosong, nanti bisa update foto
            'createdAt': FieldValue.serverTimestamp(), // Optional
          });

      // Reload user agar displayName terbaru terbaca saat login berikutnya
      await userCredential.user!.reload();

      Get.snackbar("Berhasil", "Akun berhasil dibuat");

      // Arahkan ke login page
      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Gagal", e.message ?? "Terjadi kesalahan");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
