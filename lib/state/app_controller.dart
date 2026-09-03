import 'package:flutter/foundation.dart';
import '../models/domain_models.dart';
import '../repositories/street_repository.dart';

enum LoadState { idle, loading, success, empty, error }

class AppController extends ChangeNotifier {
  AppController(this.repository);
  final StreetRepository repository;
  UserRole role = UserRole.artist;
  LoadState artistsState = LoadState.idle;
  List<Artist> artists = const [];

  Future<void> search(String query) async {
    artistsState = LoadState.loading;
    notifyListeners();
    try {
      artists = await repository.searchArtists(query);
      artistsState = artists.isEmpty ? LoadState.empty : LoadState.success;
    } catch (_) {
      artistsState = LoadState.error;
    }
    notifyListeners();
  }

  void selectRole(UserRole value) { role = value; notifyListeners(); }
}
