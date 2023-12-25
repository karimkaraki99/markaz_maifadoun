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
      appBar: AppBar(
        title: Text('Library',style: TextStyle(color: darkBlue),),
        backgroundColor: white,
        actions: [
          IconButton(
            icon: Icon(Icons.search,color: darkBlue,),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(cardTitles: allCardTitles),
              );
            },
          ),
        ],
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
              Align(
              child: Row( mainAxisAlignment:MainAxisAlignment.center,children: [
              CardWidget(imagePath: 'assets/abcd.jpg', text: 'Dr ABCDE', pdfName: 'diagram.pdf',),
                SizedBox(width: MediaQuery.of(context).size.height * 0.02,),
              CardWidget(imagePath: 'assets/Hypertension.jpg', text: 'Hypertension', pdfName: 'diagram.pdf',),
                ],), ),
               SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
               Align(
                 child: Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                 CardWidget(imagePath: 'assets/fracture.jpg', text: 'Fracture', pdfName: 'diagram.pdf',),
                   SizedBox(width: MediaQuery.of(context).size.height * 0.02,),
                 CardWidget(imagePath: 'assets/vital_signs.jpeg', text: 'Vital Signs', pdfName: 'diagram.pdf',),
               ],),),
               SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
               Align(
                 child: Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                 CardWidget(imagePath: 'assets/bites_strings.jpg', text: 'Bites and Stings', pdfName: 'diagram.pdf',),
                   SizedBox(width: MediaQuery.of(context).size.height * 0.02,),
                 CardWidget(imagePath: 'assets/extraction.jpg', text: 'Extraction', pdfName: 'diagram.pdf',),
               ],),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
            Align(
              child: Row(mainAxisAlignment:MainAxisAlignment.center, children: [
                CardWidget(imagePath: 'assets/sample_history.jpg', text: 'Sample History', pdfName: 'diagram.pdf',),
                SizedBox(width: MediaQuery.of(context).size.height * 0.02,),
                CardWidget(imagePath: 'assets/burn.jpg', text: 'Burns', pdfName: 'diagram.pdf',),
              ],),),
          ],
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
//search
class CustomSearchDelegate extends SearchDelegate<String> {
  final List<String> cardTitles; // List of card titles

  CustomSearchDelegate({required this.cardTitles});

  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions for the search bar (e.g., clear text)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Leading icon on the left of the search bar (e.g., back button)
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Results based on the search query
    return buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions while typing in the search bar
    return buildSearchResults();
  }

  Widget buildSearchResults() {
    // Filter card titles based on the search query
    final filteredTitles = cardTitles
        .where((title) => title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredTitles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredTitles[index]),
          onTap: () {
            // Perform actions when a suggestion is tapped (e.g., navigate to the card)
            // You can use Navigator to navigate to the corresponding card or perform any other action.
            close(context, filteredTitles[index]);
          },
        );
      },
    );
  }
}