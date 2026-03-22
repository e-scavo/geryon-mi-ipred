/// Button constancts
///
enum AppConstButtons {
  buttonCancel('cancel', 'Cancel'),
  buttonYes('yes', 'Yes'),
  buttonNo('no', 'No'),
  buttonOk('ok', 'Ok'),
  buttonAccept('accept', 'Accept'),
  buttonClose('accept', 'Accept'),
  unknown('unknown', 'Unknown'),
  ;

  final String typeId;
  final String typeDsc;

  const AppConstButtons(this.typeId, this.typeDsc);

  static AppConstButtons getByDescription(String description) =>
      AppConstButtons.values.firstWhere(
          (element) => element.name == description,
          orElse: () => AppConstButtons.unknown);
}
