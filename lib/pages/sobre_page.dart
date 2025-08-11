import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../widgets/background_widget.dart';
import '../theme/design_tokens.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: Column(
          children: [
            // Banner superior com gradiente e logo (agora com borda RETA)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.purpleGradientStart,
                    AppColors.purpleGradientMiddle,
                    AppColors.purpleGradientEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: GradientRotation(135 * 3.14 / 180),
                ),
                // Removido o BorderRadius para ficar reto!
                // borderRadius: const BorderRadius.only(
                //   bottomLeft: Radius.circular(AppRadius.card),
                //   bottomRight: Radius.circular(AppRadius.card),
                // ),
              ),
              child: LogoWidget(
                size: 120,
                colorOverlay: Colors.white,
                semanticsLabel: 'Street House — logo',
                onTap: () => Navigator.of(context).pushNamed('/home'),
              ),
            ),
            // Card branco, também com borda reta superior
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 0),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  // Apenas borda inferior arredondada, se quiser
                  // borderRadius: const BorderRadius.vertical(
                  //   top: Radius.circular(0), // borda superior reta
                  //   bottom: Radius.circular(AppRadius.card),
                  // ),
                  boxShadow: AppShadows.card,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.horizontal),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Diversas opções de artista...',
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MetricBlock(number: '+100', description: 'artistas contratados'),
                            const SizedBox(height: 18),
                            MetricBlock(number: '+1', description: 'cidades atendidas'),
                            const SizedBox(height: 18),
                            MetricBlock(number: '+1 ano', description: 'no mercado'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Tooltip(
                              message: "Conheça nossa história!",
                              child: Icon(Icons.info_outline, color: AppColors.purpleHighlight, size: 18),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Quem somos nós?',
                              style: AppTextStyles.subtitle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Somos uma plataforma que conecta artistas e contratantes de forma moderna, rápida e segura. Nossa missão é valorizar o talento nacional e facilitar a contratação.',
                          style: AppTextStyles.body.copyWith(fontSize: 14, color: AppColors.textGray),
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/acessibilidade'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Acessibilidade', style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500)),
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                height: 2,
                                width: 80,
                                color: AppColors.lightGray,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed('/agenda'),
                          child: Text(
                            'AGENDA',
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.purpleHighlight,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        SafeArea(child: SizedBox(height: 10)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricBlock extends StatelessWidget {
  final String number;
  final String description;

  const MetricBlock({
    super.key,
    required this.number,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCount(
          count: number,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.purpleHighlight,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AppColors.black, // ESCURO!
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class AnimatedCount extends StatefulWidget {
  final String count;
  final TextStyle style;
  const AnimatedCount({super.key, required this.count, required this.style});

  @override
  State<AnimatedCount> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends State<AnimatedCount> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? number;

  @override
  void initState() {
    super.initState();
    number = int.tryParse(widget.count.replaceAll(RegExp(r'[^0-9]'), ''));
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _animation = Tween<double>(begin: 0, end: (number ?? 100).toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        String display = widget.count;
        if (number != null) {
          if (widget.count.contains('+')) {
            display = '+${_animation.value.toInt()}';
          } else if (widget.count.contains('ano')) {
            display = '+${_animation.value.toInt()} ano';
          } else {
            display = _animation.value.toInt().toString();
          }
        }
        return Text(display, style: widget.style);
      },
    );
  }
}