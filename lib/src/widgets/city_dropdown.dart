import 'package:flutter/material.dart';
import 'package:library_flutter_auto_location_picker/src/models/city.dart';

/// A dropdown widget for selecting a city.
class CityDropdown extends StatelessWidget {
  /// The list of cities to display.
  final List<City> cities;

  /// The currently selected city name.
  final String? value;

  /// Callback when the selected city changes.
  final ValueChanged<String?> onChanged;

  /// Hint text to display when no city is selected.
  final String? hint;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Custom decoration for the dropdown.
  final InputDecoration? decoration;

  /// Optional validator for the dropdown.
  final FormFieldValidator<String>? validator;

  /// Creates a [CityDropdown].
  const CityDropdown({
    super.key,
    required this.cities,
    required this.onChanged,
    this.value,
    this.hint,
    this.enabled = true,
    this.decoration,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: value,
      items: cities.map((city) {
        return DropdownMenuItem<String>(
          value: city.name,
          child: Text(city.name),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      hint: Text(hint ?? 'Select City'),
      decoration: decoration ?? const InputDecoration(labelText: 'City'),
    );
  }
}
