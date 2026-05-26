class AuthService {
  String? _usuarioAtual;

  Future<bool> login(String email, String senha) async {
    if (email.isNotEmpty && senha.isNotEmpty) {
      _usuarioAtual = email;
      return true;
    }
    return false;
  }

  Future<bool> registrar(String email, String senha) async {
    if (email.isNotEmpty && senha.isNotEmpty) {
      _usuarioAtual = email;
      return true;
    }
    return false;
  }

  void logout() {
    _usuarioAtual = null;
  }

  String? getUsuarioAtual() {
    return _usuarioAtual;
  }
}
