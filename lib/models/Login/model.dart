class LoginModel {
  final String dni;
  final bool rememberMe;

  LoginModel({required this.dni, this.rememberMe = false});

  Map<String, dynamic> toJson() {
    return {
      'dni': dni,
      'rememberMe': rememberMe,
    };
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      dni: json['dni'],
      rememberMe: json['rememberMe'] ?? false,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'dni': dni,
      'rememberMe': rememberMe,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other is! LoginModel) return false;

    return other.dni == dni && other.rememberMe == rememberMe;
  }

  @override
  int get hashCode => dni.hashCode ^ rememberMe.hashCode;
}
