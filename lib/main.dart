import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';
import 'pages/sobre_page.dart';
import 'pages/acessibilidade_page.dart';
import 'pages/agenda_page.dart';
import 'pages/cadastro_page.dart';
import 'pages/code_recovery_page.dart';
import 'pages/change_password_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Street House',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/sobre': (context) => const SobrePage(),
        '/acessibilidade': (context) => const AcessibilidadePage(),
        '/agenda': (context) => const AgendaPage(),
        '/cadastro': (context) => const CadastroPage(),
        '/recuperar-codigo': (context) => const CodeRecoveryPage(),
        '/alterar-senha': (context) => const ChangePasswordPage(),
      },
    );
  }
}