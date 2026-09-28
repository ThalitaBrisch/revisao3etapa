import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/banco_service.dart';

class LoginViewModel extends ChangeNotifier {
  final BancoService _bancoService = BancoService();

  bool _carregando = false;
  String? _erro;
  Usuario? _usuario;

  bool get carregando => _carregando;
  String? get erro => _erro;
  Usuario? get usuario => _usuario;

  Future<bool> login(
    String email,
    String senha,
  ) async {
    _carregando = true;
    _erro = null;
    notifyListeners();

    final usuario = await _bancoService.autenticar(
      email,
      senha,
    );

    _carregando = false;

    if (usuario == null) {
      _erro = 'E-mail ou senha inválidos.';
      notifyListeners();
      return false;
    }

    _usuario = usuario;

    notifyListeners();
    return true;
  }

  Future<bool> cadastrarUsuario(
    String nome,
    String email,
    String senha,
  ) async {
    try {
      final usuario = Usuario(
        nome: nome,
        email: email,
        senha: senha,
      );

      await _bancoService.inserirUsuario(usuario);

      _erro = null;
      notifyListeners();

      return true;
    } catch (e) {
      _erro = 'Não foi possível cadastrar o usuário.';
      notifyListeners();

      return false;
    }
  }

  void limparErro() {
    _erro = null;
    notifyListeners();
  }
}
