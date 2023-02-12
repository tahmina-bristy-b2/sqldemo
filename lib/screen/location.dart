import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sqflitedemo/services/locationServices.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String message = '';
  String lat = '';
  String long = '';
  @override
  void initState() {
    LocationServices().getPermissionAndGetCurrentLocation().then((value) {
      lat = '${value.latitude}';
      long = '${value.longitude}';
      setState(() {});
    });

    LocationServices().getLatLong(lat, long);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Screen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
          ),
          ElevatedButton(
              onPressed: () async {
                await LocationServices()
                    .getPermissionAndGetCurrentLocation()
                    .then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';

                  setState(() {
                    message =
                        "lat======================$lat   long=====================$long";
                    print(message);
                  });
                });
              },
              child: const Center(child: Text('Your Lat Long'))),
          Center(child: Text("Latitude : $lat \n logitude : $long")),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    // getGoogleLocation(lat, long);
                    LocationServices().launchURL(lat, long);
                  },
                  child: const Text('Get You Location')))
        ],
      ),
    );
  }

  // Future<void> getGoogleLocation(String lat, String long) async {
  //   String googleUrl = 'https://maps.google.com/?q=$lat,$long';
  //   await canLaunchUrlString(googleUrl)
  //       ? await launchUrlString(googleUrl)
  //       : throw 'Could not connect the url $googleUrl';
  //   print('googleurl =============$googleUrl');
  // }
}
