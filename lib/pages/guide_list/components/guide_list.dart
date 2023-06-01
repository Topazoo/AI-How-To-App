import 'package:flutter/material.dart';

import '../../../models/guide.dart';

import '../../guide_detail_page/page.dart';

import '../../../styles/theme.dart';

class GuideList extends StatelessWidget {
  final List<Guide> guides;
  final void Function(Guide guide) onToggleFavorite;

  const GuideList(this.guides, this.onToggleFavorite, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: guides.length,
      separatorBuilder: (context, index) => Divider(
        color: AppTheme.darkTextColor, // This will create a line between each guide
      ),
      itemBuilder: (BuildContext context, int index) {
        final guide = guides[index];
        return ListTile(
          leading: Icon(
            Icons.article_rounded, // Using article icon for guide
            color: AppTheme.primaryIconColor,
          ),
          title: Text(
            guide.title,
            style: TextStyle(
              fontFamily: AppTheme.primaryFont,
              color: AppTheme.darkTextColor,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuideDetailPage(guide: guides[index]),
              ),
            );
          },
          trailing: IconButton(
            icon: Icon(guide.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () => onToggleFavorite(guide),
            color: guide.isFavorite ? Colors.red : AppTheme.secondaryIconColor,
          ),
        );
      },
    );
  }
}
