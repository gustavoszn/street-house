import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AcessibilidadePage extends StatelessWidget {
  const AcessibilidadePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acessibilidade'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            tooltip: 'Sobre',
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.of(context).pushNamed('/sobre'),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double maxWidth = constraints.maxWidth > 650 ? 600 : constraints.maxWidth * 0.97;
          return Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Acessibilidade no Street House',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.deepPurple.shade700,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'O Street House valoriza a inclusão. Nosso app foi desenvolvido com recursos como contraste elevado, tamanho de fonte adaptável, compatibilidade com leitores de tela e áreas de toque ampliadas. A navegação é clara e ações importantes possuem retorno visual e sonoro.',
                      style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dicas para uma melhor experiência:',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '• Ajuste o tamanho da fonte nas configurações do aparelho.\n'
                            '• Mantenha seu leitor de tela atualizado.\n'
                            '• Use o alto contraste de seu sistema se necessário.',
                            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline, color: Colors.deepPurple, size: 32),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16),
                                children: [
                                  const TextSpan(
                                    text: 'Se encontrar barreiras de acessibilidade ou tiver sugestões, entre em contato com nosso suporte: ',
                                  ),
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: InkWell(
                                      onTap: () async {
                                        final uri = Uri(
                                          scheme: 'mailto',
                                          path: 'streethouseofc0@gmail.com',
                                        );
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri);
                                        }
                                      },
                                      child: Text(
                                        'streethouseofc0@gmail.com',
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const TextSpan(
                                    text: '. Estamos sempre melhorando!',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 45),
                    Center(
                      child: Text(
                        'Versão 1.0 • Street House',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.deepPurple.shade200,
                          fontSize: 13,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}