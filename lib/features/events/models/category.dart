class Category {
  final String id;
  final String name;
  final String iconPath;
  final bool requiresRoute; // Nouveau champ

  Category({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.requiresRoute, // Ajouter le champ ici
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'].toString(),
      name: json['name'],
      iconPath: json['iconPath'],
      requiresRoute: json['requiresRoute'] ?? false,
    );
  }
}
