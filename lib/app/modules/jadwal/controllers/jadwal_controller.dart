import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class JadwalController extends GetxController {
  var jadwalList = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedTab = 'kuliah'.obs;
  var selectedDate = DateTime.now().obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchJadwal();
  }

  Future<void> fetchJadwal() async {
    try {
      isLoading.value = true;
      final snapshot =
          await _firestore
              .collection('jadwal')
              .where('tipe', isEqualTo: selectedTab.value)
              .where(
                'tanggal',
                isEqualTo: DateFormat('yyyy-MM-dd').format(selectedDate.value),
              )
              .orderBy('jam_mulai')
              .get();

      jadwalList.value =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setTab(String tab) {
    selectedTab.value = tab;
    fetchJadwal();
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
    fetchJadwal();
  }

  Future<void> tambahJadwal(
    String tipe,
    String nama,
    DateTime tanggal,
    TimeOfDay jamMulai,
    TimeOfDay jamBerakhir,
  ) async {
    try {
      final tanggalStr = DateFormat('yyyy-MM-dd').format(tanggal);
      final jamMulaiStr =
          '${jamMulai.hour.toString().padLeft(2, '0')}:${jamMulai.minute.toString().padLeft(2, '0')}';
      final jamBerakhirStr =
          '${jamBerakhir.hour.toString().padLeft(2, '0')}:${jamBerakhir.minute.toString().padLeft(2, '0')}';

      await _firestore.collection('jadwal').add({
        'tipe': tipe,
        'nama': nama,
        'tanggal': tanggalStr,
        'jam_mulai': jamMulaiStr,
        'jam_berakhir': jamBerakhirStr,
      });

      Get.snackbar('Sukses', 'Jadwal berhasil ditambahkan');
      fetchJadwal(); // Refresh setelah tambah
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambah jadwal: $e');
    }
  }
}
