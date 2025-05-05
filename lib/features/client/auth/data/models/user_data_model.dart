class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? birthDate;
  final String? gender;
  final String? phone;
  final String? email;
  final String? anotherEmail;
  final String? image;
  final bool? emailVerifiedAt;
  final bool? anotherEmailVerifiedAt;
  final bool? phoneVerifiedAt;
  final String? balance;
  final String? fcmToken;
  final String? wsToken;
  final String? lastSeen;
  final bool? isOnline;
  final String? token;
  final String? createdAt;
  final List<Address>? addresses;
  final List<dynamic>? account;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.phone,
    this.email,
    this.anotherEmail,
    this.image,
    this.emailVerifiedAt,
    this.anotherEmailVerifiedAt,
    this.phoneVerifiedAt,
    this.balance,
    this.fcmToken,
    this.wsToken,
    this.lastSeen,
    this.isOnline,
    this.token,
    this.createdAt,
    this.addresses,
    this.account,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(), // Convert int to String
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      birthDate: json['birth_date'] as String?,
      gender: json['gender'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      anotherEmail: json['another_email'] as String?,
      image: json['image'] as String?,
      emailVerifiedAt: json['email_verified_at'] as bool?,
      anotherEmailVerifiedAt: json['another_email_verified_at'] as bool?,
      phoneVerifiedAt: json['phone_verified_at'] as bool?,
      balance: json['balance']?.toString(), // Convert int to String
      fcmToken: json['fcm_token'] as String?,
      wsToken: json['ws_token'] as String?,
      lastSeen: json['last_seen'] as String?,
      isOnline: json['is_online'] as bool?,
      token: json['token'] as String?,
      createdAt: json['created_at'] as String?,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(),
      account: json['account'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate,
        'gender': gender,
        'phone': phone,
        'email': email,
        'another_email': anotherEmail,
        'image': image,
        'email_verified_at': emailVerifiedAt,
        'another_email_verified_at': anotherEmailVerifiedAt,
        'phone_verified_at': phoneVerifiedAt,
        'balance': balance,
        'fcm_token': fcmToken,
        'ws_token': wsToken,
        'last_seen': lastSeen,
        'is_online': isOnline,
        'token': token,
        'created_at': createdAt,
        'addresses': addresses?.map((e) => e.toJson()).toList(),
        'account': account,
      };
}

class Address {
  final int? id;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final String? lat;
  final String? lng;

  Address({
    this.id,
    this.country,
    this.state,
    this.city,
    this.address,
    this.lat,
    this.lng,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] as int?,
      country: json['country'] as String?,
      state: json['state'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      lat: json['lat'] as String?,
      lng: json['lng'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'country': country,
        'state': state,
        'city': city,
        'address': address,
        'lat': lat,
        'lng': lng,
      };
}
