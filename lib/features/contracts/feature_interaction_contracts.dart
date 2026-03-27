enum FeatureInteractionContractId {
  activeClientChange,
  logoutReset,
  authResolution,
  sharedRuntimeContextRead,
}

class FeatureInteractionContract {
  final FeatureInteractionContractId id;
  final String producer;
  final String consumer;
  final String trigger;
  final String expectedEffect;
  final String currentMechanism;
  final String ownershipNote;

  const FeatureInteractionContract({
    required this.id,
    required this.producer,
    required this.consumer,
    required this.trigger,
    required this.expectedEffect,
    required this.currentMechanism,
    required this.ownershipNote,
  });
}

class FeatureInteractionContracts {
  static const FeatureInteractionContract activeClientChange =
      FeatureInteractionContract(
    id: FeatureInteractionContractId.activeClientChange,
    producer: 'DashboardController.selectClient',
    consumer: 'BillingWidget/BillingController',
    trigger: 'Active client index changes in ServiceProvider.',
    expectedEffect:
        'Billing reloads feature-local state for the new active operational context.',
    currentMechanism:
        'Dashboard mutates ServiceProvider through setCurrentCliente(...); '
        'billing listens to the runtime source and decides reload locally.',
    ownershipNote: 'Dashboard does not own billing state. '
        'Billing does not own active client context. '
        'ServiceProvider remains the owner of shared runtime context.',
  );

  static const FeatureInteractionContract logoutReset =
      FeatureInteractionContract(
    id: FeatureInteractionContractId.logoutReset,
    producer: 'DashboardController.logout',
    consumer: 'Unauthenticated runtime continuation',
    trigger: 'User executes logout from dashboard.',
    expectedEffect:
        'Remembered login hint is removed, authenticated runtime context is reset, '
        'and the application returns to the unauthenticated runtime path.',
    currentMechanism:
        'DashboardController removes saved DNI and delegates runtime reset to '
        'ServiceProvider.logout().',
    ownershipNote:
        'Dashboard produces the logout action but does not own global runtime reset logic. '
        'ServiceProvider remains the owner of authenticated runtime context lifecycle.',
  );

  static const FeatureInteractionContract authResolution =
      FeatureInteractionContract(
    id: FeatureInteractionContractId.authResolution,
    producer: 'Runtime auth requirement path',
    consumer: 'Authenticated runtime continuation',
    trigger:
        'Startup/backend-status path determines that authentication is required.',
    expectedEffect:
        'Auth flow resolves whether authenticated runtime continuation can proceed.',
    currentMechanism: 'Provider-driven auth requirement triggers login popup; '
        'LoginController drives submit flow; '
        'ServiceProvider.doLoginCallback() materializes authenticated runtime context.',
    ownershipNote: 'Startup boundary remains owned by main.dart. '
        'Auth UI does not own runtime continuation. '
        'ServiceProvider remains the owner of authenticated runtime context.',
  );

  static const FeatureInteractionContract sharedRuntimeContextRead =
      FeatureInteractionContract(
    id: FeatureInteractionContractId.sharedRuntimeContextRead,
    producer: 'ServiceProvider',
    consumer: 'Feature controllers consuming shared runtime context',
    trigger:
        'A feature needs authenticated runtime context or active operational context.',
    expectedEffect:
        'The feature reads shared runtime context through explicit read-only accessors.',
    currentMechanism:
        'Consumers rely on normalized read-only accessors such as authenticatedUser, '
        'hasAuthenticatedRuntimeContext, activeClientIndex, activeClient, '
        'activeCompany, and availableClients.',
    ownershipNote:
        'Reading shared runtime context does not transfer ownership. '
        'ServiceProvider remains the single owner of shared runtime context.',
  );

  static const List<FeatureInteractionContract> values =
      <FeatureInteractionContract>[
    activeClientChange,
    logoutReset,
    authResolution,
    sharedRuntimeContextRead,
  ];

  static FeatureInteractionContract byId(FeatureInteractionContractId id) {
    switch (id) {
      case FeatureInteractionContractId.activeClientChange:
        return activeClientChange;
      case FeatureInteractionContractId.logoutReset:
        return logoutReset;
      case FeatureInteractionContractId.authResolution:
        return authResolution;
      case FeatureInteractionContractId.sharedRuntimeContextRead:
        return sharedRuntimeContextRead;
    }
  }
}
