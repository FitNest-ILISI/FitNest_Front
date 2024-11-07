import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../events/controllers/event_controller.dart';
import '../events/models/event_model.dart';
import '../events/screens/detail_event.dart';

class EventListPage extends StatelessWidget {
  final EventController eventController = EventController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventModel>>(
      future: eventController.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No events found'));
        } else {
          List<EventModel> events = snapshot.data!;

          // Group events by sport category
          Map<String, List<EventModel>> eventsByCategory = {};
          for (var event in events) {
            eventsByCategory.putIfAbsent(event.sportCategoryName, () => []).add(event);
          }

          return ListView(
            children: eventsByCategory.entries.map((entry) {
              String category = entry.key;
              List<EventModel> categoryEvents = entry.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      category,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryEvents.length,
                      itemBuilder: (context, index) {
                        final event = categoryEvents[index];

                        Widget imageWidget;
                        if (event.imagePath != null) {
                          try {
                            Uint8List imageBytes = base64Decode(event.imagePath!);
                            imageWidget = Image.memory(
                              imageBytes,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          } catch (e) {
                            imageWidget = Container(
                              height: 100,
                              color: Colors.grey,
                              child: Center(child: Text('Invalid image')),
                            );
                          }
                        } else {
                          imageWidget = Container(
                            height: 100,
                            color: Colors.grey,
                            child: Center(child: Text('No image')),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventDetailPage(event: event),
                              ),
                            );
                          },
                          child: Container(
                            width: 160,
                            margin: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      event.startDate,
                                      style: TextStyle(
                                        color: Colors.brown[300],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: imageWidget,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          event.startTime,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          event.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          event.description,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Colors.redAccent,
                                              size: 16,
                                            ),
                                            SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                event.cityName,
                                                overflow: TextOverflow.ellipsis,
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
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              );
            }).toList(),
          );
        }
      },
    );
  }
}
