import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitnest/features/maps/Models/route_model.dart';

class ItineraireService {
  final String baseUrl;

  ItineraireService({required this.baseUrl});

  Future<void> saveItineraire(RouteModel route, int eventId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/itineraire/save'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "eventId": eventId,
        "points": route.toJson(),
      }),
    );

    if (response.statusCode == 201) {
      print("Itinéraire sauvegardé avec succès !");
    } else {
      throw Exception("Erreur lors de la sauvegarde de l'itinéraire : ${response.body}");
    }
  }

  Future<RouteModel> fetchItineraire(int eventId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/itineraire/$eventId'));

    if (response.statusCode == 200) {
      final List<dynamic> pointsJson = jsonDecode(response.body)['points'];
      return RouteModel.fromJson(pointsJson);
    } else {
      throw Exception("Erreur lors de la récupération de l'itinéraire : ${response.body}");
    }
  }
}
