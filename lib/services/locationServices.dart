// import 'dart:ffi';

// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart' as t;
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// ////pink=F86592 FB81A6
// ///purple =9B86FB  D4CCFC
// /// orange= FFC581 FCE0C2

// class LocationServices {
//   Future getPermissionAndGetCurrentLocation() async {
//     bool serviceEnabled = await t.Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }

//     t.LocationPermission permission = await t.Geolocator.checkPermission();
//     if (permission == t.LocationPermission.denied) {
//       permission = await t.Geolocator.requestPermission();
//       if (permission == t.LocationPermission.deniedForever) {
//         // Permissions are denied forever, handle appropriately.
//         return Future.error(
//             Exception('Location permissions are permanently denied.'));
//       }

//       if (permission == t.LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error(Exception('Location permissions are denied.'));
//       }
//     }

//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     return await t.Geolocator.getCurrentPosition();
//     // // bool isServiceEnable;
//     // LocationPermission permission;
//     // // isServiceEnable = await Geolocator.isLo\cationServiceEnabled();
//     // // isServiceEnable = await Geolocator.isLocationServiceEnabled();
//     // permission = await Geolocator.checkPermission();
//     // if (permission == LocationPermission.denied) {
//     //   permission = await Geolocator.requestPermission();
//     //   if (permission == LocationPermission.deniedForever) {
//     //     return Future.error('This device is denied for location permission');
//     //   }
//     // }

//     // return await Geolocator.getCurrentPosition();
//   }

//   // Future<Position?> determinePosition() async {
//   //   LocationPermission permission;
//   //   permission = await Geolocator.checkPermission();
//   //   if (permission == LocationPermission.denied) {
//   //     permission = await Geolocator.requestPermission();
//   //     if (permission == LocationPermission.deniedForever) {
//   //       return Future.error('Location Not Available');
//   //     }
//   //   } else {
//   //     throw Exception('Error');
//   //   }
//   //   return await Geolocator.getCurrentPosition();
//   // }

//   void getLatLong(
//     double lat,
//     double long,
//     String address,
//   ) async {
//     // ignore: prefer_const_constructors
//     t.LocationSettings locationSettings = t.LocationSettings(
//         accuracy: t.LocationAccuracy.high, distanceFilter: 100);

//     t.Geolocator.getPositionStream(locationSettings: locationSettings)
//         .listen((value) {
//       lat = value.latitude;
//       long = value.longitude;
//       address = getAddress(lat, long) as String;
//       // print("ASsssssssssssssssssssssssssssss==============$address");
//     });
//   }

//   Future<List<Placemark>> getAddress(double lat, double long) async {
//     List<Placemark> placeMark = await placemarkFromCoordinates(lat, long);
//     // String? placeName = placeMark.first.subLocality;
//     print("object============================${placeMark.first.subLocality}");
//     return placeMark;
//   }

//   launchURL(String lat, String long) async {
//     final String googleMapslocationUrl =
//         "https://www.google.com/maps/search/?api=1&query=$lat,$long";
//     final String encodedURl = Uri.encodeFull(googleMapslocationUrl);
//     if (await canLaunchUrlString(encodedURl)) {
//       await launchUrlString(encodedURl);
//     } else {
//       print('Could not launch $encodedURl');
//       throw 'Could not launch $encodedURl';
//     }
//   }
// }

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

////pink=F86592 FB81A6
///purple =9B86FB  D4CCFC
/// orange= FFC581 FCE0C2
class LocationServices {
  Future<Position> getPermissionAndGetCurrentLocation() async {
    bool isServiceEnable;
    LocationPermission permission;
    isServiceEnable = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('This device is denied for location permission');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Future.error(
          'This device is denied for location permission forever, We can\'t access the location');
    }
    return await Geolocator.getCurrentPosition();
  }

  void getLatLong(
    double lat,
    double long,
    String address,
  ) async {
    // ignore: prefer_const_constructors
    LocationSettings locationSettings = await LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 100);

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((value) {
      lat = value.latitude;
      long = value.longitude;
      address = getAddress(lat, long) as String;
      // print("ASsssssssssssssssssssssssssssss==============$address");
    });
  }

  Future<List<Placemark>> getAddress(double lat, double long) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(lat, long);
    String? placeName = placeMark.first.subLocality;
    print("object============================${placeMark.first.subLocality}");
    return placeMark;
  }

  launchURL(String lat, String long) async {
    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$lat,$long";
    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);
    if (await canLaunchUrlString(encodedURl)) {
      await launchUrlString(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }
}
