class GuideStep {
  int stepNumber;
  String instruction;
  String notes;

  GuideStep({
    required this.stepNumber,
    required this.instruction,
    this.notes = '',
  });

  factory GuideStep.fromJson(Map<String, dynamic> json) {
    return GuideStep(
      stepNumber: json['stepNumber'],
      instruction: json['instruction'],
      notes: json['notes'] ?? '', // returns an empty string if notes is null
    );
  }
}
