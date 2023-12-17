// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';


import 'package:pdf/widgets.dart';
import 'package:pdf/pdf.dart';
// import 'package:flutter/services.dart' show rootBundle;

Future<Uint8List> makePdf(
  List<List> ledgerData,
  List title,
) async {

  final pdf = Document(pageMode: PdfPageMode.fullscreen);
  // final imageLogo = MemoryImage(
  //   (await rootBundle.load('assets/logo/dynamicerp/logo.png'))
  //       .buffer
  //       .asUint8List(),
  // );

  final heading = [
    "userDetails.companyName",
    "userDetails.companyAddress",
    "StringUtils"
  ];

  pdf.addPage(
    MultiPage(
      orientation: title.length > 6 ? PageOrientation.landscape : null,
      margin: title.length > 6
          ? const EdgeInsets.all(20)
          : const EdgeInsets.all(40),
      // pageFormat: title.length > 6 ? PdfPageFormat.a3 : null,
      maxPages: 100,
      build: (context) => [
        // header widget
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [Text("date time")]),
            SizedBox(
              height: 10,
            ),
            Column(
              children: heading
                  .map(
                    (e) => Center(
                      child: size1AutoSizeText(
                        (e),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),

        //data table for pdf
        TableHelper.fromTextArray(
          defaultColumnWidth: const IntrinsicColumnWidth(flex: 1),
          context: context,
          data: ledgerData,
          headers: title,
          cellStyle: title.length > 10
              ? TextStyle(fontSize: title.length > 15 ? 6 : 8)
              : null,
        ),
      ],
    ),
  );

  return pdf.save();
}

Text size1AutoSizeText(String? title) => Text(
      title.toString(),
      textScaleFactor: 1.5,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

Widget paddedAutoSizeText(final String text,
        {final TextAlign align = TextAlign.left}) =>
    Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );