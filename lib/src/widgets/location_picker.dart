import 'package:flutter/material.dart';
import 'package:library_flutter_auto_location_picker/src/models/city.dart';
import 'package:library_flutter_auto_location_picker/src/models/country.dart';
import 'package:library_flutter_auto_location_picker/src/models/state_model.dart';
import 'package:library_flutter_auto_location_picker/src/services/location_service.dart';
import 'country_dropdown.dart';
import 'state_dropdown.dart';
import 'city_dropdown.dart';

/// A widget that provides a linked set of dropdowns for selecting
/// Country, State, and City.
class LocationPicker extends StatefulWidget {
  /// Callback when the country selection changes.
  final ValueChanged<String>? onCountryChanged;

  /// Callback when the state selection changes.
  final ValueChanged<String>? onStateChanged;

  /// Callback when the city selection changes.
  final ValueChanged<String>? onCityChanged;

  /// Hint text for the country dropdown.
  final String? countryHint;

  /// Hint text for the state dropdown.
  final String? stateHint;

  /// Hint text for the city dropdown.
  final String? cityHint;

  /// Initial country name to select.
  final String? initialCountry;

  /// Initial state name to select.
  final String? initialState;

  /// Initial city name to select.
  final String? initialCity;

  /// Whether the picker is enabled.
  final bool enabled;

  /// Custom decoration for the dropdowns.
  /// If provided, this will be used as a base for all three dropdowns.
  final InputDecoration? decoration;

  /// Custom path to the JSON file containing location data.
  /// If null, the package's internal location.json will be used.
  final String? jsonPath;

  /// Optional validator for the country dropdown.
  final FormFieldValidator<String>? countryValidator;

  /// Optional validator for the state dropdown.
  final FormFieldValidator<String>? stateValidator;

  /// Optional validator for the city dropdown.
  final FormFieldValidator<String>? cityValidator;

  /// Custom loading widget to show while data is being initialized.
  final Widget? loadingWidget;

  /// Whether to show search functionality for the dropdowns.
  final bool showSearch;

  /// Hint text for the search field.
  final String? searchHint;

  /// Creates a [LocationPicker].
  const LocationPicker({
    super.key,
    this.onCountryChanged,
    this.onStateChanged,
    this.onCityChanged,
    this.countryHint,
    this.stateHint,
    this.cityHint,
    this.initialCountry,
    this.initialState,
    this.initialCity,
    this.enabled = true,
    this.decoration,
    this.jsonPath,
    this.countryValidator,
    this.stateValidator,
    this.cityValidator,
    this.loadingWidget,
    this.showSearch = false,
    this.searchHint,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  List<Country> _countries = [];
  List<StateModel> _states = [];
  List<City> _cities = [];

  String? _selectedCountry;
  String? _selectedState;
  String? _selectedCity;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await LocationService.initialize(jsonPath: widget.jsonPath);
    if (!mounted) return;

    setState(() {
      _countries = LocationService.getCountries();
      _isLoading = false;

      // Set initial values if provided
      if (widget.initialCountry != null) {
        _selectedCountry = widget.initialCountry;
        _states = LocationService.getStates(_selectedCountry!);
        
        if (widget.initialState != null) {
          _selectedState = widget.initialState;
          _cities = LocationService.getCities(_selectedCountry!, _selectedState!);
          
          if (widget.initialCity != null) {
            _selectedCity = widget.initialCity;
          }
        }
      }
    });
  }

  void _onCountryChanged(String? countryName) {
    if (countryName == _selectedCountry) return;

    setState(() {
      _selectedCountry = countryName;
      _selectedState = null;
      _selectedCity = null;
      _states = countryName != null ? LocationService.getStates(countryName) : [];
      _cities = [];
    });

    if (widget.onCountryChanged != null && countryName != null) {
      widget.onCountryChanged!(countryName);
    }
  }

  void _onStateChanged(String? stateName) {
    if (stateName == _selectedState) return;

    setState(() {
      _selectedState = stateName;
      _selectedCity = null;
      _cities = (stateName != null && _selectedCountry != null)
          ? LocationService.getCities(_selectedCountry!, stateName)
          : [];
    });

    if (widget.onStateChanged != null && stateName != null) {
      widget.onStateChanged!(stateName);
    }
  }

  void _onCityChanged(String? cityName) {
    if (cityName == _selectedCity) return;

    setState(() {
      _selectedCity = cityName;
    });

    if (widget.onCityChanged != null && cityName != null) {
      widget.onCityChanged!(cityName);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ?? const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        CountryDropdown(
          countries: _countries,
          value: _selectedCountry,
          onChanged: _onCountryChanged,
          hint: widget.countryHint,
          enabled: widget.enabled,
          decoration: widget.decoration?.copyWith(labelText: widget.countryHint ?? 'Country'),
          validator: widget.countryValidator,
          showSearch: widget.showSearch,
          searchHint: widget.searchHint,
        ),
        const SizedBox(height: 16),
        StateDropdown(
          states: _states,
          value: _selectedState,
          onChanged: _onStateChanged,
          hint: widget.stateHint,
          enabled: widget.enabled && _selectedCountry != null,
          decoration: widget.decoration?.copyWith(labelText: widget.stateHint ?? 'State'),
          validator: widget.stateValidator,
          showSearch: widget.showSearch,
          searchHint: widget.searchHint,
        ),
        const SizedBox(height: 16),
        CityDropdown(
          cities: _cities,
          value: _selectedCity,
          onChanged: _onCityChanged,
          hint: widget.cityHint,
          enabled: widget.enabled && _selectedState != null,
          decoration: widget.decoration?.copyWith(labelText: widget.cityHint ?? 'City'),
          validator: widget.cityValidator,
          showSearch: widget.showSearch,
          searchHint: widget.searchHint,
        ),
      ],
    );
  }
}
