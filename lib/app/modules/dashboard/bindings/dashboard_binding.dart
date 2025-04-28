import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../jadwal/controllers/jadwal_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    // Bind controller untuk tiap view di tab
    Get.lazyPut<JadwalController>(() => JadwalController());
    //Get.lazyPut<KeuanganController>(() => KeuanganController());
    //Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
