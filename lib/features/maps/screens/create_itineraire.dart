import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class CreationItineraire extends StatefulWidget {
  @override
  _CreationItineraireState createState() => _CreationItineraireState();
}

class _CreationItineraireState extends State<CreationItineraire> {
  LatLng? startPoint;
  LatLng? endPoint;
  List<LatLng> routePoints = [];
  String apiKey = '5b3ce3597851110001cf6248465d6b0ae5b34c62881034d3a7aada1b';

  void _setPoint(LatLng point) {
    setState(() {
      if (startPoint == null) {
        startPoint = point;
      } else if (endPoint == null) {
        endPoint = point;
        _calculateRoute();
      } else {
        startPoint = point;
        endPoint = null;
        routePoints.clear();
      }
    });
  }

  Future<void> _calculateRoute() async {
    if (startPoint == null || endPoint == null) return;

    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${startPoint!.longitude},${startPoint!.latitude}&end=${endPoint!.longitude},${endPoint!.latitude}';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'] as List;

      setState(() {
        routePoints = coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
      });

      // Affiche les coordonnées de l'itinéraire dans la console
      print("Itinéraire calculé : $routePoints");
    } else {
      print('Erreur lors du calcul de l\'itinéraire');
    }
  }


  Future<void> _saveItineraire() async {
    if (routePoints.isNotEmpty) {
      final coordinates = convertLatLngToMap(routePoints); // Convertir avant d'envoyer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Itinéraire créé avec succès!")),
      );
      Navigator.pop(context, coordinates); // Retourne les coordonnées à EventForm
    }
  }


  List<List<double>> convertLatLngToMap(List<LatLng> latLngList) {
    return latLngList.map((latLng) {
      return [latLng.longitude, latLng.latitude];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte d\'Itinéraire'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveItineraire, // Enregistre l'itinéraire
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(33.69898407070958, -7.401901307269943),
          zoom: 13.0,
          onTap: (tapPosition, point) => _setPoint(point),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          if (startPoint != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: startPoint!,
                  builder: (ctx) => Icon(Icons.location_on, color: Colors.green),
                ),
              ],
            ),
          if (endPoint != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: endPoint!,
                  builder: (ctx) => Icon(Icons.location_on, color: Colors.red),
                ),
              ],
            ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
