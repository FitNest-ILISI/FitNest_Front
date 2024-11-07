import 'package:fitnest/features/authentication/screens/login/widgets/login_form.dart';
import 'package:fitnest/features/home/home.dart';
import 'package:fitnest/features/maps/screens/create_itineraire.dart';
import 'package:fitnest/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'features/authentication/screens/login/login.dart';
import 'features/events/screens/create_event.dart';
import 'features/maps/screens/locate_event.dart';
import 'features/maps/screens/map_events.dart';
import 'navigation_menu.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: MyAppTheme.darkTheme,
      theme: MyAppTheme.lightTheme,
      home: NavigationMenu(),
    );
  }
}
