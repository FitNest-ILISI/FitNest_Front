import 'package:fitnest/features/maps/Models/route_model.dart';
import 'package:latlong2/latlong.dart';

import '../Models/point.dart';
import '../service/itineraire_service.dart';

class ItineraireController {
  final ItineraireService itineraireService;

  ItineraireController({required this.itineraireService});

  Future<void> saveItineraire(List<LatLng> points, int eventId) async {
    try {
      List<Point> routePoints = points.map((p) => Point(lat: p.latitude, lng: p.longitude)).toList();
      RouteModel route = RouteModel(points: routePoints);
      await itineraireService.saveItineraire(route, eventId);
      print("Itinéraire sauvegardé via le contrôleur !");
    } catch (error) {
      print("Erreur dans le contrôleur : $error");
    }
  }
}
