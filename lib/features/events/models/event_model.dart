class EventModel {
  final int id;
  final String name;
  final String description;
  final String startDate;
  final String endDate;
  final String startTime;
  final int maxParticipants;
  final int currentNumParticipants;
  final String? imagePath;
  final int sportCategoryId;
  final String sportCategoryName;
  final String cityName;
  final double latitude;
  final double longitude;
  final List<List<double>> routeCoordinates;

  EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.maxParticipants,
    required this.currentNumParticipants,
    this.imagePath,
    required this.sportCategoryId,
    required this.sportCategoryName,
    required this.cityName,
    required this.latitude,
    required this.longitude,
    required this.routeCoordinates,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      startTime: json['startTime'] as String,
      maxParticipants: json['maxParticipants'] as int,
      currentNumParticipants: json['currentNumParticipants'] as int,
      imagePath: json['imagePath'] as String?,
      sportCategoryId: json['sportCategoryId'] as int,
      sportCategoryName: json['sportCategoryName'] as String,
      cityName: json['cityName'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      routeCoordinates: (json['routeCoordinates'] as List)
          .map((e) => (e as List).map((coord) => (coord as num).toDouble()).toList())
          .toList(),
    );
  }



  // Method to convert the EventModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'startTime': startTime,
      'maxParticipants': maxParticipants,
      'currentNumParticipants': currentNumParticipants,
      'imagePath': imagePath,
      'sportCategoryId': sportCategoryId,
      'sportCategoryName': sportCategoryName,
      'cityName': cityName,
      'latitude': latitude,
      'longitude': longitude,
      'routeCoordinates': routeCoordinates,
    };
  }
}
