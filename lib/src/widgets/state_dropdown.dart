import 'package:flutter/material.dart';
import 'package:library_flutter_auto_location_picker/src/models/state_model.dart';

/// A dropdown widget for selecting a state or province with optional search functionality.
class StateDropdown extends StatelessWidget {
  final List<StateModel> states;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? hint;
  final bool enabled;
  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final bool showSearch;
  final String? searchHint;

  const StateDropdown({
    super.key,
    required this.states,
    required this.onChanged,
    this.value,
    this.hint,
    this.enabled = true,
    this.decoration,
    this.validator,
    this.showSearch = false,
    this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    if (showSearch) {
      return InkWell(
        onTap: enabled ? () => _showSearchSheet(context) : null,
        child: IgnorePointer(
          child: TextFormField(
            key: ValueKey(value),
            initialValue: value,
            decoration: (decoration ?? const InputDecoration(labelText: 'State')).copyWith(
              hintText: hint ?? 'Select State',
              suffixIcon: const Icon(Icons.arrow_drop_down),
            ),
            validator: validator,
            enabled: enabled,
          ),
        ),
      );
    }

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

  void _showSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return _SearchSheet(
          items: states.map((s) => s.name).toList(),
          onSelected: onChanged,
          title: searchHint ?? 'Search State',
        );
      },
    );
  }
}

class _SearchSheet extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String?> onSelected;
  final String title;

  const _SearchSheet({
    required this.items,
    required this.onSelected,
    required this.title,
  });

  @override
  State<_SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_SearchSheet> {
  late List<String> filteredItems;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void _filter(String query) {
    setState(() {
      filteredItems = widget.items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: widget.title,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      _filter('');
                    },
                  ),
                ),
                onChanged: _filter,
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredItems[index]),
                    onTap: () {
                      widget.onSelected(filteredItems[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
