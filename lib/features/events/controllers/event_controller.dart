import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../service/event_service.dart';

class EventController {
  final EventService eventService = EventService();

  Future<List<EventModel>> getEvents() async {
    try {
      // Récupère les données des événements via le service
      List<EventModel> events = await eventService.fetchAllEvents();

      if (events.isEmpty) {
        return [];
      }

      return events;  // Retourne directement la liste des EventModel
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }
}
