enum ConstRequests {
  selectRecord(
    'SelectRecord',
    'Select',
    1,
  ),
  insertRecord(
    'InsertRecord',
    'Insert',
    2,
  ),
  changeRecord(
    'ChangeRecord',
    'Change',
    3,
  ),
  deleteRecord(
    'DeleteRecord',
    'Delete',
    4,
  ),
  viewRecord(
    'ViewRecord',
    'View',
    5,
  ),
  cancelRequest(
    'CancelRequest',
    'Cancel',
    90,
  ),
  cancelRecord(
    'CancelRecord',
    'Cancel',
    91,
  ),
  saveRecord(
    'SaveRecord',
    'Guardar',
    6,
  ),
  revertRecord(
    'RevertRecord',
    'Revertir',
    7,
  ),
  noneRecord(
    'NoneRecord',
    'None',
    0,
  ),
  customRequest(
    'CustomRequest',
    'Custom',
    20,
  ),
  selectRequest(
    'SelectRequest',
    'Select',
    31,
  ),
  insertRequest(
    'InsertRequest',
    'Insert',
    32,
  ),
  changeRequest(
    'ChangeRequest',
    'Change',
    33,
  ),
  deleteRequest(
    'DeleteRequest',
    'Delete',
    34,
  ),
  viewRequest(
    'ViewRequest',
    'View',
    35,
  ),
  saveRequest(
    'SaveRequest',
    'Guardar',
    36,
  ),
  noneRequest(
    'NoneRequest',
    'None',
    30,
  ),
  revertRequest(
    'RevertRequest',
    'Revertir',
    37,
  ),
  sendEMailRequest(
    'SendEMailRequest',
    'Enviar EMail',
    38,
  ),
  downloadRequest(
    'DownloadRequest',
    'Download',
    39,
  ),
  unknown(
    'unknown',
    'Unknown',
    -1,
  ),
  ;

  final String typeId;
  final String typeDsc;
  final int typeIdNum;

  const ConstRequests(this.typeId, this.typeDsc, this.typeIdNum);

  static ConstRequests getById(String description) => ConstRequests.values
      .firstWhere((element) => element.typeId == description,
          orElse: () => ConstRequests.unknown);

  // Map<String, dynamic> toJson() => {
  //       'typeId': typeId,
  //       'typeDsc': typeDsc,
  //       'typeIdNum': typeIdNum,
  //     };
  // @override
  // String toString() {
  //   return typeId;
  // }
}
