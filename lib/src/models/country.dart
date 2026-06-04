import 'state_model.dart';
class Country {
  final String name;
  final List<StateModel> states;

  Country({required this.name, required this.states,});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      states: (json['states'] as List).map((e) => StateModel.fromJson(e)).toList(),
    );
  }
}
