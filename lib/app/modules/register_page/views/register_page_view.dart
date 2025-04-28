import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/register_page_controller.dart';

class RegisterPageView extends GetView<RegisterPageController> {
  const RegisterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Akun")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              // Nama Lengkap
              TextFormField(
                controller: controller.fullNameController,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(labelText: 'Email Aktif'),
              ),
              SizedBox(height: 10),

              TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 10),

              TextField(
                controller: controller.confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Konfirmasi Password'),
              ),
              SizedBox(height: 20),
              controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    onPressed: controller.register,
                    child: Text("Daftar"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
