import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

enum ServiceProviderAuthRequirementKind {
  none,
  loginRequiredNoRememberedUser,
  loginRequiredFromRememberedUser,
  loginRequiredAfterInvalidSession,
  error,
}

class ServiceProviderAuthRequirement {
  final ServiceProviderAuthRequirementKind kind;
  final String description;
  final int legacyErrorCode;
  final String? className;
  final String? functionName;

  const ServiceProviderAuthRequirement._({
    required this.kind,
    required this.description,
    required this.legacyErrorCode,
    this.className,
    this.functionName,
  });

  factory ServiceProviderAuthRequirement.none({
    String? className,
    String? functionName,
  }) {
    return ServiceProviderAuthRequirement._(
      kind: ServiceProviderAuthRequirementKind.none,
      description: 'Authenticated runtime continuation is already resolved.',
      legacyErrorCode: 0,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderAuthRequirement.loginRequiredNoRememberedUser({
    String? className,
    String? functionName,
  }) {
    return ServiceProviderAuthRequirement._(
      kind: ServiceProviderAuthRequirementKind.loginRequiredNoRememberedUser,
      description: 'No remembered authenticated runtime context is available.',
      legacyErrorCode: -1000,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderAuthRequirement.loginRequiredFromRememberedUser({
    String? className,
    String? functionName,
  }) {
    return ServiceProviderAuthRequirement._(
      kind: ServiceProviderAuthRequirementKind.loginRequiredFromRememberedUser,
      description:
          'A remembered local user exists and login continuation must be reopened.',
      legacyErrorCode: -1001,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderAuthRequirement.loginRequiredAfterInvalidSession({
    String? className,
    String? functionName,
  }) {
    return ServiceProviderAuthRequirement._(
      kind:
          ServiceProviderAuthRequirementKind.loginRequiredAfterInvalidSession,
      description:
          'Stored authenticated context is no longer valid and login must be reopened.',
      legacyErrorCode: -1002,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderAuthRequirement.error({
    required String description,
    int legacyErrorCode = 10001,
    String? className,
    String? functionName,
  }) {
    return ServiceProviderAuthRequirement._(
      kind: ServiceProviderAuthRequirementKind.error,
      description: description,
      legacyErrorCode: legacyErrorCode,
      className: className,
      functionName: functionName,
    );
  }

  bool get requiresInteractiveLogin {
    switch (kind) {
      case ServiceProviderAuthRequirementKind.loginRequiredNoRememberedUser:
      case ServiceProviderAuthRequirementKind.loginRequiredFromRememberedUser:
      case ServiceProviderAuthRequirementKind.loginRequiredAfterInvalidSession:
        return true;
      case ServiceProviderAuthRequirementKind.none:
      case ServiceProviderAuthRequirementKind.error:
        return false;
    }
  }

  bool get shouldResetAuthenticatedRuntimeState {
    switch (kind) {
      case ServiceProviderAuthRequirementKind.loginRequiredFromRememberedUser:
      case ServiceProviderAuthRequirementKind.loginRequiredAfterInvalidSession:
        return true;
      case ServiceProviderAuthRequirementKind.none:
      case ServiceProviderAuthRequirementKind.loginRequiredNoRememberedUser:
      case ServiceProviderAuthRequirementKind.error:
        return false;
    }
  }

  ErrorHandler toLegacyErrorHandler() {
    return ErrorHandler(
      errorCode: legacyErrorCode,
      errorDsc: description,
      className: className,
      functionName: functionName,
    );
  }
}