import 'package:geolocator/geolocator.dart';

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
}
