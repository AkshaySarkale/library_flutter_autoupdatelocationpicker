import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:library_flutter_auto_location_picker/src/models/state_model.dart';
import 'package:library_flutter_auto_location_picker/src/models/city.dart';
import 'package:library_flutter_auto_location_picker/src/models/country.dart';
class LocationService {
  static List<Country> _countries = [];

  static Future<void> initialize({String? jsonPath}) async {
    if (_countries.isNotEmpty && jsonPath == null) return;

    try {
      final path = jsonPath ?? 'packages/library_flutter_auto_location_picker/assets/data/location.json';
      final jsonString = await rootBundle.loadString(path);
      final List<dynamic> jsonData = json.decode(jsonString);

      _countries = jsonData.map((e) => Country.fromJson(e)).toList();

    _countries.sort((a, b) => a.name.compareTo(b.name));
      for (var country in _countries) {
        country.states.sort((a, b) => a.name.compareTo(b.name));
        for (var state in country.states) {
          state.cities.sort((a, b) => a.name.compareTo(b.name));
        }
      }
    } catch (e) {
      _countries = [];
    }
  }

  static List<Country> getCountries() {
    return _countries;
  }

  static List<StateModel> getStates(String countryName) {
    try {
      return _countries.firstWhere((c) => c.name == countryName)
          .states;
    } catch (_) {
      return [];
    }
  }

  static List<City> getCities(
    String countryName,
    String stateName,
  ) {
    try {
      return _countries.firstWhere((c) => c.name == countryName)
          .states.firstWhere((s) => s.name == stateName)
          .cities;
    } catch (_) {
      return [];
    }
  }
}
