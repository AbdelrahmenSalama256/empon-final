class ContactModel {
  final String id;
  final String name;
  final String phone;
  final bool isSelected;
  final String? initial;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isSelected,
    this.initial,
  });

  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    bool? isSelected,
    String? initial,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isSelected: isSelected ?? this.isSelected,
      initial: initial ?? this.initial,
    );
  }
}
