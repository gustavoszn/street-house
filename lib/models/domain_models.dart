enum UserRole { artist, organizer }

class Artist {
  const Artist({required this.id, required this.name, required this.stageName, required this.category, required this.location, required this.bio, this.available = true});
  final String id, name, stageName, category, location, bio;
  final bool available;
}

class StreetEvent {
  const StreetEvent({required this.id, required this.title, required this.date, required this.place, required this.status});
  final String id, title, place, status;
  final DateTime date;
}

class Conversation {
  const Conversation({required this.id, required this.name, required this.lastMessage, required this.time, this.unread = 0});
  final String id, name, lastMessage, time;
  final int unread;
}

class PortfolioItem {
  const PortfolioItem({required this.id, required this.title, required this.kind});
  final String id, title, kind;
}
