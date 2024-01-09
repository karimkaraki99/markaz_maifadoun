import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markaz_maifadoun/utils/reuseable_widget.dart';
import '../utils/colors_util.dart';

class AddCarPage extends StatefulWidget {
  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  final TextEditingController nameController = TextEditingController();
  bool isActive = false;
  bool onMission = false;
  int type = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/profile_background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: white, weight: 10),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Add New Vehicle',
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height +
                80,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    ' ',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height +
                80,
            left: 0,
            right: 0,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Vehicle Name'),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Text('Is Active:   '),
                              Switch(
                                value: isActive,
                                onChanged: (value) {
                                  setState(() {
                                    isActive = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Text('On Mission:   '),
                              Switch(
                                value: onMission,
                                onChanged: (value) {
                                  setState(() {
                                    onMission = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              Text('Select Type:  '),
                              DropdownButton<int>(
                                value: type,
                                onChanged: (value) {
                                  setState(() {
                                    type = value!;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text('Ambulance'),
                                  ),
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Pickup'),
                                  ),
                                  // Add more types as needed
                                ],
                                hint: const Text('Select Type'),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            toDo:  () {
                              _addVehicle();
                            },
                            text: 'Add Vehicle',
                            color: blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addVehicle() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference cars = firestore.collection('cars');

    try {
      String newCarId = cars.doc().id;

      await cars.doc(newCarId).set({
        'id': newCarId,
        'name': nameController.text,
        'isActive': isActive,
        'onMission': onMission,
        'type': type,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vehicle added successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add vehicle: $e'),
        ),
      );
    }
  }
}
