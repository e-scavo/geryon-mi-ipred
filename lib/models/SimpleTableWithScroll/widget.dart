import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:geryon_web_app_ws_v2/common_vars.dart';
import 'package:geryon_web_app_ws_v2/enums/const_requests.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDownloadLocally/model.dart';
import 'package:geryon_web_app_ws_v2/models/CommonDownloadLocally/widget.dart';

class SimpleTableWithScrollLimit extends StatelessWidget {
  final BoxConstraints constraints;
  final List<Map<String, dynamic>> data;

  const SimpleTableWithScrollLimit({
    super.key,
    required this.data,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableHeader(),
        const Divider(height: 1),
        SizedBox(
          height: 300, // ← Límite vertical (ajustable)
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: constraints.maxWidth, // ← Mínimo para evitar apilamiento
              child: data.isEmpty
                  ? ListView(
                      children: [_buildEmptyRow()],
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (_, index) => _buildRow(data[index]),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey[300],
      child: Row(
        children: const [
          Expanded(
              flex: 3,
              child: Text('Nº de Comprobante',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child:
                  Text('Fecha', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
              flex: 2,
              child:
                  Text('Monto', style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(width: 40, child: Icon(Icons.download, size: 20)),
        ],
      ),
    );
  }

  Widget _buildEmptyRow() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Card(
        elevation: 1,
        color: Colors.grey[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.info_outline, color: Colors.grey),
              SizedBox(width: 12),
              Text(
                'No hay comprobantes por mostrar',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        children: [
          Expanded(
              flex: 3,
              child: Text(item['NroCpbte'].toString().padLeft(9, '0'))),
          Expanded(flex: 2, child: Text(item['FechaCpbte'].toString())),
          Expanded(
              flex: 2,
              child: Text(item['ImporteTotalConImpuestos'].toString())),
          SizedBox(
            width: 40,
            child: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                await _downloadVoucher(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadVoucher(Map<String, dynamic> item) async {
    // Aquí iría la lógica para descargar el comprobante
    developer.log(
      'Descargando comprobante: ${item['ClaseCpbte']} - ${item['CodEmp']} - ${item['NroCpbte']}',
      name: 'SimpleTableWithScrollLimit._downloadVoucher',
    );
    List<CommonDownloadLocallyModel> pParams = [];
    CommonDownloadLocallyModel pCpbte =
        CommonDownloadLocallyModel.fromClaseCpbte(
      pModulo: 'Ventas',
      pClaseCpbte: 'Unknown',
      pCodEmp: -1,
      pNroCpbte: -1,
    );
    switch (item['ClaseCpbte']) {
      case "FacturasVT":
        pCpbte.claseCpbte = item['ClaseCpbte'];
        pCpbte.codEmp = item['CodEmp'];
        pCpbte.nroCpbte = item['NroCpbte'];
        pCpbte.tipoCliente = item['TipoCliente'];
        pCpbte.codClie = item['CodClie'];
        pCpbte.razonSocial = item['RazonSocial'];
        break;
      case "RecibosVT":
        pCpbte.claseCpbte = item['ClaseCpbte'];
        pCpbte.codEmp = item['CodEmp'];
        pCpbte.nroCpbte = item['NroCpbte'];
        pCpbte.tipoCliente = item['TipoCliente'];
        pCpbte.codClie = item['CodClie'];
        pCpbte.razonSocial = item['RazonSocial'];
        break;
      case "CreditosVT":
        pCpbte.claseCpbte = item['ClaseCpbte'];
        pCpbte.codEmp = item['CodEmp'];
        pCpbte.nroCpbte = item['NroCpbte'];
        pCpbte.tipoCliente = item['TipoCliente'];
        pCpbte.codClie = item['CodClie'];
        pCpbte.razonSocial = item['RazonSocial'];
        break;
      case "DebitosVT":
        pCpbte.claseCpbte = item['ClaseCpbte'];
        pCpbte.codEmp = item['CodEmp'];
        pCpbte.nroCpbte = item['NroCpbte'];
        pCpbte.tipoCliente = item['TipoCliente'];
        pCpbte.codClie = item['CodClie'];
        pCpbte.razonSocial = item['RazonSocial'];
        break;
      default:
    }
    pParams.add(pCpbte);
    if (navigatorKey.currentState != null) {
      await navigatorKey.currentState?.push(
          ScreenPoPUpCommonDownloadLocallyScreen<CommonDownloadLocallyModel>(
        pGlobalRequest: ConstRequests.viewRequest,
        pActionRequest: ConstRequests.viewRequest,
        pLocalActionRequest: ConstRequests.downloadRequest,
        pParams: pParams,
        autoStart: true,
      ));
    }

    developer.log(
      'Comprobante descargado: ${item['ClaseCpbte']} - ${item['CodEmp']} - ${item['NroCpbte']}',
      name: 'SimpleTableWithScrollLimit._downloadVoucher',
    );
    return;
  }
}
