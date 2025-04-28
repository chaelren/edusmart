import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../routes/app_routes.dart';

class HomePage extends GetView<DashboardController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Selamat datang,",
                        style: theme.textTheme.bodyMedium,
                      ),
                      Obx(
                        () => Text(
                          controller.userName.value,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          controller.isDarkMode.value
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                        onPressed: controller.toggleTheme,
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.profil);
                        },
                        child: Obx(
                          () => CircleAvatar(
                            radius: 20,
                            backgroundImage:
                                controller.userPhotoUrl.value.isNotEmpty
                                    ? NetworkImage(
                                      controller.userPhotoUrl.value,
                                    )
                                    : const AssetImage(
                                          'assets/images/profile_placeholder.png',
                                        )
                                        as ImageProvider,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Info Cards
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      context,
                      Icons.calendar_today,
                      "Jadwal Hari Ini",
                      "2 Kelas",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _infoCard(
                      context,
                      Icons.account_balance_wallet,
                      "Saldo",
                      "Rp 2.500.000",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Akademik Section
              _sectionWithAction(context, "Manajemen Akademik", () {
                controller.changeTab(1); // Pindah ke tab Jadwal
              }),
              _itemTile(
                context,
                Icons.menu_book,
                "Algoritma dan Pemrograman",
                "09:00 - 10:40 • Ruang 301",
              ),
              _itemTile(
                context,
                Icons.calculate,
                "Kalkulus II",
                "13:00 - 14:40 • Ruang 205",
              ),

              const SizedBox(height: 20),

              // Keuangan Section
              _sectionWithAction(context, "Manajemen Keuangan", () {
                controller.changeTab(2); // Pindah ke tab Keuangan
              }),
              _itemTile(
                context,
                Icons.receipt_long,
                "Pengeluaran Hari Ini",
                "Rp 75.000",
              ),
              _itemTile(
                context,
                Icons.access_time,
                "Tagihan Mendatang",
                "UKT Semester 4 • 15 Juli 2024",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.purple),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.bodyMedium),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionWithAction(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _itemTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title, style: theme.textTheme.bodyLarge),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      tileColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
