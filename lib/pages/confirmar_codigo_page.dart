import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../widgets/logo.dart';

class ConfirmarCodigoPage extends StatefulWidget {
  const ConfirmarCodigoPage({Key? key}) : super(key: key);

  @override
  State<ConfirmarCodigoPage> createState() => _ConfirmarCodigoPageState();
}

class _ConfirmarCodigoPageState extends State<ConfirmarCodigoPage> {
  final TextEditingController _codigoController = TextEditingController();

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
                    "Insira o código enviado ao seu e-mail:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.purple[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _codigoController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Inserir código',
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
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/alteracao-senha'),
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