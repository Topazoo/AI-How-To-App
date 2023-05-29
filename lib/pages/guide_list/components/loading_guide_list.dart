import 'package:flutter/material.dart';

import '../../../models/loading_guide.dart';

class LoadingGuideList extends StatelessWidget {
  final List<LoadingGuide> loadingRecipes;
  final Function(String) retryLoadingGuide;
  
  const LoadingGuideList(this.loadingRecipes, {Key? key, required this.retryLoadingGuide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: loadingRecipes.length,
      itemBuilder: (context, index) {
        final loadingRecipe = loadingRecipes[index];
        return ListTile(
          title: Text(loadingRecipe.title),
          subtitle: loadingRecipe.status == LoadingStatus.loading
              ? const Text('Loading... (this can take up to 5 minutes)')
              : const Text('Failed to load (tap to retry)'),
                          onTap: loadingRecipe.status == LoadingStatus.failure
                  ? () {
                      // Retry loading the recipe.
                      retryLoadingGuide(loadingRecipe.title);
                    }
                  : null,
          trailing: Icon(loadingRecipe.status == LoadingStatus.loading
              ? Icons.hourglass_empty
              : Icons.error_outline,
              color: loadingRecipe.status == LoadingStatus.loading
              ? Colors.blue
              : Colors.red),
        );
      },
    );
  }
}
