import 'package:flutter/material.dart';
import 'dart:async';

import '../../utilities/guide_http_client.dart';

import '../../models/guide.dart';
import '../../models/loading_guide.dart';

import 'components/add_or_search_guide.dart';
import 'components/loading_guide_list.dart';
import 'components/guide_list.dart';

import '../../styles/theme.dart';

class GuideListPage extends StatefulWidget {
  const GuideListPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<GuideListPage> createState() => _GuideListPageState();
}

class _GuideListPageState extends State<GuideListPage> with SingleTickerProviderStateMixin {
  Map<String, Guide> _guides = {};
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

    // Add defaults
    if (_guides.isEmpty) {
      _addGuide("tie a tie");
      _addGuide("do a kickflip");
      _addGuide("clean dirty glassware");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite(Guide guides) {
      setState(() {
          guides.isFavorite = !guides.isFavorite;
          if (guides.isFavorite) {
              _favoriteGuides[guides.title] = guides;
          } else {
              _favoriteGuides.remove(guides.title);
          }
      });
      _sortGuides();
  }

  void _sortGuides() {
      List<Guide> sortedGuides = _guides.values.toList();
      sortedGuides.sort((a, b) {
          if (a.isFavorite == b.isFavorite) {
              return a.title.compareTo(b.title);
          } else {
              return a.isFavorite ? -1 : 1;
          }
      });
      setState(() {
          _guides = sortedGuides.asMap().map((index, value) => MapEntry(value.title, value));
      });
  }

  Future<void> _addGuide(String title) async {
    GuideHTTPClient httpClient = GuideHTTPClient(guideTitle: title);

    LoadingGuide guides = _loadingGuides.firstWhere((r) => r.title == title, orElse: () => LoadingGuide(title: title, startTime: DateTime.now()));
    guides.status = LoadingStatus.loading;

    // Add to loading guidess
    setState(() {
      _loadingGuides.remove(guides);
      _loadingGuides.add(guides);
    });

    // Switch to the "Loading" tab
    _tabController.animateTo(1);

    // Try fetching the guides immediately
    httpClient.fetchGuide();
    if (await httpClient.guideExists()) {
      final guides = await httpClient.fetchGuide();
      if (guides != null) {
        setState(() {
            _loadingGuides.removeWhere((r) => r.title == title);
            _guides[guides.title] = guides;
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
        final guides = await httpClient.fetchGuide();
        if (guides != null) {
          setState(() {
              _loadingGuides.removeWhere((r) => r.title == title);
              _guides[guides.title] = guides;
          });
          _sortGuides();

          // Switch to the "Guides" tab
          _tabController.animateTo(0);
        }
        return;
      }
    }

    // If the guides still doesn't exist after 5 minutes, mark it as failed
    setState(() {
      _loadingGuides.removeWhere((r) => r.title == title);
      _loadingGuides.add(LoadingGuide(title: title, startTime: DateTime.now(), status: LoadingStatus.failure));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor, // Adding primary color as AppBar background
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: AppTheme.primaryFont,
            color: AppTheme.tabColor, // Set the AppBar title color to tab color
          )
        ),
        elevation: 5, 
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.tabColor, 
          labelColor: AppTheme.tabColor,
          unselectedLabelColor: AppTheme.unselectedTabColor,
          tabs: const [
            Tab(icon: Icon(Icons.check_box), text: 'Guides'),
            Tab(icon: Icon(Icons.hourglass_empty), text: 'Loading Guides'),
          ],
        ),
      ),
      body: Container(
        color: AppTheme.lightBackgroundColor,
        child: TabBarView(
          controller: _tabController,
          children: [
            Column(
              children: [
                AddOrSearchGuide(searchController: _searchController, onAddGuide: _addGuide),
                Flexible(
                  child: GuideList(
                    _searchTerm == ""
                        ? _guides.values.toList()
                        : _guides.values
                            .where((guides) =>
                                guides.title.toLowerCase().contains(_searchTerm.toLowerCase()))
                            .toList(),
                    _toggleFavorite,
                  ),
                ),
              ],
            ),
            LoadingGuideList(_loadingGuides, retryLoadingGuide: _addGuide),
          ],
        ),
      )
    );
  }
}