enum CommonClasesCpbteVT {
  bajasVT('BajasVT', 'Bajas', 1),
  pedidosVT('PedidosVT', 'Pedidos', 2),
  cambiosPlanVT('CambiosPlanVT', 'Cambio de Plan', 3),
  facturasVT('FacturasVT', 'Facturas', 4),
  recibosVT('RecibosVT', 'Recibos', 5),
  debitosVT('DebitosVT', 'Debitos', 6),
  creditosVT('CreditosVT', 'Creditos', 7),
  ticketsRemedyVT('TicketsRemedyVT', 'Tickets Remedy', 8),
  unknown('unknown', 'Unknown', -1),
  ;

  final String typeId;
  final String typeDsc;
  final int typeIdNum;

  const CommonClasesCpbteVT(this.typeId, this.typeDsc, this.typeIdNum);

  static CommonClasesCpbteVT getById(String pId) =>
      CommonClasesCpbteVT.values.firstWhere((element) => element.typeId == pId,
          orElse: () => CommonClasesCpbteVT.unknown);
  static String getId(CommonClasesCpbteVT pId) {
    return pId.typeId;
  }

  Map<String, dynamic> toJsonObject() {
    return {
      "TypeID": typeId,
      "TypeDsc": typeDsc,
      "TypeIdNum": typeIdNum,
    };
  }

  String toJson() {
    return typeIdNum == -1 ? "" : typeId;
  }
}
