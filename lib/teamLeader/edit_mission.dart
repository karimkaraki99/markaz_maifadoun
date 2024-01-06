import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/teamLeader/start_mission.dart';
import '../database/missions.dart';
import '../database/users.dart';
import '../utils/colors_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'missions.dart';

class UserFetcher {
  static Future<Users?> getUserByPhoneNumber(String phoneNumber) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      if (userSnapshot.exists) {
        return Users.fromMap(userSnapshot.data() as Map<String, dynamic>);
      } else {
        print('User with phone number $phoneNumber not found.');
        return null;
      }
    } catch (e) {
      print('Error fetching user by phone number: $e');
      return null;
    }
  }
}

class EditMissionPage extends StatefulWidget {
  final Mission mission;

  EditMissionPage({required this.mission, Key? key}) : super(key: key);

  @override
  _EditMissionPageState createState() => _EditMissionPageState();
}

class _EditMissionPageState extends State<EditMissionPage> {

  TextEditingController patientNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController approvalIdController = TextEditingController();
  String? selectedCar;
  String? leaderPhone;
  String? driverPhoneNumber;
  String? medic1PhoneNumber;
  String? medic2PhoneNumber;
  String selectedMissionType = 'Emergency';
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedCar = widget.mission.car;
    patientNameController.text = widget.mission.patientName;
    locationController.text = widget.mission.location;
    destinationController.text = widget.mission.destination;
    approvalIdController.text = widget.mission.approvalId;
    leaderPhone = widget.mission.leaderPhoneNumber;
    driverPhoneNumber = widget.mission.driverPhoneNumber;
    medic1PhoneNumber =  widget.mission.medic1PhoneNumber;
    medic2PhoneNumber = widget.mission.medic2PhoneNumber;
    selectedMissionType = widget.mission.missionType?.isNotEmpty == true
        ? widget.mission.missionType!
        : 'Emergency';


  }

  Future<void> markMissionAsDoneInDatabase() async {
    CollectionReference missions = FirebaseFirestore.instance.collection('missions');

    try {
      final List<String?> selectedUsersPhoneNumbers = [
        leaderPhone,
        driverPhoneNumber,
        medic1PhoneNumber,
        medic2PhoneNumber,
      ];

      // Update onMission field for each selected user
      for (String? phoneNumber in selectedUsersPhoneNumbers) {
        if (phoneNumber != null) {
          try {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(phoneNumber)
                .update({'onMission': false});

            print('User $phoneNumber is not on a mission anymore');
          } catch (e) {
            print('Error updating user fields: $e');
            // Handle error as needed
          }
        }
      }

      // Update onMission field for the car
      String? carName = selectedCar;
      if (carName != null && carName.isNotEmpty) {
        try {
          await FirebaseFirestore.instance
              .collection('cars')
              .doc(carName)
              .update({'onMission': false});

          print('Car $carName is not on a mission anymore');
        } catch (e) {
          print('Error updating car fields: $e');
          // Handle error as needed
        }
      } else {
        print('Invalid carName: $carName');
      }


      // Update the isActive field to false in the mission document
      await missions.doc(widget.mission.id).update({'isActive': false});

      // Optionally, you can setState to update the UI with the new mission data
      setState(() {
        widget.mission.isActive = false;
        showSuccessDoneMessage( );
      });

      print('Marked mission as done successfully');
    } catch (e) {
      print('Error marking mission as done: $e');
      // Handle the error
    }
  }
  Future<void> updateMissionInDatabase() async {
    CollectionReference missions = FirebaseFirestore.instance.collection('missions');

    try {
      await missions.doc(widget.mission.id).update({
        'patientName': patientNameController.text,
        'location': locationController.text,
        'destination': destinationController.text,
        'approvalId': approvalIdController.text,
        'type':selectedMissionType,
      });

      setState(() {
        widget.mission.patientName = patientNameController.text;
        widget.mission.location = locationController.text;
        widget.mission.destination = destinationController.text;
        widget.mission.approvalId = approvalIdController.text;
        widget.mission.missionType = selectedMissionType!;
      });

      showSuccessDialogMessage();
    } catch (e) {
      String error = 'Error Updating Mission $e';
      showErrorDialogMessage(error);
      // Handle the error
    }
  }
  void showSuccessDialogMessage( ){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: green,
          title: Icon(Icons.check_circle ,size: 80, color: white,),
          content: Text('Mission updated successfully!',style: TextStyle(color: white),textAlign: TextAlign.center,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK',style: TextStyle(color: white),),
            ),
          ],
        );
      },
    );
  }
  void showSuccessDoneMessage( ){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: green,
          title: Icon(Icons.check_circle ,size: 80, color: white,),
          content: Text('Marked mission as done successfully!',style: TextStyle(color: white),textAlign: TextAlign.center,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Missions()),
                );// Close the dialog
              },
              child: Text('OK',style: TextStyle(color: white),),
            ),
          ],
        );
      },
    );
  }
  void showErrorDialogMessage(String e ){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: red,
          title: Icon(Icons.check_circle ,size: 80, color: white,),
          content: Text(e,style: TextStyle(color: white),textAlign: TextAlign.center,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.pop(context);// Close the dialog
              },
              child: Text('OK',style: TextStyle(color: white),),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mission'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                color: Colors.blue.shade200,
                elevation: 5.0,
                margin: EdgeInsets.only(bottom: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Mission Details',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkBlue),
                      ),
                      SizedBox(height: 10),
                      Text('Car: ${widget.mission.car}', style: TextStyle(color: darkGrey)),
                      Text('Team Leader: ${widget.mission.teamLeader}'),
                      Text('Driver: ${widget.mission.driver}'),
                      widget.mission.medic1 != null && widget.mission.medic1.trim().isNotEmpty
                          ? Text('Medic/s: ${widget.mission.medic1} ${widget.mission.medic2}')
                          : Container(),
                    ],
                  ),
                ),
              ),
              MissionTypeDropdown(
                initialValue: selectedMissionType,
                onChanged: (newValue) {
                  setState(() {
                    selectedMissionType = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    LabeledTextField(
                      labelText: 'Patient Name',
                      hintText: 'Enter patient name',
                      controller: patientNameController,
                      cursorColor: blue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient name';
                        }
                        return null;
                      },
                    ),
                    LabeledTextField(
                      labelText: 'Location',
                      hintText: 'Enter location',
                      controller: locationController,
                      cursorColor: blue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter location';
                        }
                        return null;
                      },
                    ),
                    LabeledTextField(
                      labelText: 'Destination',
                      hintText: 'Enter destination',
                      controller: destinationController,
                      cursorColor: blue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter destination';
                        }
                        return null;
                      },
                    ),
                    LabeledTextField(
                      labelText: 'Approval ID',
                      hintText: 'Enter approval ID',
                      controller: approvalIdController,
                      cursorColor: blue,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter approval ID';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: !widget.mission.isActive ? 300 : null,
                    child: ElevatedButton(
                      onPressed: () {
                        updateMissionInDatabase();
                      },
                      child: Text('Edit', style: TextStyle(color: Colors.white)),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                      ),
                    ),
                  ),
                  widget.mission.isActive
                      ? ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        updateMissionInDatabase();
                        markMissionAsDoneInDatabase();
                      }
                    },
                    child: Text('Mark as Done', style: TextStyle(color: white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(green),
                    ),
                  )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
