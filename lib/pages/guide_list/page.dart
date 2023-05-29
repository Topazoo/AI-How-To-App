import 'package:flutter/material.dart';
import 'dart:async';

import '../../utilities/guide_http_client.dart';

import '../../models/guide.dart';
import '../../models/loading_guide.dart';

import 'components/add_guide_dialogue.dart';
import 'components/loading_guide_list.dart';
import 'components/recipe_list.dart';

class GuideListPage extends StatefulWidget {
  const GuideListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GuideListPage> createState() => _GuideListPageState();
}

class _GuideListPageState extends State<GuideListPage> with SingleTickerProviderStateMixin {
  Map<String, Guide> _recipes = {};
  final Map<String, Guide> _favoriteGuides = {};
  final List<LoadingGuide> _loadingGuides = [];

  late TabController _tabController;

  // Used for the search bar
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = "";
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchTerm = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(Guide recipe) {
      setState(() {
          recipe.isFavorite = !recipe.isFavorite;
          if (recipe.isFavorite) {
              _favoriteGuides[recipe.title] = recipe;
          } else {
              _favoriteGuides.remove(recipe.title);
          }
      });
      _sortGuides();
  }

  void _sortGuides() {
      List<Guide> sortedGuides = _recipes.values.toList();
      sortedGuides.sort((a, b) {
          if (a.isFavorite == b.isFavorite) {
              return a.title.compareTo(b.title);
          } else {
              return a.isFavorite ? -1 : 1;
          }
      });
      setState(() {
          _recipes = sortedGuides.asMap().map((index, value) => MapEntry(value.title, value));
      });
  }

  Future<void> _addGuide(String title) async {
    GuideHTTPClient httpClient = GuideHTTPClient(guideTitle: title);

    LoadingGuide recipe = _loadingGuides.firstWhere((r) => r.title == title, orElse: () => LoadingGuide(title: title, startTime: DateTime.now()));
    recipe.status = LoadingStatus.loading;

    // Add to loading recipes
    setState(() {
      _loadingGuides.remove(recipe);
      _loadingGuides.add(recipe);
    });

    // Switch to the "Loading" tab
    _tabController.animateTo(1);

    // Try fetching the recipe immediately
    httpClient.fetchGuide();
    if (await httpClient.guideExists()) {
      final recipe = await httpClient.fetchGuide();
      if (recipe != null) {
        setState(() {
            _loadingGuides.removeWhere((r) => r.title == title);
            _recipes[recipe.title] = recipe;
        });
        _sortGuides();

        // Switch to the "Guides" tab
        _tabController.animateTo(0);
      }
      return;
    }

    // Retry every 20 seconds for up to 5 minutes
    int totalSeconds = 300;
    int delaySeconds = 20; 
    for (int i = 0; i < totalSeconds/delaySeconds; i++) {
      await Future.delayed(Duration(seconds: delaySeconds));
      if (await httpClient.guideExists()) {
        final recipe = await httpClient.fetchGuide();
        if (recipe != null) {
          setState(() {
              _loadingGuides.removeWhere((r) => r.title == title);
              _recipes[recipe.title] = recipe;
          });
          _sortGuides();

          // Switch to the "Guides" tab
          _tabController.animateTo(0);
        }
        return;
      }
    }

    // If the recipe still doesn't exist after 5 minutes, mark it as failed
    setState(() {
      _loadingGuides.removeWhere((r) => r.title == title);
      _loadingGuides.add(LoadingGuide(title: title, startTime: DateTime.now(), status: LoadingStatus.failure));
    });
  }

  void _showAddGuideDialog(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddGuideDialog(textEditingController, _addGuide);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.check_box), text: 'Guides'),
            Tab(icon: Icon(Icons.hourglass_empty), text: 'Loading Guides'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(children: [
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus(); // Unfocus the search field
                setState(() {
                  _searchTerm = _searchController.text;
                });
              },
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: "Search",
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            Flexible(child:
              GuideList(_searchTerm == "" ? 
                _recipes.values.toList() : 
                _recipes.values.where((recipe) => recipe.title.toLowerCase().contains(_searchTerm.toLowerCase())).toList(),
                _toggleFavorite
              )
            ),
          ]),
          LoadingGuideList(_loadingGuides, retryLoadingGuide: _addGuide),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddGuideDialog(context);
        },
        tooltip: 'Add Guide',
        child: const Icon(Icons.add),
      ),
    );
  }
}