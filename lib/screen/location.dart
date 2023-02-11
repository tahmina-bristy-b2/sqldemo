import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:sqflitedemo/services/locationServices.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late String lat;
  late String long;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                await LocationServices()
                    .getPermissionAndGetCurrentLocation()
                    .then((value) {
                  lat = '${value.latitude}';
                  long = '${value.longitude}';
                  print('lat==========================$lat');
                  print('lng==========================$long');
                });
              },
              child: Text('Get Lat Long'))
        ],
      ),
    );
  }
}
