enum ServiceProviderFailureRecoveryExpectation {
  none,
  stayWaiting,
  interactiveLoginRequired,
  manualRetryAllowed,
  automaticRebootCandidate,
  runtimeResetRequired,
  featureReloadAllowed,
  fatalBlocked,
}
