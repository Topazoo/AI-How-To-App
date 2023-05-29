// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
class AddOrSearchGuide extends StatefulWidget {
  final TextEditingController searchController;
  final Function(String) onAddGuide;

  const AddOrSearchGuide({super.key, required this.searchController, required this.onAddGuide});

  @override
  _AddOrSearchGuideState createState() => _AddOrSearchGuideState();
}

class _AddOrSearchGuideState extends State<AddOrSearchGuide> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.searchController,
              onChanged: (text) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: "How do I...",
                fillColor: Colors.white,
                filled: true,
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
            icon: const Icon(Icons.add),
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
