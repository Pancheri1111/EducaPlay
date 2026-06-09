import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_service.dart';
import '../data/settings_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final authService = AuthService();

  Future<void> fazerRegistro() async {
    final lang = ref.read(languageProvider.notifier);
    bool sucesso = await authService.registrar(emailController.text, senhaController.text);

    if (sucesso) {
      // AUTO-LOGIN: Entra direto
      Navigator.pushReplacementNamed(context, '/menu');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(lang.translate('try_again'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = ref.watch(themeColorProvider);
    final lang = ref.read(languageProvider.notifier);
    ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(lang.translate('register')),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SUA LOGO PERSONALIZADA
                Image.asset(
                  'assets/images/imagem_logo.png',
                  height: 150,
                  errorBuilder: (context, error, stackTrace) => 
                    Icon(Icons.person_add, size: 80, color: themeColor),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: lang.translate('email'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: lang.translate('password'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: fazerRegistro,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(lang.translate('reg_btn'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                // OPÇÃO CONVIDADO NO CADASTRO
                OutlinedButton(
                  onPressed: () {
                    authService.entrarComoConvidado();
                    Navigator.pushReplacementNamed(context, '/menu');
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    side: BorderSide(color: themeColor),
                  ),
                  child: Text(lang.translate('guest'), style: TextStyle(color: themeColor)),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(lang.translate('has_acc')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
