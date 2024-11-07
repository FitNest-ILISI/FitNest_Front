import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/event_model.dart';

class EventMapPage extends StatelessWidget {
  final EventModel event;

  EventMapPage({required this.event});

  @override
  Widget build(BuildContext context) {
    // Convert routeCoordinates to a list of LatLng points
    List<LatLng> routeLatLng = event.routeCoordinates
        .map((coords) => LatLng(coords[0], coords[1]))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Location of ${utf8.decode(event.name.runes.toList())}"),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(event.latitude, event.longitude),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(event.latitude, event.longitude),
                width: 80.0,
                height: 80.0,
                builder: (ctx) => Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routeLatLng,
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
