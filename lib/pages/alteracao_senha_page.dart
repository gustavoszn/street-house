import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../widgets/logo.dart';

class AlteracaoSenhaPage extends StatefulWidget {
  const AlteracaoSenhaPage({Key? key}) : super(key: key);

  @override
  State<AlteracaoSenhaPage> createState() => _AlteracaoSenhaPageState();
}

class _AlteracaoSenhaPageState extends State<AlteracaoSenhaPage> {
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width < 500 ? double.infinity : 400.0;
    return Scaffold(
      body: CustomBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxW),
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.08),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StreetLogo(height: 120),
                  const SizedBox(height: 16),
                  Text(
                    "Alteração de senha",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.purple[700]),
                  ),
                  const SizedBox(height: 24),
                  _CustomField(controller: _senhaController, hint: "Digite sua nova senha", obscure: true),
                  const SizedBox(height: 18),
                  _CustomField(controller: _confirmarSenhaController, hint: "Confirme sua senha", obscure: true),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Avançar", style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;

  const _CustomField({
    required this.controller,
    required this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF4EFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: TextStyle(color: Colors.purple[200]),
      ),
      style: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}