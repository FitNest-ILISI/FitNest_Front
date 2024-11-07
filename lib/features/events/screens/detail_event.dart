import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'locate_event_map.dart';

class EventDetailPage extends StatelessWidget {
  final EventModel event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    // Widget for displaying the image
    Widget imageWidget;
    if (event.imagePath != null) {
      try {
        Uint8List imageBytes = base64Decode(event.imagePath!);
        imageWidget = Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              imageBytes,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        );
      } catch (e) {
        imageWidget = Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 200,
          child: Center(child: Text('Invalid image')),
        );
      }
    } else {
      imageWidget = Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 200,
        child: Center(child: Text('No image')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(utf8.decode(event.name.runes.toList()))),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    utf8.decode(event.name.runes.toList()),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Date: ${event.startDate} - ${event.endDate}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Time: ${event.startTime}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Location: ${event.cityName}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    utf8.decode(event.description.runes.toList()),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text("Max Participants: ${event.maxParticipants}"),
                  Text("Current Participants: ${event.currentNumParticipants}"),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventMapPage(event: event),
                            ),
                          );
                        },
                        icon: Icon(Icons.location_pin),
                        label: Text("View Location"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Show itinerary
                        },
                        icon: Icon(Icons.directions),
                        label: Text("View Itinerary"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
