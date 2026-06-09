import 'package:hive_flutter/hive_flutter.dart';

/// AuthService - Gerencia a autenticação dos usuários.
class AuthService {
  String? _usuarioAtual;
  static const String _dbName = 'user_db';

  static Future<void> init() async {
    await Hive.openBox(_dbName);
    // REMOVIDO: box.clear() - Agora os registros são preservados.
    print('--- BANCO DE DADOS PRONTO: Registros mantidos ---');
  }

  Future<bool> login(String email, String senha) async {
    // --- [ DICA PARA BANCO REAL ] ---
    // Aqui você trocaria o código do Hive por uma chamada ao Firebase ou API.
    final box = Hive.box(_dbName);
    if (box.containsKey(email)) {
      if (box.get(email) == senha) {
        _usuarioAtual = email;
        return true;
      }
    }
    return false;
  }

  Future<bool> registrar(String email, String senha) async {
    if (email.isEmpty || senha.isEmpty) return false;
    final box = Hive.box(_dbName);
    if (box.containsKey(email)) return false;
    await box.put(email, senha);
    _usuarioAtual = email;
    return true;
  }

  void entrarComoConvidado() {
    _usuarioAtual = 'Guest';
  }

  void logout() {
    _usuarioAtual = null;
  }

  String? getUsuarioAtual() {
    return _usuarioAtual;
  }

  bool isGuest() {
    return _usuarioAtual == "Guest";
  }

  Map<dynamic, dynamic> getAllUsers() {
    return Hive.box(_dbName).toMap();
  }
}
