import '../models/domain_models.dart';

abstract class StreetRepository {
  Future<List<Artist>> searchArtists(String query);
  Future<List<Conversation>> getConversations();
}

class MockStreetRepository implements StreetRepository {
  static const _artists = [
    Artist(id: '1', name: 'Nina Alves', stageName: 'Nina Alves', category: 'R&B', location: 'São Paulo', bio: 'Voz, composição e performance para eventos autorais.'),
    Artist(id: '2', name: 'Ritmo Norte', stageName: 'Ritmo Norte', category: 'Hip-hop', location: 'Barueri', bio: 'Coletivo independente de música e cultura urbana.'),
    Artist(id: '3', name: 'Lia Monte', stageName: 'Lia Monte', category: 'DJ', location: 'Osasco', bio: 'Sets de house, brasilidades e música eletrônica.'),
  ];

  @override
  Future<List<Artist>> searchArtists(String query) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return _artists;
    return _artists.where((artist) => '${artist.name} ${artist.stageName} ${artist.category} ${artist.location}'.toLowerCase().contains(term)).toList();
  }

  @override
  Future<List<Conversation>> getConversations() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const [
      Conversation(id: '1', name: 'Casa Aurora', lastMessage: 'Podemos confirmar o horário?', time: '14:32', unread: 2),
      Conversation(id: '2', name: 'Nina Alves', lastMessage: 'Enviei meu material atualizado.', time: 'Ontem'),
    ];
  }
}
