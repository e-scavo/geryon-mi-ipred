class ServiceProviderErrorModel {
  final int code;
  final String message;
  final String title;
  final String icon;
  final String redirectTo;
  final bool forceRedirectTo;
  final List<dynamic> nativeErrors;

  ServiceProviderErrorModel._internal({
    required this.code,
    required this.message,
    required this.title,
    required this.icon,
    required this.redirectTo,
    required this.forceRedirectTo,
    required this.nativeErrors,
  });

  factory ServiceProviderErrorModel.fromJson(Map<String, dynamic> json) {
    var code = json['Code'] ?? 0;
    var message = json['Message'] ?? '';
    var title = json['Title'] ?? 'Error';
    var icon = json['Icon'] ?? 'error';
    var redirectTo = json['RedirectTo'] ?? '/';
    var forceRedirectTo = json['ForceRedirectTo'] ?? false;
    var nativeErrors = json['NativeErrors'] ?? [];
    return ServiceProviderErrorModel._internal(
      code: code,
      message: message,
      title: title,
      icon: icon,
      redirectTo: redirectTo,
      forceRedirectTo: forceRedirectTo,
      nativeErrors: List<dynamic>.from(nativeErrors),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'title': title,
      'icon': icon,
      'redirect_to': redirectTo,
      'force_redirect_to': forceRedirectTo,
      'native_errors': nativeErrors,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'Code': code,
      'Message': message,
      'Title': title,
      'Icon': icon,
      'Redirect_To': redirectTo,
      'Force_Redirect_To': forceRedirectTo,
      'Native_Errors': nativeErrors,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
