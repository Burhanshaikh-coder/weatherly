import 'package:flutter/material.dart';

class WeatherSearchBar extends StatefulWidget {
  const WeatherSearchBar({super.key, required this.onSearch});

  final ValueChanged<String> onSearch;

  @override
  State<WeatherSearchBar> createState() => _WeatherSearchBarState();
}

class _WeatherSearchBarState extends State<WeatherSearchBar> {
  final _controller = TextEditingController();
  static const List<String> _citySuggestions = [
    'New York',
    'London',
    'Tokyo',
    'Delhi',
    'Mumbai',
    'Paris',
    'Sydney',
    'Dubai',
    'San Francisco',
    'Singapore',
    'Toronto',
    'Berlin',
    'Moscow',
    'Istanbul',
    'Bangkok',
    'Los Angeles',
    'Chicago',
    'Rome',
    'Barcelona',
    'Jakarta',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Autocomplete<String>(
        optionsBuilder: (textEditingValue) {
          final query = textEditingValue.text.trim().toLowerCase();
          if (query.isEmpty) {
            return const Iterable<String>.empty();
          }
          return _citySuggestions.where(
            (city) => city.toLowerCase().contains(query),
          );
        },
        onSelected: (selection) {
          _controller.text = selection;
          widget.onSearch(selection.trim());
        },
        fieldViewBuilder: (
          context,
          textEditingController,
          focusNode,
          onFieldSubmitted,
        ) {
          _controller.value = textEditingController.value;
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            cursorColor: Colors.white,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (value) => widget.onSearch(value.trim()),
            decoration: InputDecoration(
              hintText: 'Search city...',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                ),
                onPressed:
                    () => widget.onSearch(textEditingController.text.trim()),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 18),
            ),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                constraints: const BoxConstraints(
                  maxHeight: 240,
                  maxWidth: 320,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2A4A).withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final city = options.elementAt(index);
                    return ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.location_city_rounded,
                        color: Colors.white70,
                      ),
                      title: Text(
                        city,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () => onSelected(city),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
