import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulasi daftar
              },
              child: const Text("Daftar Sekarang"),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                // Simulasi daftar via Google (dummy)
              },
              icon: const Icon(Icons.g_mobiledata),
              label: const Text("Daftar dengan Google"),
            ),
          ],
        ),
      ),
    );
  }
}
