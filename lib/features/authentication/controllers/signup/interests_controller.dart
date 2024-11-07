import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterestsController extends GetxController {
  final List<String> interests = [
    'Run',
    'Ride',
    'Swim',
    'Walk',
    'Hike',
    'Workout',
    'Football',
    'Basketball',
    'Volleyball',
  ];

  final List<IconData> interestIcons = [
    Icons.run_circle,
    Icons.directions_bike,
    Icons.pool,
    Icons.directions_walk,
    Icons.hiking,
    Icons.fitness_center,
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_volleyball,
  ];

  // Utilisation de RxMap pour un suivi réactif des sélections
  final selectedInterests = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialiser chaque intérêt avec la valeur `false` (non sélectionné)
    for (var interest in interests) {
      selectedInterests[interest] = false;
    }
  }

  // Méthode pour mettre à jour l'état de sélection d'un intérêt
  void toggleInterest(String interest) {
    selectedInterests[interest] = !selectedInterests[interest]!;
  }
}
