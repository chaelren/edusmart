import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../jadwal/views/jadwal_view.dart';
import '../../dashboard/views/home_page.dart';
//import '../../keuangan/views/keuangan_view.dart';
//import '../../settings/views/settings_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Jadwal",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: "Keuangan",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Pengaturan",
            ),
          ],
        ),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: [
            HomePage(),
            JadwalView(),
            //KeuanganView(),
            //SettingsView(),
          ],
        ),
      ),
    );
  }
}
