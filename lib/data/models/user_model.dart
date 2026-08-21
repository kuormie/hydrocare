class UserModel {
  final String id;
  final String name;
  final String email;
  final String greeting;
  final String? profileImagePath;
  final String? tanggalLahir;
  final String? jenisKelamin;
  final String? beratBadan;
  final String? tinggiBadan;
  final String? aktivitasHarian;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.greeting,
    this.profileImagePath,
    this.tanggalLahir,
    this.jenisKelamin,
    this.beratBadan,
    this.tinggiBadan,
    this.aktivitasHarian,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        greeting: json['greeting'] as String,
        profileImagePath: json['profileImagePath'] as String?,
        tanggalLahir: json['tanggalLahir'] as String?,
        jenisKelamin: json['jenisKelamin'] as String?,
        beratBadan: json['beratBadan'] as String?,
        tinggiBadan: json['tinggiBadan'] as String?,
        aktivitasHarian: json['aktivitasHarian'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'greeting': greeting,
        'profileImagePath': profileImagePath,
        'tanggalLahir': tanggalLahir,
        'jenisKelamin': jenisKelamin,
        'beratBadan': beratBadan,
        'tinggiBadan': tinggiBadan,
        'aktivitasHarian': aktivitasHarian,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? tanggalLahir,
    String? jenisKelamin,
    String? beratBadan,
    String? tinggiBadan,
    String? aktivitasHarian,
    String? profileImagePath,
    bool clearProfileImage = false,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email ?? this.email,
        greeting: greeting,
        profileImagePath:
            clearProfileImage ? null : (profileImagePath ?? this.profileImagePath),
        tanggalLahir: tanggalLahir ?? this.tanggalLahir,
        jenisKelamin: jenisKelamin ?? this.jenisKelamin,
        beratBadan: beratBadan ?? this.beratBadan,
        tinggiBadan: tinggiBadan ?? this.tinggiBadan,
        aktivitasHarian: aktivitasHarian ?? this.aktivitasHarian,
      );
}
