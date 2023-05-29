import 'package:flutter/material.dart';

import '../../../styles/theme.dart';

class AddOrSearchGuide extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onAddGuide;

  const AddOrSearchGuide({Key? key, required this.searchController, required this.onAddGuide}) : super(key: key);

  @override
  _AddOrSearchGuideState createState() => _AddOrSearchGuideState();
}

class _AddOrSearchGuideState extends State<AddOrSearchGuide> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:25.0, horizontal: 15.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.searchController,
              onChanged: (text) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "How do I...",
                fillColor: AppTheme.tabColor,
                filled: true,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppTheme.primaryIconColor,
                ),
                hintStyle: TextStyle(
                  fontFamily: AppTheme.primaryFont,
                  color: AppTheme.darkTextColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(.0), // Set border radius to be less rounded
                  borderSide: BorderSide(
                    color: AppTheme.darkTextColor.withOpacity(1), // Adds a thin border to the search bar
                  ),
                ),
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  widget.onAddGuide(text);
                  widget.searchController.clear();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: AppTheme.primaryIconColor,
            ),
            onPressed: widget.searchController.text.isNotEmpty
                ? () {
                    widget.onAddGuide(widget.searchController.text);
                    widget.searchController.clear();
                  }
                : null, // disabled when there's no text
          ),
        ],
      ),
    );
  }
}
