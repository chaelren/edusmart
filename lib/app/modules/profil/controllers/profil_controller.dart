import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  RxString name = ''.obs;
  RxString email = ''.obs;
  RxString photoUrl = ''.obs;

  late TextEditingController nameController;
  late TextEditingController emailController;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    loadUserProfile();
  }

  void loadUserProfile() async {
    final user = auth.currentUser;
    if (user != null) {
      email.value = user.email ?? '';
      final doc = await firestore.collection('users').doc(user.uid).get();
      name.value = doc.data()?['name'] ?? '';
      photoUrl.value = doc.data()?['photoUrl'] ?? '';

      nameController.text = name.value;
      emailController.text = email.value;
    }
  }

  Future<void> updateProfile({
    required String newName,
    String? newPhotoUrl,
  }) async {
    try {
      isLoading.value = true;
      final user = auth.currentUser;
      if (user != null) {
        Map<String, dynamic> updateData = {'name': newName};
        if (newPhotoUrl != null) {
          updateData['photoUrl'] = newPhotoUrl;
        }

        await firestore.collection('users').doc(user.uid).update(updateData);
        loadUserProfile();
        Get.snackbar('Berhasil', 'Profil berhasil diperbarui');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui profil: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      isLoading.value = true;
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = storage.ref().child(
          "profile_pictures/$fileName",
        );

        File file = File(pickedFile.path);

        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot snapshot = await uploadTask;

        String downloadUrl = await snapshot.ref.getDownloadURL();

        await updateProfile(newName: name.value, newPhotoUrl: downloadUrl);

        photoUrl.value = downloadUrl;
      } catch (e) {
        Get.snackbar('Error', 'Gagal upload foto: $e');
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
