import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../themes/theme_controller.dart';

class DashboardController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userPhotoUrl = ''.obs;
  var currentIndex = 0.obs;

  final ThemeController themeController = Get.find();

  @override
  void onInit() async {
    super.onInit();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload(); // Pastikan data terbaru diambil
      final updatedUser = FirebaseAuth.instance.currentUser;
      userName.value = updatedUser?.displayName ?? 'User';
      userEmail.value = updatedUser?.email ?? 'Email tidak tersedia';
      userPhotoUrl.value = updatedUser?.photoURL ?? '';
    } else {
      userName.value = 'User';
      userEmail.value = 'Email tidak tersedia';
      userPhotoUrl.value = '';
    }
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void toggleTheme() {
    themeController.toggleTheme();
  }

  RxBool get isDarkMode => themeController.isDarkMode;
}
