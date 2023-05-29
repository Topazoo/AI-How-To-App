enum LoadingStatus { loading, success, failure }

class LoadingGuide {
  final String title;
  final DateTime startTime;
  LoadingStatus status;

  LoadingGuide({required this.title, required this.startTime, this.status = LoadingStatus.loading});
}
