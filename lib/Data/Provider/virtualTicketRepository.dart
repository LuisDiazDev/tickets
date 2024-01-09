import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

import '../../Core/utils/rand.dart';

void generateTickets(int pages) async {
  final pdf = pw.Document();

  // Definir el número de filas y columnas para la matriz
  int rows = 8; // Número de filas
  int cols = 7; // Número de columnas
  const pageTheme = pw.PageTheme(
    margin: pw.EdgeInsets.all(10), // Margen de 10 puntos en todos los lados
  );
  Map<String, bool> pwdMap = {};
  for (var i = 0; i < pages; i++) {
    pdf.addPage(pw.Page(
      pageTheme: pageTheme,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Table(
            children: List<pw.TableRow>.generate(rows, (rowIndex) {
              return pw.TableRow(
                children: List<pw.Widget>.generate(cols, (colIndex) {
                  String pass;
                  for (;;){
                    pass = generatePassword();
                    if(!pwdMap.containsKey(pass)){
                      pwdMap[pass] = true;
                      break;
                    }
                  }
                  return pw.Container(
                    padding: const pw.EdgeInsets.only(bottom: 3),
                    // Margen de 3 entre el QR y el texto
                    child: pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        pw.BarcodeWidget(
                          data: pass,
                          barcode: pw.Barcode.qrCode(typeNumber: 1, errorCorrectLevel: pw.BarcodeQRCorrectionLevel.high),
                          color: PdfColors.black,
                          height: 70,
                          width: 70,
                          padding: const pw.EdgeInsets.all(7),
                        ),
                        pw.SizedBox(height: 3), // Espacio de 3 entre QR y texto
                        pw.Text(pass, textAlign: pw.TextAlign.center),
                      ],
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
    ));
  }

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/example.pdf');
  await file.writeAsBytes(await pdf.save());
  OpenFile.open(file.path);
}
