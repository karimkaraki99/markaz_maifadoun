import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markaz_maifadoun/utils/reuseable_widget.dart';
import '../database/vehicle.dart';
import '../utils/colors_util.dart';

class EditCarPage extends StatefulWidget {
  final Car car;

  const EditCarPage({Key? key, required this.car}) : super(key: key);

  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  final TextEditingController nameController = TextEditingController();
  bool isActive = false;
  bool onMission = false;
  int type = 0;

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  void _initializeFormFields() {
    nameController.text = widget.car.name;
    isActive = widget.car.isActive;
    onMission = widget.car.onMission;
    type = widget.car.type;
  }

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
              'Edit Vehicle',
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.delete, color: white),
                onPressed: () {
                  _showDeleteConfirmationDialog();
                },
              ),
            ],
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
                          Text(
                            widget.car.isActive ?
                            'Status: Active':'Status: Not Active',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:widget.car.isActive ? green:red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Vehicle Name'),
                            readOnly: true,
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
                              _updateVehicle();
                            },
                            text: 'Update Vehicle',
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

  Future<void> _updateVehicle() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference cars = firestore.collection('cars');

    try {
      await cars.doc(widget.car.id).update({
        'name': nameController.text,
        'isActive': isActive,
        'onMission': onMission,
        'type': type,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vehicle updated successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update vehicle: $e'),
        ),
      );
    }
  }
  Future<void> _showDeleteConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: red,
          title: Text(
            'Delete Vehicle',
            style: TextStyle(color: white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete this vehicle?',
            style: TextStyle(color: white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: white)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteVehicle();
              },
              child: Text('Delete', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteVehicle() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference cars = firestore.collection('cars');

    try {
      await cars.doc(widget.car.id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vehicle deleted successfully!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete vehicle: $e'),
        ),
      );
    }
}
}
