import 'package:flutter/material.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class WeatherSearchBar extends StatelessWidget {
  final bool isDarkMode;
  final TextEditingController controller;
  final Function(String) onSearch;

  const WeatherSearchBar({
    Key? key,
    required this.isDarkMode,
    required this.controller,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: AnimSearchBar(
            width: 200,
            helpText: "Search city...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.black : Colors.white,
            ),
            textController: controller,
            color: isDarkMode ? Colors.white54 : Colors.black45,
            searchIconColor: isDarkMode ? Colors.black : Colors.white,
            textFieldColor: isDarkMode ? Colors.white70 : Colors.black45,
            textFieldIconColor: isDarkMode ? Colors.black : Colors.white,
            boxShadow: true,
            rtl: true,
            autoFocus: true,
            closeSearchOnSuffixTap: true,
            suffixIcon: Icon(
              Icons.search,
              color: isDarkMode ? Colors.black : Colors.white,
              size: 25,
            ),
            onSuffixTap: () {
              if (controller.text.isNotEmpty) {
                onSearch(controller.text);
              }
            },
            onSubmitted: onSearch,
          ),
        ),
      ),
    );
  }
}