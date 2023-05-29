class Requirement {
  String item;
  String quantity;
  String notes;

  Requirement({
    required this.item,
    required this.quantity,
    this.notes = '',
  });

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      item: json['item'],
      quantity: json['quantity'],
      notes: json['notes'] ?? '', // returns an empty string if notes is null
    );
  }
}
