// Importations nécessaires
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../events/service/event_service.dart';
import '../widgets/filters.dart';
import 'event_details_page.dart';

class EventsMapPage extends StatefulWidget {
  @override
  _EventsMapPageState createState() => _EventsMapPageState();
}

class _EventsMapPageState extends State<EventsMapPage> {
  final EventService _eventService = EventService();
  List<Map<String, dynamic>> _events = [];
  String? _selectedCategory;
  String? _selectedDateFilter;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _determinePosition();
  }

  void _fetchEvents() async {
    print('Fetching events with category: $_selectedCategory, dateFilter: $_selectedDateFilter');
    try {
      final events = await _eventService.fetchEvents(
        category: _selectedCategory,
        dateFilter: _selectedDateFilter,
      );
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Error fetching events: $e');
      _showErrorDialog('Error loading events: $e');
    }
  }


  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
      _selectedDateFilter = null;
    });
    _fetchEvents();
  }

  void _onFiltersApplied(EventFilters filters) {
    setState(() {
      _selectedDateFilter = filters.date;
      _selectedCategory = null;
    });
    _fetchEvents();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      } else {
        _showErrorDialog('Location permission is denied.');
      }
    } catch (e) {
      print('Error getting current location: $e');
      _showErrorDialog('Unable to retrieve current location.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _locateMe() {
    if (_currentLocation != null) {
      setState(() {});
    } else {
      _showErrorDialog('Current location is not available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Événements sur la Carte'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un événement',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Filters(
              onCategorySelected: _onCategorySelected,
              onFiltersApplied: _onFiltersApplied,
            ),
          ),
          Expanded(
            child: _events.isEmpty
                ? Center(child: Text('Aucun événement disponible.'))
                : FlutterMap(
              options: MapOptions(
                center: _currentLocation ?? LatLng(34.020882, -6.836455),
                zoom: 12.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    if (_currentLocation != null)
                      Marker(
                        point: _currentLocation!,
                        builder: (ctx) => Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ..._events.map((event) {
                      return Marker(
                        point: LatLng(event['latitude'], event['longitude']),
                        builder: (ctx) => IconButton(
                          icon: Icon(Icons.location_on, color: Colors.red),
                          onPressed: () {
                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailEventPage(
                                  event: event),
                              ),*/
                          },
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _locateMe,
        child: Icon(Icons.my_location),
        tooltip: 'Locate Me',
      ),
    );
  }
}
