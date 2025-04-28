import 'package:get/get.dart';
import '../modules/login_page/bindings/login_page_binding.dart';
import '../modules/login_page/views/login_page_view.dart';
import '../modules/register_page/bindings/register_page_binding.dart';
import '../modules/register_page/views/register_page_view.dart';
import 'app_routes.dart';
import 'package:flutter_application_1/app/modules/forgot_password/views/forgot_password_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/jadwal/bindings/jadwal_binding.dart';
import '../modules/jadwal/views/jadwal_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginPageView(),
      binding: LoginPageBinding(),
    ),

    GetPage(
      name: AppRoutes.register,
      page: () => RegisterPageView(),
      binding: RegisterPageBinding(),
    ),

    GetPage(name: AppRoutes.forgotPassword, page: () => ForgotPasswordView()),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),

    //GetPage(
    //name: AppRoutes.manajemenAkademik,
    //page: () => const Placeholder(), // Ganti nanti dengan page aslinya
    //),
    //GetPage(
    //name: AppRoutes.manajemenKeuangan,
    //page: () => const Placeholder(), // Ganti nanti dengan page aslinya
    //),
    GetPage(
      name: AppRoutes.jadwal,
      page: () => JadwalView(),
      binding: JadwalBinding(),
    ),

    GetPage(
      name: AppRoutes.profil,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
