
import 'dart:async';


import 'package:flutter/material.dart';

import 'package:printing/printing.dart';

import 'pdf_preview.dart';


/// pdf preview page in native format with all available options
class PdfPreviewPage extends StatelessWidget {
  List<List> ledgerData;
  List title;
  PdfPreviewPage({
    Key? key,
    this.ledgerData = const [[]],
    this.title = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final toolTipKey = GlobalKey<TooltipState>();

    ///show tooltip at the top right corner for the user guide
    Future(() {
      toolTipKey.currentState?.ensureTooltipVisible();
      Timer(const Duration(seconds: 2), () {
        Tooltip.dismissAllToolTips();
      });
      return null;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Preview'),
        actions: [
          Tooltip(
            key: toolTipKey,
            triggerMode: TooltipTriggerMode.tap,
            preferBelow: true,
            waitDuration: const Duration(seconds: 1),
            showDuration: const Duration(seconds: 2),
            padding: const EdgeInsets.all(5),
            height: 35,
            textStyle: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blueGrey,
            ),
            message: 'Double-Tap to enable/disable zoom mode',
            child: const Icon(
              Icons.info,
              size: 30,
            ),
          ),
         SizedBox(width: 20,)
        ],
      ),
      body: PdfPreview(
        build: (context) => makePdf(ledgerData, title),
      ),
    );
  }
}