ESTE ARQUIVO CONTÉM O CÓDIGO DO LOGIN QUE FOI REMOVIDO A PEDIDO DO USUÁRIO.

--- CÓDIGO DA LOGIN_PAGE.DART ---
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();

  void _login() async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      final settingsBox = Hive.box('settings');
      await settingsBox.put('student_name', name);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/menu');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, digite seu nome para entrar!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.school, size: 80, color: Colors.orange),
              ),
              const SizedBox(height: 24),
              const Text(
                'EducaPlay',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Aluno',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  prefixIcon: const Icon(Icons.face, color: Colors.orange),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _login,
                child: const Text('VAMOS COMEÇAR!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
