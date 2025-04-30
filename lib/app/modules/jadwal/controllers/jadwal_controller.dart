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
      await _firestore.collection('jadwal').add({
        'tipe': tipe,
        'nama': nama,
        'tanggal': DateFormat('yyyy-MM-dd').format(tanggal),
        'jam_mulai': _formatTime(jamMulai),
        'jam_berakhir': _formatTime(jamBerakhir),
        'created_at': FieldValue.serverTimestamp(),
      });
      fetchJadwal();
      Get.snackbar('Sukses', 'Jadwal berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan jadwal: $e');
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
      await _firestore.collection('jadwal').doc(id).update({
        'tipe': tipe,
        'nama': nama,
        'tanggal': DateFormat('yyyy-MM-dd').format(tanggal),
        'jam_mulai': _formatTime(jamMulai),
        'jam_berakhir': _formatTime(jamBerakhir),
        'updated_at': FieldValue.serverTimestamp(),
      });
      fetchJadwal();
      Get.snackbar('Sukses', 'Jadwal berhasil diperbarui');
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengedit jadwal: $e');
    }
  }

  Future<void> hapusJadwal(String id) async {
    try {
      await _firestore.collection('jadwal').doc(id).delete();
      fetchJadwal();
      Get.snackbar('Sukses', 'Jadwal berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus jadwal: $e');
    }
  }

  String _formatTime(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  void cekJadwalBerakhir() async {
    try {
      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);

      final snapshot =
          await _firestore
              .collection('jadwal')
              .where('tanggal', isEqualTo: todayStr)
              .get();

      for (var doc in snapshot.docs) {
        final jamBerakhir = doc['jam_berakhir'];
        final berakhirTime = _parseTime(jamBerakhir);
        final endDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          berakhirTime.hour,
          berakhirTime.minute,
        );

        if (now.isAfter(endDateTime)) {
          // Lakukan tindakan jika sudah lewat (opsional)
        }
      }
    } catch (e) {
      print("Gagal mengecek jadwal berakhir: $e");
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  void cekNotifikasi() {
    // Fungsi opsional, misal untuk masa depan
    Get.snackbar("Notifikasi", "Belum ada notifikasi saat ini.");
  }
}
