import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../widgets/logo.dart';
import '../widgets/simple_captcha.dart';

class CadastroArtistaPage extends StatefulWidget {
  const CadastroArtistaPage({Key? key}) : super(key: key);

  @override
  State<CadastroArtistaPage> createState() => _CadastroArtistaPageState();
}

class _CadastroArtistaPageState extends State<CadastroArtistaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _captchaOk = false;

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width < 500 ? double.infinity : 400.0;
    return Scaffold(
      body: CustomBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxW),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.09),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const StreetLogo(height: 80, white: false),
                    const SizedBox(height: 18),
                    Text("Cadastro de Artista",
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.purple[800],
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        )),
                    const SizedBox(height: 14),
                    _FormField(controller: _nomeController, hint: "Nome completo"),
                    const SizedBox(height: 10),
                    _FormField(controller: _telefoneController, hint: "Telefone"),
                    const SizedBox(height: 10),
                    _FormField(controller: _cpfController, hint: "CPF"),
                    const SizedBox(height: 10),
                    _FormField(controller: _enderecoController, hint: "Endereço"),
                    const SizedBox(height: 10),
                    _FormField(controller: _dataNascimentoController, hint: "Data de nascimento"),
                    const SizedBox(height: 10),
                    _FormField(controller: _emailController, hint: "E-mail"),
                    const SizedBox(height: 10),
                    _FormField(controller: _senhaController, hint: "Senha", obscure: true),
                    const SizedBox(height: 18),
                    // CAPTCHA
                    SimpleCaptcha(
                      onVerified: (ok) => setState(() => _captchaOk = ok),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _captchaOk ? Colors.purple[700] : Colors.purple[200],
                        foregroundColor: Colors.white,
                        elevation: _captchaOk ? 4 : 0,
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _captchaOk
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                // Chame a API para cadastrar artista!
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                    title: Row(
                                      children: [
                                        Icon(Icons.celebration, color: Colors.purple[700], size: 30),
                                        const SizedBox(width: 7),
                                        const Text("Cadastro realizado!"),
                                      ],
                                    ),
                                    content: const Text("Seja bem-vindo(a) à Street House!"),
                                    actions: [
                                      TextButton(
                                        style: TextButton.styleFrom(foregroundColor: Colors.purple[700]),
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          Navigator.pushReplacementNamed(context, '/login');
                                        },
                                        child: const Text("OK"),
                                      )
                                    ],
                                  ),
                                );
                              }
                            }
                          : null,
                      icon: const Icon(Icons.check),
                      label: const Text(
                        "Cadastrar",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  const _FormField({required this.controller, required this.hint, this.obscure = false});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: (v) => v!.trim().isEmpty ? "Campo obrigatório" : null,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF4EFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        hintStyle: const TextStyle(color: Color(0xFFBBA7E2), fontWeight: FontWeight.w700, fontSize: 16),
      ),
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }
}