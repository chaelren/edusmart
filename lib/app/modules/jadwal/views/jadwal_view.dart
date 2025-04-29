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
                      return _buildJadwalCard(context, jadwal);
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
              controller.cekNotifikasi();
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
            onPressed: () => _showTambahAtauEditJadwalDialog(context),
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

  Widget _buildJadwalCard(BuildContext context, Map<String, dynamic> jadwal) {
    return Card(
      margin: EdgeInsets.all(12),
      child: ListTile(
        title: Text(jadwal['nama'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tanggal: ${jadwal['tanggal'] ?? '-'}'),
            Text('Mulai: ${jadwal['jam_mulai'] ?? '-'}'),
            Text('Selesai: ${jadwal['jam_berakhir'] ?? '-'}'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showTambahAtauEditJadwalDialog(context, jadwal: jadwal);
            } else if (value == 'hapus') {
              controller.hapusJadwal(jadwal['id']);
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'hapus', child: Text('Hapus')),
              ],
        ),
      ),
    );
  }

  void _showTambahAtauEditJadwalDialog(
    BuildContext context, {
    Map<String, dynamic>? jadwal,
  }) {
    final namaController = TextEditingController(text: jadwal?['nama'] ?? '');
    DateTime? tanggalMulai =
        jadwal != null ? DateTime.parse(jadwal['tanggal']) : null;
    TimeOfDay? jamMulai =
        jadwal != null ? _parseTime(jadwal['jam_mulai']) : null;
    TimeOfDay? jamBerakhir =
        jadwal != null ? _parseTime(jadwal['jam_berakhir']) : null;
    String tipe = jadwal?['tipe'] ?? controller.selectedTab.value;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(jadwal == null ? 'Tambah Jadwal' : 'Edit Jadwal'),
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
                      initialDate: tanggalMulai ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                  },
                  child: Text('Pilih Tanggal'),
                ),
                TextButton(
                  onPressed: () async {
                    jamMulai = await showTimePicker(
                      context: context,
                      initialTime: jamMulai ?? TimeOfDay.now(),
                    );
                  },
                  child: Text('Pilih Jam Mulai'),
                ),
                TextButton(
                  onPressed: () async {
                    jamBerakhir = await showTimePicker(
                      context: context,
                      initialTime: jamBerakhir ?? TimeOfDay.now(),
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
                    jamMulai != null &&
                    jamBerakhir != null) {
                  if (jadwal == null) {
                    controller.tambahJadwal(
                      tipe,
                      namaController.text,
                      tanggalMulai!,
                      jamMulai!,
                      jamBerakhir!,
                    );
                  } else {
                    controller.editJadwal(
                      jadwal['id'],
                      tipe,
                      namaController.text,
                      tanggalMulai!,
                      jamMulai!,
                      jamBerakhir!,
                    );
                  }
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

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
