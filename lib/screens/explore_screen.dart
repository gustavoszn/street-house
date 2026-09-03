import 'package:flutter/material.dart';

import '../models/domain_models.dart';
import '../repositories/street_repository.dart';
import '../state/app_controller.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late final AppController controller;
  final search = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = AppController(MockStreetRepository())..search('');
  }

  @override
  void dispose() {
    controller.dispose();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) => ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const SizedBox(height: 10),
            const Text(
              'Explorar artistas',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Busque por nome, categoria ou localização.',
              style: TextStyle(color: Colors.white60),
            ),
            const SizedBox(height: 24),
            SearchBar(
              controller: search,
              leading: const Icon(Icons.search),
              hintText: 'Buscar artistas...',
              trailing: [
                IconButton(
                  onPressed: () => controller.search(search.text),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
              onSubmitted: controller.search,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              children: ['Música', 'DJ', 'Dança', 'Fotografia', 'Comédia']
                  .map(
                    (item) => FilterChip(
                      label: Text(item),
                      selected: false,
                      onSelected: (_) {
                        search.text = item;
                        controller.search(item);
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 25),
            _Results(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    switch (controller.artistsState) {
      case LoadState.loading:
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          ),
        );
      case LoadState.empty:
        return const _State(
          icon: Icons.search_off,
          title: 'Nenhum artista encontrado.',
          message: 'Tente outra categoria ou localização.',
        );
      case LoadState.error:
        return _State(
          icon: Icons.cloud_off,
          title: 'Não foi possível carregar.',
          message: 'Verifique sua conexão e tente novamente.',
          action: () => controller.search(''),
        );
      case LoadState.success:
        return Column(
          children: controller.artists
              .map((artist) => ArtistTile(artist: artist))
              .toList(),
        );
      case LoadState.idle:
        return const SizedBox.shrink();
    }
  }
}

class _State extends StatelessWidget {
  const _State({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(35),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.white38),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54),
          ),
          if (action != null)
            TextButton(
              onPressed: action,
              child: const Text('Tentar novamente'),
            ),
        ],
      ),
    );
  }
}

class ArtistTile extends StatelessWidget {
  const ArtistTile({super.key, required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 27,
          backgroundColor: const Color(0xFF70469C),
          child: Text(artist.stageName.substring(0, 1)),
        ),
        title: Text(
          artist.stageName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          '${artist.category} • ${artist.location}\n${artist.bio}',
          maxLines: 2,
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showArtist(context),
      ),
    );
  }

  void _showArtist(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artist.stageName,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
            ),
            Text(artist.bio),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('Entrar em contato'),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.outlined(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
