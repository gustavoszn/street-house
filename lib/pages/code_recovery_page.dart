import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/background_widget.dart';

class CodeRecoveryPage extends StatefulWidget {
  const CodeRecoveryPage({super.key});

  @override
  State<CodeRecoveryPage> createState() => _CodeRecoveryPageState();
}

class _CodeRecoveryPageState extends State<CodeRecoveryPage> {
  final lastDigitsController = TextEditingController();
  final codeController = TextEditingController();

  bool isLoading = false;
  bool codeSent = false;
  String? errorText;
  String? codeErrorText;
  String sentCode = "";

  // Simula validação dos 4 dígitos (aqui aceita '2954')
  Future<bool> validateLastDigits(String digits) async {
    await Future.delayed(const Duration(milliseconds: 700));
    return digits == "2954"; // Simule conforme seu backend
  }

  // Simula envio de código
  Future<void> sendCode() async {
    setState(() {
      isLoading = true;
      errorText = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    sentCode = "123456"; // Simule envio real
    setState(() {
      isLoading = false;
      codeSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Código enviado para o seu número!'),
    ));
  }

  // Valida os 4 dígitos e envia o código se correto
  Future<void> submitLastDigits() async {
    setState(() {
      isLoading = true;
      errorText = null;
    });
    final success = await validateLastDigits(lastDigitsController.text.trim());
    setState(() {
      isLoading = false;
      errorText = success ? null : "Dígitos incorretos. Tente novamente.";
    });
    if (success) {
      await sendCode();
    }
  }

  // Simula validação do código
  Future<void> submitCode() async {
    setState(() {
      isLoading = true;
      codeErrorText = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() => isLoading = false);
    if (codeController.text.trim() == sentCode) {
      Navigator.of(context).pushReplacementNamed('/alterar-senha');
    } else {
      setState(() => codeErrorText = "Código inválido");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 16, offset: Offset(0, 8))],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('lib/assets/logo.png', width: 120),
                  const SizedBox(height: 16),
                  if (!codeSent) ...[
                    Text(
                      'Digite os 4 últimos dígitos do seu número de celular cadastrado:',
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: lastDigitsController,
                      decoration: InputDecoration(
                        labelText: 'Últimos 4 dígitos',
                        hintText: 'ex: 2954',
                        border: const OutlineInputBorder(),
                        errorText: errorText,
                        counterText: "",
                      ),
                      maxLength: 4,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: isLoading ? null : submitLastDigits,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Enviar código'),
                    ),
                  ] else ...[
                    Text(
                      'Insira o código enviado ao seu número de celular:',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: codeController,
                      decoration: InputDecoration(
                        labelText: 'Código',
                        hintText: '123456',
                        border: const OutlineInputBorder(),
                        errorText: codeErrorText,
                        counterText: "",
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: isLoading ? null : submitCode,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Validar'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}