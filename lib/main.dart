import 'package:flutter/material.dart';
import 'screens/access_flow.dart';
import 'screens/explore_screen.dart';
import 'screens/messages_screen.dart';

void main() => runApp(const StreetHouseApp());

class AppColors {
  static const ink = Color(0xFF101114);
  static const surface = Color(0xFF181A1F);
  static const elevated = Color(0xFF22252B);
  static const violet = Color(0xFFAF20E7);
  static const coral = Color(0xFFFF795F);
  static const cream = Color(0xFFF7F4EC);
  static const muted = Color(0xFF9B9CA3);
}

class StreetHouseApp extends StatelessWidget {
  const StreetHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Street House — artistas e eventos',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.violet,
          brightness: Brightness.dark,
          surface: AppColors.surface,
        ),
        scaffoldBackgroundColor: AppColors.ink,
        fontFamily: 'Arial',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 58, fontWeight: FontWeight.w800, letterSpacing: -2.5, height: .95),
          displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -1.4),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -.6),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          bodyLarge: TextStyle(fontSize: 16, height: 1.55, color: Color(0xFFCACAD0)),
          bodyMedium: TextStyle(fontSize: 14, height: 1.5, color: AppColors.muted),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Color(0xFF2B2E34)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.elevated,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.violet, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      ),
      home: AccessFlow(destinationBuilder: (_) => const HomeShell()),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  final pages = const [DiscoverPage(), ExploreScreen(), AgendaPage(), MessagesScreen(), ProfilePage()];
  final destinations = const [
    (Icons.home_outlined, Icons.home, 'Início'),
    (Icons.explore_outlined, Icons.explore, 'Explorar'),
    (Icons.calendar_today_outlined, Icons.calendar_today, 'Agenda'),
    (Icons.chat_bubble_outline, Icons.chat_bubble, 'Mensagens'),
    (Icons.person_outline, Icons.person, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final desktop = constraints.maxWidth >= 900;
      return Scaffold(
        body: SafeArea(
          child: Row(children: [
            if (desktop) DesktopNav(index: index, destinations: destinations, onChanged: (value) => setState(() => index = value)),
            Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 280), child: KeyedSubtree(key: ValueKey(index), child: pages[index]))),
          ]),
        ),
        bottomNavigationBar: desktop ? null : NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: destinations.map((item) => NavigationDestination(icon: Icon(item.$1), selectedIcon: Icon(item.$2), label: item.$3)).toList(),
        ),
      );
    });
  }
}

class DesktopNav extends StatelessWidget {
  const DesktopNav({super.key, required this.index, required this.destinations, required this.onChanged});
  final int index;
  final List<(IconData, IconData, String)> destinations;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(color: Color(0xFF131519), border: Border(right: BorderSide(color: Color(0xFF272A30)))),
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Brand(),
        const SizedBox(height: 55),
        ...List.generate(destinations.length, (i) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            selected: i == index,
            leading: Icon(i == index ? destinations[i].$2 : destinations[i].$1),
            title: Text(destinations[i].$3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            selectedTileColor: AppColors.violet.withValues(alpha: .16),
            selectedColor: const Color(0xFFCDBBFF),
            onTap: () => onChanged(i),
          ),
        )),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.elevated, borderRadius: BorderRadius.circular(18)),
          child: const Row(children: [CircleAvatar(backgroundColor: AppColors.coral, child: Text('GB')), SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Modo demonstração', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)), Text('Dados fictícios', style: TextStyle(color: AppColors.muted, fontSize: 11))]))]),
        ),
      ]),
    );
  }
}

class Brand extends StatelessWidget {
  const Brand({super.key});
  @override
  Widget build(BuildContext context) => const Row(children: [
    DecoratedBox(decoration: BoxDecoration(color: AppColors.violet, borderRadius: BorderRadius.all(Radius.circular(13))), child: Padding(padding: EdgeInsets.all(10), child: Icon(Icons.graphic_eq, color: Colors.white))),
    SizedBox(width: 12), Text('STREET\nHOUSE', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1.2, height: .95)),
  ]);
}

class PageFrame extends StatelessWidget {
  const PageFrame({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width < 600 ? 18 : 38, vertical: 28), child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1180), child: child)));
}

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PageFrame(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const MobileHeader(),
      Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('DESCUBRA A CENA', style: TextStyle(color: AppColors.coral, fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 11)), const SizedBox(height: 10), Text('Encontre o próximo\nsom da sua agenda.', style: Theme.of(context).textTheme.displayLarge)])), IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.notifications_none), tooltip: 'Notificações')]),
      const SizedBox(height: 32),
      TextField(decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Busque artistas, estilos ou eventos', suffixIcon: Icon(Icons.tune))),
      const SizedBox(height: 30),
      const SectionTitle(title: 'Em destaque', action: 'Ver todos'),
      const SizedBox(height: 14),
      SizedBox(height: 285, child: ListView(scrollDirection: Axis.horizontal, children: const [FeaturedCard(name: 'Nina Alves', genre: 'R&B • São Paulo', color: Color(0xFF7048A8), icon: Icons.mic_external_on), FeaturedCard(name: 'Noite Subsolo', genre: 'Hip-hop • 14 SET', color: Color(0xFFB94E38), icon: Icons.album), FeaturedCard(name: 'Coletivo Norte', genre: 'Indie • Barueri', color: Color(0xFF386B61), icon: Icons.groups_2)])),
      const SizedBox(height: 34),
      const SectionTitle(title: 'Agenda perto de você', action: 'Explorar mapa'),
      const SizedBox(height: 14),
      LayoutBuilder(builder: (context, c) => GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: c.maxWidth > 760 ? 3 : 1, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: c.maxWidth > 760 ? 1.75 : 2.5, children: const [EventCard(day: '18', month: 'SET', title: 'Festival de Rua', place: 'Praça das Artes'), EventCard(day: '22', month: 'SET', title: 'Sarau Independente', place: 'Casa Aurora'), EventCard(day: '28', month: 'SET', title: 'Batalha do Centro', place: 'Galeria Livre')])),
    ]));
  }
}

class MobileHeader extends StatelessWidget {
  const MobileHeader({super.key});
  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (_, c) => c.maxWidth >= 650 ? const SizedBox(height: 15) : const Padding(padding: EdgeInsets.only(bottom: 34), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Brand(), CircleAvatar(backgroundColor: AppColors.elevated, child: Icon(Icons.person_outline))])));
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, required this.action});
  final String title, action;
  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)), TextButton(onPressed: () {}, child: Text(action))]);
}

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key, required this.name, required this.genre, required this.color, required this.icon});
  final String name, genre; final Color color; final IconData icon;
  @override
  Widget build(BuildContext context) => Container(width: 260, margin: const EdgeInsets.only(right: 14), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Align(alignment: Alignment.topRight, child: IconButton.filledTonal(onPressed: () {}, icon: const Icon(Icons.favorite_border))), const Spacer(), Icon(icon, size: 52, color: Colors.white.withValues(alpha: .45)), const Spacer(), Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22)), Text(genre, style: const TextStyle(color: Colors.white70, fontSize: 12)), const SizedBox(height: 12), const Row(children: [Text('Ver perfil', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)), SizedBox(width: 5), Icon(Icons.arrow_forward, size: 14)])]));
}

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.day, required this.month, required this.title, required this.place});
  final String day, month, title, place;
  @override
  Widget build(BuildContext context) => Card(child: Padding(padding: const EdgeInsets.all(17), child: Row(children: [Container(width: 52, padding: const EdgeInsets.symmetric(vertical: 8), decoration: BoxDecoration(color: AppColors.elevated, borderRadius: BorderRadius.circular(14)), child: Column(children: [Text(day, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), Text(month, style: const TextStyle(color: AppColors.coral, fontSize: 9, fontWeight: FontWeight.w800))])), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), Text(place, style: const TextStyle(color: AppColors.muted, fontSize: 11))])), const Icon(Icons.chevron_right, color: AppColors.muted)])));
}

class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const MobileHeader(), Text('Sua agenda', style: Theme.of(context).textTheme.displaySmall), const SizedBox(height: 8), const Text('Organize apresentações, encontros e oportunidades.', style: TextStyle(color: AppColors.muted)), const SizedBox(height: 30), ...const [EventRow(date: '18 SET', title: 'Festival de Rua', status: 'Confirmado'), EventRow(date: '22 SET', title: 'Sarau Independente', status: 'Pendente'), EventRow(date: '28 SET', title: 'Batalha do Centro', status: 'Salvo')]]));
}

class EventRow extends StatelessWidget {
  const EventRow({super.key, required this.date, required this.title, required this.status}); final String date, title, status;
  @override
  Widget build(BuildContext context) => Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(contentPadding: const EdgeInsets.all(18), leading: CircleAvatar(backgroundColor: AppColors.violet.withValues(alpha: .18), child: const Icon(Icons.music_note)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(date), trailing: Chip(label: Text(status))));
}

class ConnectionsPage extends StatelessWidget {
  const ConnectionsPage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const MobileHeader(), Text('Conexões', style: Theme.of(context).textTheme.displaySmall), const SizedBox(height: 8), const Text('Artistas e produtores que fazem parte da sua rede.', style: TextStyle(color: AppColors.muted)), const SizedBox(height: 28), Wrap(spacing: 12, runSpacing: 12, children: const [PersonCard(initials: 'NA', name: 'Nina Alves', role: 'Artista'), PersonCard(initials: 'CL', name: 'Casa Livre', role: 'Produtor'), PersonCard(initials: 'RN', name: 'Ritmo Norte', role: 'Coletivo')]) ]));
}

class PersonCard extends StatelessWidget {
  const PersonCard({super.key, required this.initials, required this.name, required this.role}); final String initials, name, role;
  @override
  Widget build(BuildContext context) => SizedBox(width: 260, child: Card(child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [CircleAvatar(radius: 27, backgroundColor: AppColors.coral, child: Text(initials, style: const TextStyle(fontWeight: FontWeight.w800))), const SizedBox(height: 28), Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), Text(role, style: const TextStyle(color: AppColors.muted)), const SizedBox(height: 16), OutlinedButton(onPressed: () {}, child: const Text('Ver perfil'))]))));
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const MobileHeader(), Text('Perfil artístico', style: Theme.of(context).textTheme.displaySmall), const SizedBox(height: 30), Card(child: Padding(padding: const EdgeInsets.all(28), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const CircleAvatar(radius: 42, backgroundColor: AppColors.violet, child: Text('GB', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800))), const SizedBox(height: 20), const Text('Gustavo Brito', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)), const Text('Artista independente • São Paulo', style: TextStyle(color: AppColors.muted)), const SizedBox(height: 24), const Text('Este é um perfil demonstrativo criado para apresentar a experiência do Street House sem coletar dados pessoais.'), const SizedBox(height: 24), FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_outlined), label: const Text('Editar perfil'))])))]));
}
