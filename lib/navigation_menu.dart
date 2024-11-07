import 'package:fitnest/features/maps/screens/map_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'features/dashboard/dashboard.dart';
import 'features/events/screens/create_event.dart';
import 'features/home/display_events.dart';
import 'features/home/home.dart';
import 'features/personalization/screens/profile/profile.dart';
import 'utils/constants/colors.dart';
import 'utils/helpers/helper_functions.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _LandingPageState();
}

class _LandingPageState extends State<NavigationMenu> {
  int selectedIndex = 0;
  List<dynamic> pages = [
    EventListPage(),
    EventsMapPage(),
    EventForm(),
    const DashboardScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.white,
          activeColor: Colors.blue,
          initialActiveIndex: selectedIndex,
          elevation: 0,
          style: TabStyle.fixedCircle,
          color: Colors.blue,
          items: [
            TabItem(icon: Icon(Iconsax.home), title: ''),
            TabItem(icon: Icon(Iconsax.map), title: ''),
            const TabItem(icon: Icons.add, title: ''),
            TabItem(icon: Icon(Iconsax.chart), title: ''),
            TabItem(icon: Icon(Iconsax.user), title: ''),
          ],
          onTap: (int i) {
            setState(() {
              selectedIndex = i;
            });
          },
        ));
  }
}
