import 'package:captureit/src/resources/location_provider.dart';
import 'package:location/location.dart';

class LocationRepository {
  final _locationProvider = LocationProvider();

  Future<LocationData> getLocationDAta() async {
    return _locationProvider.getLocation();
  }

  Future<bool> checkIfLocationServiceEnabled() async {
    return _locationProvider.checkIfLocationServiceEnabled();
  }

  Future<bool> checkIfLocationPermissionGranted() async {
    return _locationProvider.checkIfLocationPermissionGranted();
  }
}
