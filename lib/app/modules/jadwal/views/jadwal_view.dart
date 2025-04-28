import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/jadwal_controller.dart';
import 'package:intl/intl.dart';

class JadwalView extends GetView<JadwalController> {
  const JadwalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.fetchJadwal,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabMenu(),
              _buildDateSelector(),
              _buildActionButtons(context),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (controller.jadwalList.isEmpty) {
                    return Center(child: Text("Tidak ada jadwal."));
                  }

                  return ListView.builder(
                    itemCount: controller.jadwalList.length,
                    itemBuilder: (context, index) {
                      final jadwal = controller.jadwalList[index];
                      return _buildJadwalCard(jadwal);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Image.asset("assets/logo_app.png", height: 70),
          Spacer(),
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {
              // Notifikasi handler
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabMenu() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            ['kuliah', 'tugas', 'ujian'].map((tab) {
              final isSelected = controller.selectedTab.value == tab;
              return ElevatedButton(
                onPressed: () => controller.setTab(tab),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isSelected ? Colors.purple : Colors.grey[300],
                  shape: StadiumBorder(),
                ),
                child: Text(tab.capitalizeFirst ?? ''),
              );
            }).toList(),
      );
    });
  }

  Widget _buildDateSelector() {
    final now = DateTime.now();
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final date = now.add(Duration(days: index));
            final isSelected =
                DateFormat('yyyy-MM-dd').format(date) ==
                DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);

            return GestureDetector(
              onTap: () => controller.setDate(date),
              child: Container(
                margin: EdgeInsets.all(6),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purple : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(DateFormat('E').format(date)),
                    Text(date.day.toString()),
                  ],
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => _showTambahJadwalDialog(context),
            icon: Icon(Icons.add),
            label: Text("Tambah Jadwal"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          ),
          Spacer(),
          IconButton(
            onPressed: () => controller.fetchJadwal(),
            icon: Icon(Icons.sync),
          ),
        ],
      ),
    );
  }

  Widget _buildJadwalCard(Map<String, dynamic> jadwal) {
    return Card(
      margin: EdgeInsets.all(12),
      child: ListTile(
        title: Text(jadwal['nama'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mulai: ${jadwal['jam_mulai'] ?? '-'}'),
            Text('Selesai: ${jadwal['jam_berakhir'] ?? '-'}'),
          ],
        ),
        trailing: Text(jadwal['tipe'] ?? ''),
      ),
    );
  }

  void _showTambahJadwalDialog(BuildContext context) {
    final namaController = TextEditingController();
    DateTime? tanggalMulai;
    DateTime? tanggalBerakhir;
    TimeOfDay? jamMulai;
    TimeOfDay? jamBerakhir;
    String tipe = controller.selectedTab.value;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Jadwal'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaController,
                  decoration: InputDecoration(labelText: 'Nama Jadwal'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    tanggalMulai = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                  },
                  child: Text('Pilih Tanggal Mulai'),
                ),
                TextButton(
                  onPressed: () async {
                    tanggalBerakhir = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                  },
                  child: Text('Pilih Tanggal Berakhir'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    jamMulai = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: Text('Pilih Jam Mulai'),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    jamBerakhir = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                  },
                  child: Text('Pilih Jam Berakhir'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (tanggalMulai != null &&
                    tanggalBerakhir != null &&
                    jamMulai != null &&
                    jamBerakhir != null) {
                  controller.tambahJadwal(
                    tipe,
                    namaController.text,
                    tanggalMulai!,
                    jamMulai!,
                    jamBerakhir!,
                  );
                  Navigator.pop(context);
                } else {
                  Get.snackbar("Error", "Semua field harus diisi");
                }
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
