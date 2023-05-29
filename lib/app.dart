import 'package:flutter/material.dart';
import 'pages/guide_list/page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI How To',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const GuideListPage(title: 'AI How-To'),
    );
  }
}