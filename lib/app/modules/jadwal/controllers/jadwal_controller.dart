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
    cekJadwalBerakhir();
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
        'nama': nama,
        'tipe': tipe,
        'tanggal': tanggalStr,
        'jam_mulai': jamMulaiStr,
        'jam_berakhir': jamBerakhirStr,
      });
      fetchJadwal();
    } catch (e) {
      Get.snackbar('Error', 'Gagal tambah jadwal: $e');
    }
  }

  Future<void> editJadwal(
    String id,
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

      await _firestore.collection('jadwal').doc(id).update({
        'nama': nama,
        'tipe': tipe,
        'tanggal': tanggalStr,
        'jam_mulai': jamMulaiStr,
        'jam_berakhir': jamBerakhirStr,
      });
      fetchJadwal();
    } catch (e) {
      Get.snackbar('Error', 'Gagal edit jadwal: $e');
    }
  }

  Future<void> hapusJadwal(String id) async {
    try {
      await _firestore.collection('jadwal').doc(id).delete();
      fetchJadwal();
    } catch (e) {
      Get.snackbar('Error', 'Gagal hapus jadwal: $e');
    }
  }

  Future<void> cekJadwalBerakhir() async {
    final snapshot = await _firestore.collection('jadwal').get();
    for (var doc in snapshot.docs) {
      DateTime tanggal = DateTime.parse(doc['tanggal']);
      if (tanggal.isBefore(DateTime.now())) {
        await _firestore.collection('jadwal').doc(doc.id).delete();
      }
    }
    fetchJadwal();
  }

  Future<void> cekNotifikasi() async {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    final snapshot =
        await _firestore
            .collection('jadwal')
            .where(
              'tanggal',
              isEqualTo: DateFormat('yyyy-MM-dd').format(tomorrow),
            )
            .get();

    if (snapshot.docs.isNotEmpty) {
      Get.snackbar('Reminder', 'Ada jadwal yang akan dimulai besok!');
    }
  }
}
