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
    String lat,
    String long,
  ) async {
    // ignore: prefer_const_constructors
    LocationSettings locationSettings = await LocationSettings(
        accuracy: LocationAccuracy.high, distanceFilter: 100);

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((value) {
      lat = value.latitude.toString();
      long = value.longitude.toString();
    });
  }

  Future<List<Placemark>> getAddress(double lat, double long) async {
    List<Placemark> placeMark = await placemarkFromCoordinates(lat, long);
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
