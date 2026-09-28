import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../viewmodels/pedido_viewmodel.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final clienteController = TextEditingController();
  final pratoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context
          .read<PedidoViewModel>()
          .carregarPedidos(),
    );
  }

  String formatarValor(double valor) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    ).format(valor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos - The Bear'),
      ),
      body: Consumer<PedidoViewModel>(
        builder: (context, viewModel, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: clienteController,
                      decoration: const InputDecoration(
                        labelText: 'Cliente',
                      ),
                    ),
                    TextField(
                      controller: pratoController,
                      decoration: const InputDecoration(
                        labelText: 'Prato',
                      ),
                    ),
                    TextField(
                      controller: quantidadeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade',
                      ),
                    ),
                    TextField(
                      controller: valorController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Valor Unitário',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final quantidade = int.tryParse(
                          quantidadeController.text,
                        );

                        final valor = double.tryParse(
                          valorController.text
                              .replaceAll(',', '.'),
                        );

                        if (quantidade == null ||
                            valor == null) {
                          return;
                        }

                        await viewModel.cadastrarPedido(
                          cliente: clienteController.text,
                          prato: pratoController.text,
                          quantidade: quantidade,
                          valorUnitario: valor,
                        );

                        clienteController.clear();
                        pratoController.clear();
                        quantidadeController.clear();
                        valorController.clear();
                      },
                      child: const Text(
                        'CADASTRAR PEDIDO',
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido =
                        viewModel.pedidos[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pedido.cliente} | ${pedido.prato}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Quantidade: ${pedido.quantidade} | '
                              'Total: ${formatarValor(pedido.total)}',
                            ),
                            Text(
                              'Classificação: '
                              '${pedido.classificacao}',
                            ),
                            Text(
                              'Status: ${pedido.status}',
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                if (pedido.status ==
                                    'Pendente')
                                  ElevatedButton(
                                    onPressed: () {
                                      viewModel
                                          .finalizarPedido(
                                        pedido.id!,
                                      );
                                    },
                                    child: const Text(
                                      'FINALIZAR',
                                    ),
                                  ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    viewModel.excluirPedido(
                                      pedido.id!,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    'EXCLUIR',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
