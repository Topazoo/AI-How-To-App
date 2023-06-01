import 'package:flutter/material.dart';

import '../../../models/loading_guide.dart';

class LoadingGuideList extends StatelessWidget {
  final List<LoadingGuide> loadingGuides;
  final Function(String) retryLoadingGuide;
  
  const LoadingGuideList(this.loadingGuides, {Key? key, required this.retryLoadingGuide}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: loadingGuides.length,
      itemBuilder: (context, index) {
        final loadingGuide = loadingGuides[index];
        return ListTile(
          title: Text(loadingGuide.title),
          subtitle: loadingGuide.status == LoadingStatus.loading
              ? const Text('Loading... (this can take up to 5 minutes)')
              : const Text('Failed to load (tap to retry)'),
                          onTap: loadingGuide.status == LoadingStatus.failure
                  ? () {
                      // Retry loading the guide.
                      retryLoadingGuide(loadingGuide.title);
                    }
                  : null,
          trailing: Icon(loadingGuide.status == LoadingStatus.loading
              ? Icons.hourglass_empty
              : Icons.error_outline,
              color: loadingGuide.status == LoadingStatus.loading
              ? Colors.blue
              : Colors.red),
        );
      },
    );
  }
}
