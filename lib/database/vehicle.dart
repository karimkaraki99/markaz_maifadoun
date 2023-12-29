import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/colors_util.dart';

class Car {
  final String id;
  final String name;
  final bool isActive;
  final bool onMission;

  Car({
    required this.id,
    required this.name,
    required this.isActive,
    required this.onMission,
  });
}

class CarsListScreen extends StatefulWidget {
  @override
  _CarsListScreenState createState() => _CarsListScreenState();
}

class _CarsListScreenState extends State<CarsListScreen> {
  List<Car> cars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('cars').get();

      cars = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Car(
          id: doc.id,
          name: data['name'] ?? '',
          isActive: data['isActive'] ?? false,
          onMission: data['onMission'] ?? false,
        );
      }).toList();

      setState(() {
        isLoading = false;
      });

      print(cars);
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return  isLoading
        ? CircularProgressIndicator()
        : ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cars.length,
      itemBuilder: (context, index) {
        return Builder(
          builder: (BuildContext scaffoldContext) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.025),
                Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: cars[index].isActive ? blue : red,
                            ),
                          ),
                          Image.asset(
                            'assets/ambulance_icon.png',
                            width: MediaQuery.of(context).size.width * 0.10,
                            height: MediaQuery.of(context).size.width * 0.1,
                            color: cars[index].onMission ? yellow : white,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          cars[index].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              ],
            );
          },
        );
      },
    );


  }
}
