class ContactModel {
  final String id;
  final String name;
  final String phone;
  final bool isSelected;
  final String? initial;
  final bool isFriend;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.isSelected,
    this.initial,
    this.isFriend = false, // Default to false for non-friends
  });

  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    bool? isSelected,
    String? initial,
    bool? isFriend,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isSelected: isSelected ?? this.isSelected,
      initial: initial ?? this.initial,
      isFriend: isFriend ?? this.isFriend,
    );
  }
}
