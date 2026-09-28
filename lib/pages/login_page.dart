import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';
import 'cadastro_page.dart';
import 'pedidos_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Bear - Login'),
      ),
      body: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
                TextField(
                  controller: senhaController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                ),
                const SizedBox(height: 20),

                if (viewModel.erro != null)
                  Text(
                    viewModel.erro!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: viewModel.carregando
                      ? null
                      : () async {
                          final sucesso =
                              await viewModel.login(
                            emailController.text,
                            senhaController.text,
                          );

                          if (sucesso && context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const PedidosPage(),
                              ),
                            );
                          }
                        },
                  child: const Text('ENTRAR'),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const CadastroPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Não possui conta? Cadastre-se',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
