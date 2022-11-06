import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:tunes_lovers/app_drawer/app_drawer.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:tunes_lovers/pages/dashboard/dashboard.dart';
import 'package:tunes_lovers/pages/map_page/map_page.dart';
import 'package:tunes_lovers/pages/feeds_page/feeds_page.dart';
import 'package:tunes_lovers/pages/profile_page/profile_page.dart';
import 'package:tunes_lovers/services/theme_service/dark_theme.dart';
import 'package:tunes_lovers/services/theme_service/light_theme.dart';
import 'package:tunes_lovers/services/theme_service/theme_service.dart';

class HomeScreen extends StatefulWidget {
  final Person person;
  const HomeScreen({Key? key, required this.person}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> pages(Person person, List<String>? followedPerformers) => [
        Dashboard(person: person, followedPerformers: followedPerformers ?? []),
        MapPage(person: person, followedPerformers: followedPerformers ?? []),
        FeedsPage(person: person, followedPerformers: followedPerformers ?? []),
        ProfilePage(
            person: person, followedPerformers: followedPerformers ?? []),
      ];
  List<BottomNavyBarItem> get bottomItems => [
        BottomNavyBarItem(
          icon: const Icon(Icons.dashboard),
          title: const Text("Home"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: ThemeService.isDark(context)
              ? DarkTheme.secondaryIconColor
              : LightTheme.secondaryIconColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.map),
          title: const Text("Map"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: ThemeService.isDark(context)
              ? DarkTheme.secondaryIconColor
              : LightTheme.secondaryIconColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.feed),
          title: const Text("Feeds"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: ThemeService.isDark(context)
              ? DarkTheme.secondaryIconColor
              : LightTheme.secondaryIconColor,
        ),
        BottomNavyBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Profile"),
          activeColor: Theme.of(context).primaryColor,
          inactiveColor: ThemeService.isDark(context)
              ? DarkTheme.secondaryIconColor
              : LightTheme.secondaryIconColor,
        ),
      ];
  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      // Handle errors
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: AppDrawer(
        key: widget.key,
        person: widget.person,
      ),
      key: widget.key,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Following")
              .doc(widget.person.userId)
              .collection("Following")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                key: widget.key,
                child: CircularProgressIndicator(key: widget.key),
              );
            }
            List<String>? followedPerformers =
                snapshot.data!.docs.map((e) => e.id).toList();
            return pages(widget.person, followedPerformers)[currentIndex];
          }),
      bottomNavigationBar: BottomNavyBar(
          curve: Curves.bounceOut,
          backgroundColor: Theme.of(context).cardTheme.color,
          selectedIndex: currentIndex,
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: bottomItems),
    );
  }
}
