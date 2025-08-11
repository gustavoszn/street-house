import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/alteracao_senha_page.dart';
import 'pages/confirmar_codigo_page.dart';
import 'pages/sobre_page.dart';
import 'pages/cadastro_artista_page.dart';
import 'pages/agenda_page.dart';

void main() {
  runApp(const StreetHouseApp());
}

class StreetHouseApp extends StatelessWidget {
  const StreetHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Street House',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: const Color(0xFF8C27F7),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8C27F7)),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/alteracao-senha': (_) => const AlteracaoSenhaPage(),
        '/confirmar-codigo': (_) => const ConfirmarCodigoPage(),
        '/sobre': (_) => const SobrePage(),
        '/cadastro-artista': (_) => const CadastroArtistaPage(),
        '/agenda': (_) => const AgendaPage(),
      },
    );
  }
}