import 'package:flutter/material.dart';
import '../models/domain_models.dart';

class AccessFlow extends StatefulWidget {
  const AccessFlow({super.key, required this.destinationBuilder});
  final WidgetBuilder destinationBuilder;
  @override
  State<AccessFlow> createState() => _AccessFlowState();
}

class _AccessFlowState extends State<AccessFlow> {
  int step = 0;
  UserRole role = UserRole.artist;
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool obscure = true;

  @override
  void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  void enter() => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: widget.destinationBuilder));

  @override
  Widget build(BuildContext context) {
    if (step == 0) return Splash(onReady: () => setState(() => step = 1));
    if (step == 1) return Onboarding(onFinish: () => setState(() => step = 2));
    return Scaffold(body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(22), child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 440), child: Form(key: formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      IconButton(onPressed: () => setState(() => step = 1), icon: const Icon(Icons.arrow_back), alignment: Alignment.centerLeft),
      const SizedBox(height: 18), const Text('Bem-vindo de volta', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1.2)), const SizedBox(height: 8), const Text('Acesse a demonstração segura do Street House.', style: TextStyle(color: Colors.white60)), const SizedBox(height: 32),
      SegmentedButton<UserRole>(segments: const [ButtonSegment(value: UserRole.artist, label: Text('Artista'), icon: Icon(Icons.mic_external_on)), ButtonSegment(value: UserRole.organizer, label: Text('Organizador'), icon: Icon(Icons.event))], selected: {role}, onSelectionChanged: (value) => setState(() => role = value.first)), const SizedBox(height: 22),
      TextFormField(controller: email, keyboardType: TextInputType.emailAddress, autofillHints: const [AutofillHints.email], decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.mail_outline)), validator: (value) => value != null && value.contains('@') ? null : 'Informe um e-mail válido.'), const SizedBox(height: 13),
      TextFormField(controller: password, obscureText: obscure, autofillHints: const [AutofillHints.password], decoration: InputDecoration(labelText: 'Senha', prefixIcon: const Icon(Icons.lock_outline), suffixIcon: IconButton(onPressed: () => setState(() => obscure = !obscure), icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined))), validator: (value) => (value?.length ?? 0) >= 4 ? null : 'Use ao menos 4 caracteres.'), const SizedBox(height: 8),
      Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Recuperação depende da futura API de autenticação.'))), child: const Text('Esqueci minha senha'))), const SizedBox(height: 14),
      FilledButton(onPressed: () { if (formKey.currentState!.validate()) enter(); }, style: FilledButton.styleFrom(padding: const EdgeInsets.all(17)), child: const Text('Entrar na demonstração')), const SizedBox(height: 12),
      OutlinedButton(onPressed: () => setState(() => step = 3), style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(17)), child: const Text('Criar conta')), if (step == 3) ...[const SizedBox(height: 20), Text('Perfil escolhido: ${role == UserRole.artist ? 'Artista' : 'Organizador'}. O cadastro será conectado ao back-end em uma próxima etapa.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white54, fontSize: 12))],
    ])))))));
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key, required this.onReady}); final VoidCallback onReady;
  @override State<Splash> createState() => _SplashState();
}
class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController animation;
  @override void initState() { super.initState(); animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward(); Future<void>.delayed(const Duration(milliseconds: 1400), widget.onReady); }
  @override void dispose() { animation.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(body: Center(child: FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut), child: const Column(mainAxisSize: MainAxisSize.min, children: [DecoratedBox(decoration: BoxDecoration(color: Color(0xFFAF20E7), borderRadius: BorderRadius.all(Radius.circular(22))), child: Padding(padding: EdgeInsets.all(18), child: Icon(Icons.graphic_eq, size: 40))), SizedBox(height: 18), Text('STREET HOUSE', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2))]))));
}

class Onboarding extends StatefulWidget {
  const Onboarding({super.key, required this.onFinish}); final VoidCallback onFinish;
  @override State<Onboarding> createState() => _OnboardingState();
}
class _OnboardingState extends State<Onboarding> {
  final controller = PageController(); int page = 0;
  static const slides = [(Icons.search, 'Descubra artistas', 'Encontre profissionais para tornar seu evento único.'), (Icons.auto_awesome, 'Mostre seu trabalho', 'Crie seu perfil e apresente seu portfólio.'), (Icons.calendar_month, 'Organize sua agenda', 'Gerencie eventos, apresentações e compromissos.')];
  @override void dispose() { controller.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: Column(children: [Align(alignment: Alignment.centerRight, child: TextButton(onPressed: widget.onFinish, child: const Text('Pular'))), Expanded(child: PageView.builder(controller: controller, itemCount: slides.length, onPageChanged: (value) => setState(() => page = value), itemBuilder: (_, i) => Padding(padding: const EdgeInsets.all(35), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(slides[i].$1, size: 100, color: const Color(0xFFAF20E7)), const SizedBox(height: 45), Text(slides[i].$2, textAlign: TextAlign.center, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)), const SizedBox(height: 14), Text(slides[i].$3, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 16))])))), Padding(padding: const EdgeInsets.all(24), child: Row(children: [Expanded(child: Row(children: List.generate(slides.length, (i) => AnimatedContainer(duration: const Duration(milliseconds: 200), width: i == page ? 25 : 8, height: 8, margin: const EdgeInsets.only(right: 6), decoration: BoxDecoration(color: i == page ? const Color(0xFFAF20E7) : Colors.white24, borderRadius: BorderRadius.circular(9)))))), FilledButton(onPressed: () { if (page == slides.length - 1) { widget.onFinish(); } else { controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeOut); } }, child: Text(page == slides.length - 1 ? 'Começar' : 'Continuar'))]))])));
}
