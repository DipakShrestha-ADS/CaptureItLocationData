import 'package:location/location.dart';

class LocationProvider {
  //initializing locatin object
  final location = new Location();

  //get locationdata that includes location latitude, longitude and many more
  Future<LocationData> getLocation() async {
    return await location.getLocation();
  }

  //check location service is enabled or not if not request location service
  Future<bool> checkIfLocationServiceEnabled() async {
    bool _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    return _serviceEnabled;
  }

  //check location permission granted or not if not request the permission
  Future<bool> checkIfLocationPermissionGranted() async {
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.GRANTED) {
        return false;
      }
    }
    if (_permissionGranted == PermissionStatus.GRANTED) {
      return true;
    } else {
      return false;
    }
  }
}
