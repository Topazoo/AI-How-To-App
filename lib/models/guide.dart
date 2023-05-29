import 'requirement.dart';
import 'guide_step.dart';

class Guide {
  String title;
  String description;
  String estimatedTime;
  List<Requirement> requirements;
  List<GuideStep> steps;
  String notes;
  bool isFavorite;

  Guide({
    required this.title,
    required this.description,
    required this.estimatedTime,
    required this.requirements,
    required this.steps,
    required this.notes,
    this.isFavorite = false, // default value
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    // Parse the JSON into a HowToGuide
    return Guide(
      title: json['title'],
      description: json['description'],
      estimatedTime: json['estimatedTime'],
      requirements: (json['requirements'] as List).map((i) => Requirement.fromJson(i)).toList(),
      steps: (json['steps'] as List).map((i) => GuideStep.fromJson(i)).toList(),
      notes: json['notes'],
    );
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  String get sortableTitle => isFavorite ? 'A$title' : 'B$title';
}
