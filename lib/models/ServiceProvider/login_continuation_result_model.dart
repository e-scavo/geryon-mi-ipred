import 'package:geryon_web_app_ws_v2/models/ServiceProvider/auth_requirement_model.dart';
import 'package:geryon_web_app_ws_v2/models/ServiceProvider/login_data_user_message_model.dart';
import 'package:geryon_web_app_ws_v2/models/error_handler.dart';

enum ServiceProviderLoginContinuationDisposition {
  success,
  cancelled,
  failed,
  invalidResult,
}

class ServiceProviderLoginContinuationResult {
  final ServiceProviderLoginContinuationDisposition disposition;
  final ServiceProviderAuthRequirement authRequirement;
  final ServiceProviderLoginDataUserMessageModel? user;
  final ErrorHandler? error;
  final dynamic rawResult;
  final String description;
  final String? className;
  final String? functionName;

  const ServiceProviderLoginContinuationResult._({
    required this.disposition,
    required this.authRequirement,
    required this.user,
    required this.error,
    required this.rawResult,
    required this.description,
    this.className,
    this.functionName,
  });

  factory ServiceProviderLoginContinuationResult.success({
    required ServiceProviderAuthRequirement authRequirement,
    required ServiceProviderLoginDataUserMessageModel user,
    required ErrorHandler error,
    dynamic rawResult,
  }) {
    return ServiceProviderLoginContinuationResult._(
      disposition: ServiceProviderLoginContinuationDisposition.success,
      authRequirement: authRequirement,
      user: user,
      error: error,
      rawResult: rawResult,
      description:
          'Login continuation resolved successfully with authenticated runtime context.',
    );
  }

  factory ServiceProviderLoginContinuationResult.cancelled({
    required ServiceProviderAuthRequirement authRequirement,
    dynamic rawResult,
    String description = 'Login continuation was cancelled.',
    String? className,
    String? functionName,
  }) {
    return ServiceProviderLoginContinuationResult._(
      disposition: ServiceProviderLoginContinuationDisposition.cancelled,
      authRequirement: authRequirement,
      user: null,
      error: null,
      rawResult: rawResult,
      description: description,
      className: className,
      functionName: functionName,
    );
  }

  factory ServiceProviderLoginContinuationResult.failed({
    required ServiceProviderAuthRequirement authRequirement,
    required ErrorHandler error,
    dynamic rawResult,
  }) {
    return ServiceProviderLoginContinuationResult._(
      disposition: ServiceProviderLoginContinuationDisposition.failed,
      authRequirement: authRequirement,
      user: null,
      error: error,
      rawResult: rawResult,
      description: error.errorDsc ?? 'Login continuation failed.',
      className: error.className,
      functionName: error.functionName,
    );
  }

  factory ServiceProviderLoginContinuationResult.invalidResult({
    required ServiceProviderAuthRequirement authRequirement,
    dynamic rawResult,
    String description = 'Login continuation returned an invalid result.',
    String? className,
    String? functionName,
  }) {
    return ServiceProviderLoginContinuationResult._(
      disposition: ServiceProviderLoginContinuationDisposition.invalidResult,
      authRequirement: authRequirement,
      user: null,
      error: null,
      rawResult: rawResult,
      description: description,
      className: className,
      functionName: functionName,
    );
  }

  bool get isSuccess =>
      disposition == ServiceProviderLoginContinuationDisposition.success;

  bool get isCancelled =>
      disposition == ServiceProviderLoginContinuationDisposition.cancelled;

  bool get isFailure =>
      disposition == ServiceProviderLoginContinuationDisposition.failed ||
      disposition ==
          ServiceProviderLoginContinuationDisposition.invalidResult ||
      disposition == ServiceProviderLoginContinuationDisposition.cancelled;

  ErrorHandler toErrorHandler() {
    if (error != null) {
      return error!;
    }

    switch (disposition) {
      case ServiceProviderLoginContinuationDisposition.success:
        return ErrorHandler(
          errorCode: 0,
          errorDsc:
              'Login continuation resolved successfully with authenticated runtime context.',
          data: user,
          className: className,
          functionName: functionName,
        );
      case ServiceProviderLoginContinuationDisposition.cancelled:
        return ErrorHandler(
          errorCode: 100020,
          errorDsc: description,
          data: rawResult,
          className: className,
          functionName: functionName,
        );
      case ServiceProviderLoginContinuationDisposition.failed:
        return ErrorHandler(
          errorCode: 100021,
          errorDsc: description,
          data: rawResult,
          className: className,
          functionName: functionName,
        );
      case ServiceProviderLoginContinuationDisposition.invalidResult:
        return ErrorHandler(
          errorCode: 100022,
          errorDsc: description,
          data: rawResult,
          className: className,
          functionName: functionName,
        );
    }
  }

  @override
  String toString() {
    return {
      'disposition': disposition.name,
      'authRequirement': authRequirement.kind.name,
      'description': description,
      'user': user,
      'error': error,
      'rawResult': rawResult,
    }.toString();
  }
}
