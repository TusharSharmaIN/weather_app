import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationData {
  late double latitude;
  late double longitude;
  String subLocality = "";
  String locality = "";

  LocationData({required final long, required final lat}) {
    latitude = lat;
    longitude = long;
  }

  void setLocality({required final subLoc, required final loc}) {
    subLocality = subLoc;
    locality = loc;
  }
}

class LocationService {
  late LocationData data;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return true;
  }

  Future<void> getAddressFromCoordinates(Position position) async {
    await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    ).then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      data.setLocality(subLoc: place.subLocality, loc: place.locality);
    }).catchError((e) {
      throw Future.error("Can not get address, from coordinates", e);
    });
  }

  Future<LocationData> getCoordinates() async {
    if (await _handleLocationPermission()) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      data = LocationData(long: position.longitude, lat: position.latitude);
      await getAddressFromCoordinates(position);
      return data;
    } else {
      return Future.error("Can not get location, check permissions");
    }
  }
}
