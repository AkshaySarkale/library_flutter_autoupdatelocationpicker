import 'package:flutter/material.dart';
import 'package:library_flutter_auto_location_picker/src/models/country.dart';

/// A dropdown widget for selecting a country.
class CountryDropdown extends StatelessWidget {
  /// The list of countries to display.
  final List<Country> countries;

  /// The currently selected country name.
  final String? value;

  /// Callback when the selected country changes.
  final ValueChanged<String?> onChanged;

  /// Hint text to display when no country is selected.
  final String? hint;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Custom decoration for the dropdown.
  final InputDecoration? decoration;

  /// Optional validator for the dropdown.
  final FormFieldValidator<String>? validator;

  /// Creates a [CountryDropdown].
  const CountryDropdown({
    super.key,
    required this.countries,
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
      items: countries.map((country) {
        return DropdownMenuItem<String>(
          value: country.name,
          child: Text(country.name),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      hint: Text(hint ?? 'Select Country'),
      decoration: decoration ?? const InputDecoration(labelText: 'Country'),
    );
  }
}
