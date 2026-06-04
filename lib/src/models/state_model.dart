import 'city.dart';
class StateModel {
  final String name;
  final List<City> cities;
  StateModel({
    required this.name,
    required this.cities,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      name: json['name'],
      cities: (json['cities'] as List).map((e) => City.fromJson(e)).toList(),
    );
  }
}
