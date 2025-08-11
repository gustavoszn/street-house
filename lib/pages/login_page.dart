import 'package:flutter/material.dart';
import '../widgets/background.dart';
import '../widgets/logo.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width < 500 ? double.infinity : 400.0;
    return Scaffold(
      body: CustomBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxW),
              padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.10),
                    blurRadius: 36,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // LOGO: só colorida aqui, maior
                  const StreetLogo(height: 110, white: false),
                  const SizedBox(height: 36),
                  Text(
                    "Bem-vindo!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Botão Não possui conta?
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.person_add_alt_1, color: Colors.deepOrange[400], size: 20),
                      label: Text(
                        "Não possui conta?",
                        style: TextStyle(
                          color: Colors.deepOrange[400],
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        foregroundColor: Colors.deepOrange[400],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.deepOrange.withOpacity(0.06),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/cadastro-artista'),
                    ),
                  ),
                  const SizedBox(height: 22),
                  // E-mail
                  const _CustomField(
                    hint: "E-mail",
                    icon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 14),
                  // Senha
                  const _CustomField(
                    hint: "Senha",
                    obscure: true,
                    icon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 28),
                  // Esqueci a senha (botão grande acima de avançar)
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: Colors.purple.withOpacity(0.08),
                        foregroundColor: Colors.purple[800],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/confirmar-codigo'),
                      child: const Text("Esqueci a senha"),
                    ),
                  ),
                  const SizedBox(height: 18),
                  // Botão avançar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple[700],
                        foregroundColor: Colors.white,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        shadowColor: Colors.purple[200],
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/agenda'),
                      child: const Text(
                        "Avançar",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
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
  final String hint;
  final bool obscure;
  final IconData? icon;
  const _CustomField({required this.hint, this.obscure = false, this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 22, color: Colors.purple[200]) : null,
        filled: true,
        fillColor: const Color(0xFFF4EFFF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
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
