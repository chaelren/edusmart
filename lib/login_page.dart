import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('remember_me') ?? false;
    setState(() {
      _rememberMe = remember;
    });
    if (remember) {
      emailController.text = prefs.getString('email') ?? '';
    }
  }

  Future<void> _saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('remember_me', value);
    if (value) {
      prefs.setString('email', emailController.text);
    } else {
      prefs.remove('email');
    }
  }

  void _onLoginPressed() {
    if (_rememberMe) {
      _saveRememberMe(true);
    } else {
      _saveRememberMe(false);
    }

    // Logika login bisa kamu tambahkan di sini
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Login berhasil (simulasi)!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Gambar Logo
              Image.asset(
                'assets/logo_app.png', // Ganti sesuai nama file logo kamu
                height: 100,
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/login_pict.png', height: 200),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Email atau Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Password',
                  suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _rememberMe = value;
                        });
                      }
                    },
                  ),
                  const Text('Ingat saya'),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _onLoginPressed,
                  child: const Text('Masuk'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/lupa-password');
                },
                child: const Text(
                  'Lupa Password?',
                  style: TextStyle(color: Colors.purple),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum punya akun?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/daftar');
                    },
                    child: const Text(
                      'Daftar sekarang',
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                '© 2024 EduSmart. Hak cipta dilindungi.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
