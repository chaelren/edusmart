import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_page_controller.dart';
import 'package:flutter_application_1/app/routes/app_routes.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/logo_app.png', height: 100),
              const SizedBox(height: 20),

              // Ilustrasi
              Image.asset(
                'assets/login_pict.png', // ganti sesuai nama file kamu
                height: 200,
              ),
              const SizedBox(height: 30),

              // Email
              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  hintText: 'Email atau Username',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: controller.isPasswordHidden.value,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Ingat saya
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) {
                        controller.rememberMe.value = value!;
                      },
                    ),
                  ),
                  const Text('Ingat saya'),
                ],
              ),
              const SizedBox(height: 10),

              // Tombol Login
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.dashboard);
                },
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        controller.isLoading.value ? null : controller.login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Obx(
                      () =>
                          controller.isLoading.value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                "Masuk",
                                style: TextStyle(color: Colors.white),
                              ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Lupa Password
              GestureDetector(
                onTap: () {
                  // Arahkan ke halaman lupa password
                  Get.toNamed(AppRoutes.forgotPassword);
                },
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Daftar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun? "),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.register),
                    child: Text(
                      "Daftar sekarang",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                '© 2024 EduSmart. Hak cipta dilindungi.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
