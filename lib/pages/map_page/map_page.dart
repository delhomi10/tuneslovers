import 'package:flutter/material.dart';
import 'package:tunes_lovers/models/person.dart';

class MapPage extends StatelessWidget {
  final Person person;
  final List<String> followedPerformers;

  const MapPage(
      {Key? key, required this.person, required this.followedPerformers})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          key: key,
          pinned: true,
          title: const Text("Map"),
        ),
      ],
    );
  }
}
