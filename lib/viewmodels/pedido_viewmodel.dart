import 'package:flutter/material.dart';

import '../models/pedido.dart';
import '../services/banco_service.dart';

class PedidoViewModel extends ChangeNotifier {
  final BancoService _bancoService = BancoService();

  List<Pedido> _pedidos = [];

  List<Pedido> get pedidos => _pedidos;

  Future<void> carregarPedidos() async {
    _pedidos = await _bancoService.listarPedidos();
    notifyListeners();
  }

  Future<void> cadastrarPedido({
    required String cliente,
    required String prato,
    required int quantidade,
    required double valorUnitario,
  }) async {
    final total = quantidade * valorUnitario;

    final classificacao =
        quantidade >= 5
            ? 'PEDIDO GRANDE'
            : 'PEDIDO NORMAL';

    final pedido = Pedido(
      cliente: cliente,
      prato: prato,
      quantidade: quantidade,
      valorUnitario: valorUnitario,
      total: total,
      classificacao: classificacao,
      status: 'Pendente',
    );

    await _bancoService.inserirPedido(pedido);

    await carregarPedidos();
  }

  Future<void> finalizarPedido(int id) async {
    await _bancoService.finalizarPedido(id);

    await carregarPedidos();
  }

  Future<void> excluirPedido(int id) async {
    await _bancoService.excluirPedido(id);

    await carregarPedidos();
  }
}
