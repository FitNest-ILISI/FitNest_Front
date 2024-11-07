import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/event_model.dart';

class EventService {
  final String baseUrl = 'http://localhost:8080/api/events';

  Future<List<Map<String, dynamic>>> fetchEvents({
    String? category,
    String? dateFilter,
  }) async {
    String url;
    print("category: dateFilter:");
    if (category != null && dateFilter != null) {
      dateFilter = dateFilter.replaceAll(' ', ''); // Supprime les espaces
      url = '$baseUrl/filterByCategoryAndDate?categoryName=$category&filter=$dateFilter';
    } else if (dateFilter != null) {
      dateFilter = dateFilter.replaceAll(' ', ''); // Supprime les espaces
      url = '$baseUrl/filterByDate?filter=$dateFilter';
    } else if (category != null) {
      url = '$baseUrl/category/$category';
    } else {
      url = '$baseUrl/getAllEvents';
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final eventsJson = json.decode(utf8.decode(response.bodyBytes));

        if (eventsJson is List) {
          return eventsJson.map((event) {
            return {
              'id': event['id'],
              'name': event['name'] ?? 'Unnamed event',
              'description': event['description'] ?? 'No description available',
              'cityName': event['cityName'] ?? 'Unknown location',
              'latitude': event['latitude'] ?? 0.0,
              'longitude': event['longitude'] ?? 0.0,
              'startDate': event['startDate'] ?? '',
              'endDate': event['endDate'] ?? '',
              'sportCategoryName': event['sportCategoryName'] ?? 'No category',
              'sportCategoryId': event['sportCategoryId'] ?? 0,
              'maxParticipants': event['maxParticipants'] ?? 0,
              'currentNumParticipants': event['currentNumParticipants'] ?? 0,
            };
          }).toList();
        } else {
          throw Exception('Unexpected JSON format: expected a List');
        }
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Failed to fetch events');
    }
  }

  Future<List<EventModel>> fetchAllEvents() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/events/getAllEvents'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }

}
