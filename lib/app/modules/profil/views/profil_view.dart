import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profil_controller.dart';

class ProfileView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Saya')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => Column(
            children: [
              GestureDetector(
                onTap: () {
                  controller.updateProfilePhoto();
                },
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage:
                      controller.photoUrl.value.isNotEmpty
                          ? NetworkImage(controller.photoUrl.value)
                          : null,
                  child:
                      controller.photoUrl.value.isEmpty
                          ? const Icon(Icons.add_a_photo, size: 40)
                          : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                enabled: false,
                controller: controller.nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => controller.name.value = value,
              ),
              const SizedBox(height: 20),
              TextField(
                enabled: false,
                controller: controller.emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed:
                    controller.isLoading.value
                        ? null
                        : () {
                          controller.updateProfile(
                            newName: controller.nameController.text,
                          );
                        },
                child:
                    controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
