import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:tunes_lovers/models/event.dart';
import 'package:tunes_lovers/models/person.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBuilder extends StatefulWidget {
  final Person person;
  const MapBuilder({Key? key, required this.person}) : super(key: key);

  @override
  State<MapBuilder> createState() => _MapBuilderState();
}

class _MapBuilderState extends State<MapBuilder> {
  final Map<String, Marker> _markers = {};

  Future<void> _onMapCreated(
      GoogleMapController controller, List<Event> events) async {
    setState(() async {
      _markers.clear();
      for (var event in events) {
        List<Location> locations =
            await locationFromAddress(event.address!.formattedAddress);
        Location address = locations.first;

        _markers[event.title] = Marker(
          markerId: MarkerId(event.title),
          position: LatLng(address.latitude, address.longitude),
          infoWindow: InfoWindow(
            title: event.title,
            snippet: event.address!.formattedAddress,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Event").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SliverToBoxAdapter(
            key: widget.key,
            child: Center(
              key: widget.key,
              child: CircularProgressIndicator(
                key: widget.key,
              ),
            ),
          );
        } else {
          List<Event> events =
              snapshot.data!.docs.map((e) => Event.fromJson(e.data())).toList();

          return Scaffold(
            appBar: AppBar(title: TextFormField()),
            body: GoogleMap(
              onMapCreated: (controller) {
                _onMapCreated(controller, events);
              },
              buildingsEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              mapType: MapType.normal,
              trafficEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              onTap: (LatLng latlng) {},
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              markers: _markers.values.toSet(),
            ),
          );
        }
      },
    );
  }
}
