import 'package:flutter/material.dart';

import '../../../models/guide.dart';

import '../../guide_detail_page/page.dart';

class GuideList extends StatelessWidget {
  final List<Guide> recipes;
  final void Function(Guide recipe) onToggleFavorite;

  const GuideList(this.recipes, this.onToggleFavorite, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (BuildContext context, int index) {
        final recipe = recipes[index];
        return ListTile(
          title: Text(recipe.title),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HowToGuideDetailPage(guide: recipes[index]),
              ),
            );
          },
          // Here we add the favorite button
          trailing: IconButton(
            icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => onToggleFavorite(recipe),
            color: recipe.isFavorite ? Colors.red : null,
          ),
        );
      },
    );
  }
}
