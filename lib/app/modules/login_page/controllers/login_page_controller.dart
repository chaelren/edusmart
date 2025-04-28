import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/app/routes/app_routes.dart';

class LoginPageController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final rememberMe = false.obs;
  final isPasswordHidden = true.obs;

  // Fungsi untuk toggle visibilitas password
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Fungsi untuk melakukan login
  Future<void> login() async {
    try {
      isLoading.value = true;

      // Melakukan login menggunakan Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Menampilkan notifikasi sukses
      Get.snackbar("Berhasil", "Login sukses!");

      // Mengalihkan ke halaman dashboard setelah login sukses
      Get.offAllNamed(
        AppRoutes.dashboard,
      ); // Pastikan AppRoutes sudah didefinisikan
    } on FirebaseAuthException catch (e) {
      // Menampilkan notifikasi jika login gagal
      Get.snackbar("Gagal Login", e.message ?? "Terjadi kesalahan");
    } finally {
      // Menghentikan status loading
      isLoading.value = false;
    }
  }
}
