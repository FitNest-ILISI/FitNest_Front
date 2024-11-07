import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../maps/screens/locate_event.dart';
import '../../maps/screens/create_itineraire.dart';
import '../controllers/category_provider.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  File? _eventImage;
  int _participantCount = 1;
  String? selectedCategory;
  bool _requiresRoute = false;
  List<List<double>> _routeCoordinates = [];
  final ImagePicker _picker = ImagePicker();

  double? _latitude;  // To store latitude
  double? _longitude; // To store longitude

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }



  void _viewMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CitySearchMapScreen(placeName: _locationNameController.text),
      ),
    );
    if (result != null && result is Map<String, dynamic>) {
      if (result.containsKey('latitude') && result.containsKey('longitude') && result.containsKey('locationName')) {
        setState(() {
          _locationNameController.text = result['locationName']; // Update location name
          _latitude = result['latitude'];
          _longitude = result['longitude'];
        });
      } else {
        print("Erreur: certaines informations de localisation manquent");
      }
    }
  }

  Future<void> _chooseImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _eventImage = File(image.path);
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes:00';
  }

  Future<void> _submitForm() async {

    if (_latitude == null && _longitude == null) {
      print("Champ 'latitude' et 'longitude' sont null");
    }

    // Vérifiez si des champs sont manquants
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationNameController.text.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _startTime == null ||
        _eventImage == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez remplir tous les champs, ajouter une image et choisir une catégorie")),
      );
      return;
    }

    String base64Image = base64Encode(await _eventImage!.readAsBytes());
    // Construct the requestBody, allowing null or empty values for routeCoordinates and locationName
    Map<String, dynamic> requestBody = {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "startDate": _startDate?.toIso8601String().split('T')[0],
      "endDate": _endDate?.toIso8601String().split('T')[0],
      "startTime": _startTime != null ? formatTimeOfDay(_startTime!) : "07:00:00",
      "maxParticipants": _participantCount,
      "currentNumParticipants": 0,
      "imagePath": base64Image,
      "sportCategoryId": selectedCategory,
      // Only add routeCoordinates if it has been set
      "routeCoordinates": _routeCoordinates.isNotEmpty ? _routeCoordinates : null,
      // Allow latitude, longitude, and cityName to be optional
      "latitude": _latitude,
      "longitude": _longitude,
      "cityName": _locationNameController.text.isNotEmpty ? _locationNameController.text : null,
    };

    // Affiche le corps de la requête dans la console pour vérifier son contenu
    print("Request Body: ${jsonEncode(requestBody)}");

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/events/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Événement créé avec succès!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de la création de l'événement : ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion au serveur")),
      );
    }
  }

  Future<void> _createRoute() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreationItineraire()),
    );

    if (result != null && result is List<List<double>>) {
      print(result); // Affiche les coordonnées
      setState(() {
        _routeCoordinates = result; // Mise à jour des coordonnées
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Coordonnées de l'itinéraire importées!")),
      );
    }

  }

  void decrementParticipantCount() {
    setState(() {
      if (_participantCount > 1) {
        _participantCount--;
      }
    });
  }

  void incrementParticipantCount() {
    setState(() {
      _participantCount++;
    });
  }


  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Créer un Événement"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nom de l'événement",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _startDate == null
                            ? "Choisir la date de début"
                            : "Début: ${DateFormat('dd/MM/yyyy').format(_startDate!)}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _endDate == null
                            ? "Choisir la date de fin"
                            : "Fin: ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectStartTime(context),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _startTime == null
                            ? "Choisir l'heure de début"
                            : "Heure: ${formatTimeOfDay(_startTime!)}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: _chooseImage,
                  tooltip: 'Choisir une image',
                ),
              ],
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: _viewMap,
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _locationNameController.text.isEmpty
                      ? "Sélectionner un emplacement"
                      : "Lieu: ${_locationNameController.text}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.lightBlue),
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.lightBlue[50],
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      hint: Text(
                        "Choisir une catégorie",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      isExpanded: true,
                      underline: Container(),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16.0),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      items: categoryProvider.categories
                          .map<DropdownMenuItem<String>>((category) => DropdownMenuItem<String>(
                        value: category.id,
                        child: Row(
                          children: [
                            Image.asset(
                              category.iconPath,
                              width: 24.0,
                              height: 24.0,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              category.name,
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _createRoute,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Largeur élargie
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    textStyle: TextStyle(fontSize: 16.0),
                  ),
                  child: Text("Créer l'itinéraire"),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: decrementParticipantCount,
                ),
                Text("Participants: $_participantCount"),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: incrementParticipantCount,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text("Créer l'événement"),
            ),
          ],
        ),
      ),
    );
  }

}
