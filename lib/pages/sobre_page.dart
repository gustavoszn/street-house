import 'package:flutter/material.dart';
import '../widgets/logo.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                " ,",
                style: TextStyle(
                  fontFamily: 'SansitaSwashed',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: Image.asset(
                    'lib/assets/fundo_login.png',
                    fit: BoxFit.cover,
                    height: 110,
                    width: double.infinity,
                  ),
                ),
                const StreetLogo(height: 55),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                child: ListView(
                  children: [
                    const Text(
                      "Diversas opções de artista...",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text.rich(
                      TextSpan(
                        text: "+100",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8C27F7),
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: "\nartistas contratados",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text.rich(
                      TextSpan(
                        text: "+1",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8C27F7),
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: "\ncidades atendidas",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text.rich(
                      TextSpan(
                        text: "+1 ano",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8C27F7),
                          fontSize: 18,
                        ),
                        children: [
                          TextSpan(
                            text: "\nno mercado",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Quem somos nós?",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Nosso projeto visa otimizar a comunicação entre organizadores e artistas, simplificando o planejamento de eventos e garantindo resultados mais eficientes e memoráveis para todos os envolvidos.",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Acessibilidade",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const Divider(
                      height: 18,
                      thickness: 1,
                      color: Colors.black87,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "AGENDA",
                      style: TextStyle(
                        color: Color(0xFF8C27F7),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}