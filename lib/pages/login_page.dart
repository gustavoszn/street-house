import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/background_widget.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isValid = false;
  bool isLoading = false;
  bool showPassword = false;

  void updateState() {
    setState(() {
      isValid = emailController.text.contains('@') && passwordController.text.length > 3;
    });
  }

  void login() async {
    setState(() => isLoading = true);

  try {
      final data = await ApiService.login(
        emailController.text,
        passwordController.text,
      );
      
      if (!mounted) return;
      
      final usuario = data['usuario'] ?? data;
      final nome = usuario['nome_artistico'] ?? 
                   usuario['nome_organizador'] ?? 
                   usuario['nome'] ?? 
                   'usuário';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bem-vindo, $nome!')),
      );
      
      final nivelAcesso = usuario['nivelAcesso'] ?? usuario['nivel_acesso'];
      
      if (nivelAcesso == 'ADMIN') {
        Navigator.of(context).pushReplacementNamed('/admin');
      } else {
        Navigator.of(context).pushReplacementNamed('/agenda');
      }
    } catch (e) {
      if (!mounted) return;
      print('Erro detalhado: $e');
      
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => isLoading = false);
    Navigator.of(context).pushReplacementNamed('/home');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))],
                ),
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Image.asset('lib/assets/logo.png', width: 120, semanticLabel: 'Street House — logo'),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('/cadastro'),
                      child: Text('Não possui conta?', style: GoogleFonts.inter(color: Colors.orange, fontWeight: FontWeight.w500)),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        hintText: 'seu@email.com',
                        labelStyle: GoogleFonts.inter(color: Colors.grey[700]),
                        hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                        suffixIcon: isValid
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      style: GoogleFonts.inter(),
                      onChanged: (_) => updateState(),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        hintText: 'Sua senha',
                        labelStyle: GoogleFonts.inter(color: Colors.grey[700]),
                        hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
                        suffixIcon: IconButton(
                          icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                          onPressed: () => setState(() => showPassword = !showPassword),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      style: GoogleFonts.inter(),
                      onChanged: (_) => updateState(),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pushNamed('/recuperar-codigo'),
                        child: Text('Esqueci a senha', style: GoogleFonts.inter(color: Colors.deepPurple)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        elevation: isValid ? 6 : 2,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
                      ),
                      onPressed: isValid && !isLoading ? login : null,
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.deepPurple, strokeWidth: 2),
                            )
                          : Text('Avançar', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
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