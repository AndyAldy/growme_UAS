import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import 'register_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();
  final BiometricService _biometricService = BiometricService();

  @override
  void initState() {
    super.initState();
    _tryBiometricLogin();
  }

  Future<void> _tryBiometricLogin() async {
    final isAuthenticated = await _biometricService.authenticate();
    if (isAuthenticated) {
      final currentUser = _authService.currentUser;
      if (currentUser != null) {
        // Langsung ke main screen kalau sudah ada user login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    }
  }

  void _login() async {
    setState(() => _isLoading = true);
    final result = await _authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (result == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration:
                  const InputDecoration(labelText: 'Email', icon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration:
                  const InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(onPressed: _login, child: const Text('Login')),
            TextButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RegisterScreen())),
              child: const Text('Belum punya akun? Daftar'),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.fingerprint),
              label: const Text('Login dengan Sidik Jari'),
              onPressed: () async {
                final isAuthenticated = await _biometricService.authenticate();
                if (isAuthenticated) {
                  final currentUser = _authService.currentUser;
                  if (currentUser != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Silakan login manual terlebih dahulu.')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
