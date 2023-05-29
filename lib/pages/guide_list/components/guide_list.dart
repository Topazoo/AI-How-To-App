import 'package:flutter/material.dart';

import '../../../models/guide.dart';

import '../../guide_detail_page/page.dart';

import '../../../styles/theme.dart';

class GuideList extends StatelessWidget {
  final List<Guide> recipes;
  final void Function(Guide recipe) onToggleFavorite;

  const GuideList(this.recipes, this.onToggleFavorite, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: recipes.length,
      separatorBuilder: (context, index) => Divider(
        color: AppTheme.darkTextColor, // This will create a line between each guide
      ),
      itemBuilder: (BuildContext context, int index) {
        final recipe = recipes[index];
        return ListTile(
          leading: Icon(
            Icons.article_rounded, // Using article icon for guide
            color: AppTheme.primaryIconColor,
          ),
          title: Text(
            recipe.title,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              color: AppTheme.darkTextColor,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuideDetailPage(guide: recipes[index]),
              ),
            );
          },
          trailing: IconButton(
            icon: Icon(recipe.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => onToggleFavorite(recipe),
            color: recipe.isFavorite ? Colors.red : AppTheme.secondaryIconColor,
          ),
        );
      },
    );
  }
}
