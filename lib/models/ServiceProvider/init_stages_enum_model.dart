enum ServiceProviderInitStages {
  init('init', 'Initializing APP'),
  connecting('connecting', 'Connecting...'),
  errorConnecting('errorConnecting', 'Can\'t connect to backend'),
  reConnecting('reConnecting', 'Reconnecting...'),
  errorReConnecting('errorReConnecting', 'Can\'t reconnect to backend'),
  connected('connected', 'Connected to backend'),
  listening('listening', 'Listening for events'),
  subscribing('subscribing', 'Subscribing to events...'),
  errorSubscribingChannels(
      'errorSubscribingChannels', 'Can\'t subscribe channels'),
  subscribed('subscribed', 'Subscribed and listening to new events'),
  disconnected('disconnected', 'Disconnected from backend'),
  checkingStatus('checkingStatus', 'Checking backend status'),
  errorCheckingStatus('errorCheckingStatus', 'Error checking backend status'),
  errorRequestingBackend(
      'errorRequestingBackend', 'Error requesting to backend'),
  errorOnHighSeverity(
      'errorOnHighSeverity', '[internal] HIGH importance error'),
  checkingLoginStatus('checkingLoginStatus', 'Checking login status'),
  errorCheckingLoginStatus(
      'errorCheckingLoginStatus', 'Error checking login status'),
  userIsNotloggedIn('userIsNotloggedIn',
      'User\'s credentials are invalid. User is not logged-in.\r\nExecuting login'),
  userIsloggedIn(
      'loggedIn', 'User\'s credentials are valid. User is logged-in'),
  errorCustom('errorCustom', ''),
  unknown('unknown', 'Unknown'),
  ;

  final String typeId;
  final String typeDsc;

  const ServiceProviderInitStages(this.typeId, this.typeDsc);

  static ServiceProviderInitStages getByDescription(String description) =>
      ServiceProviderInitStages.values.firstWhere(
          (element) => element.name == description,
          orElse: () => ServiceProviderInitStages.unknown);
}
