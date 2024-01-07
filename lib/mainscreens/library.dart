import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../utils/reuseable_widget.dart';


class libraryScreen extends StatefulWidget {
  @override
  _libraryScreen createState() => _libraryScreen();
}

class _libraryScreen extends State<libraryScreen> {
  final List<String> allCardTitles = [
    'Dr ABCDE',
    'Hypertension',
    'Fracture',
    'Vital Signs',
    'Bites and Stings',
    'Extraction',
    'Sample History',
    'Burns',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardWidget(imagePath: 'assets/abcd.jpg', text: 'Dr ABCDE', pdfName: 'diagram.pdf'),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                    CardWidget(imagePath: 'assets/Hypertension.jpg', text: 'Hypertension', pdfName: 'diagram.pdf'),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardWidget(imagePath: 'assets/fracture.jpg', text: 'Fracture', pdfName: 'diagram.pdf'),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                    CardWidget(imagePath: 'assets/vital_signs.jpeg', text: 'Vital Signs', pdfName: 'diagram.pdf'),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardWidget(imagePath: 'assets/bites_strings.jpg', text: 'Bites and Stings', pdfName: 'diagram.pdf'),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                    CardWidget(imagePath: 'assets/extraction.jpg', text: 'Extraction', pdfName: 'diagram.pdf'),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Align(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardWidget(imagePath: 'assets/sample_history.jpg', text: 'Sample History', pdfName: 'diagram.pdf'),
                    SizedBox(width: MediaQuery.of(context).size.height * 0.02),
                    CardWidget(imagePath: 'assets/burn.jpg', text: 'Burns', pdfName: 'diagram.pdf'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}
class PDFViewer extends StatelessWidget {
  final String pdfAsset;

  const PDFViewer({required this.pdfAsset});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
        body: SfPdfViewer.asset(
            'assets/$pdfAsset'));
  }
}
