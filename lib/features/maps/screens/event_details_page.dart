import 'package:flutter/material.dart';

class DetailEventPage extends StatelessWidget {
  final Map<String, dynamic> event;

  DetailEventPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event['name'] ?? 'Event Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event['name'] ?? 'Unnamed Event',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                event['description'] ?? 'No description available',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
            SizedBox(height: 16),
            _buildDetailRow(Icons.location_on, 'Location', event['location_name'] ?? 'Unknown location'),
            SizedBox(height: 12),
            _buildDetailRow(Icons.calendar_today, 'Date', '${event['start_date']} - ${event['end_date']}'),
            SizedBox(height: 12),
            _buildDetailRow(Icons.sports, 'Category', event['sportCategoryName'] ?? 'Unspecified'),
            SizedBox(height: 12),
            _buildDetailRow(Icons.people, 'Participants', '${event['currentNumParticipants']} / ${event['maxParticipants']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blueAccent),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
