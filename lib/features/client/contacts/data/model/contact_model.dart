class ContactModel {
  final String id;
  final String name;
  final String phone;
  final bool isSelected;
  final String? initial;
  final String? status;
  final bool isFriend;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    this.status,
    required this.isSelected,
    this.initial,
    this.isFriend = false,
  });

  ContactModel copyWith({
    String? id,
    String? name,
    String? phone,
    bool? isSelected,
    String? status,
    String? initial,
    bool? isFriend,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      isSelected: isSelected ?? this.isSelected,
      status: status ?? this.status,
      initial: initial ?? this.initial,
      isFriend: isFriend ?? this.isFriend,
    );
  }
}
