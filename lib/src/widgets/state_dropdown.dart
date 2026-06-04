import 'package:flutter/material.dart';
import 'package:library_flutter_auto_location_picker/src/models/state_model.dart';

/// A dropdown widget for selecting a state or province.
class StateDropdown extends StatelessWidget {
  /// The list of states to display.
  final List<StateModel> states;

  /// The currently selected state name.
  final String? value;

  /// Callback when the selected state changes.
  final ValueChanged<String?> onChanged;

  /// Hint text to display when no state is selected.
  final String? hint;

  /// Whether the dropdown is enabled.
  final bool enabled;

  /// Custom decoration for the dropdown.
  final InputDecoration? decoration;

  /// Optional validator for the dropdown.
  final FormFieldValidator<String>? validator;

  /// Creates a [StateDropdown].
  const StateDropdown({
    super.key,
    required this.states,
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
      items: states.map((state) {
        return DropdownMenuItem<String>(
          value: state.name,
          child: Text(state.name),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: validator,
      hint: Text(hint ?? 'Select State'),
      decoration: decoration ?? const InputDecoration(labelText: 'State'),
    );
  }
}
