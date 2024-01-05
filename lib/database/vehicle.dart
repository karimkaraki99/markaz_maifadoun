import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/colors_util.dart';

class Car {
  final String id;
  final String name;
  final bool isActive;
  final bool onMission;
  final int type;

  Car({
    required this.id,
    required this.name,
    required this.isActive,
    required this.onMission,
    required this.type
  });
  static List<Car> allCarsList = [];
  static List<Car> activeCarsList = [];
  static List<Car> activeNowCarsList = [];

  static Future<bool> initCarsLists() async {
    bool isLoading = true;
    allCarsList = await getCars();
    activeCarsList = allCarsList.where((car) => car.isActive).toList();
    activeNowCarsList = allCarsList.where((car) => !car.onMission && car.isActive).toList();
    isLoading= false;
    return isLoading;
  }


  static Future<List<Car>> getCars() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference cars = firestore.collection('cars');

    List<Car> carList = [];

    try {
      QuerySnapshot querySnapshot = await cars.get();
      allCarsList.clear();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> carData = docSnapshot.data() as Map<String, dynamic>;

        Car car = Car(
          id: docSnapshot.id,
          name: carData['name'] ?? '',
          onMission: carData['onMission'] ?? false,
          isActive: carData['isActive'] ?? false,
          type:carData['type'] ?? 0
        );

        carList.add(car);
        allCarsList.add(car);
      }
    } catch (e) {
      print("Error fetching cars: $e");
    }

    return carList;
  }
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
    Car.initCarsLists();
    setState(() {
      cars = Car.allCarsList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  isLoading
        ? SpinKitFadingCircle(
      color: Colors.blue,
      size: 50.0,
    )
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
