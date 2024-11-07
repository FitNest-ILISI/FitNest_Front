import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart'; // Your main app widget
import 'features/events/controllers/category_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: App(),
    ),
  );
}
