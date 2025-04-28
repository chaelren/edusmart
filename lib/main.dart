import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/themes/theme_controller.dart'; // pastikan kamu buat file ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Inisialisasi ThemeController
  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EduSmart',
        initialRoute: AppRoutes.login,
        getPages: AppPages.routes,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode:
            themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      ),
    );
  }
}
