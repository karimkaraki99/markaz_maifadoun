import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/teamLeader/start_mission.dart';
import '../database/missions.dart';
import '../database/users.dart';
import '../utils/colors_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  // Define controllers for text fields
  TextEditingController patientNameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController approvalIdController = TextEditingController();
  String? selectedCar;
  String? selectedTeamLeader;
  String? selectedDriver;
  String? selectedMedic1;
  String? selectedMedic2;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    patientNameController.text = widget.mission.patientName;
    locationController.text = widget.mission.location;
    destinationController.text = widget.mission.destination;
    approvalIdController.text = widget.mission.approvalId;
  }

  Future<void> markMissionAsDoneInDatabase() async {
    CollectionReference missions = FirebaseFirestore.instance.collection('missions');

    try {
      final List<String?> selectedUsersPhoneNumbers = [
        selectedTeamLeader,
        selectedDriver,
        selectedMedic1,
        selectedMedic2,
      ];

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

      // Update the isActive field to false in the mission document
      await missions.doc(widget.mission.id).update({'isActive': false});

      // Optionally, you can setState to update the UI with the new mission data
      setState(() {
        widget.mission.isActive = false;
      });

      print('Marked mission as done successfully');

    } catch (e) {
      print('Error marking mission as done: $e');
      // Handle the error
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Mission'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display mission details
              Text('Mission Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Car: ${widget.mission.car}'),
              Text('Team Leader: ${widget.mission.teamLeader}'),
              Text('Driver: ${widget.mission.driver}'),
              widget.mission.medic1 != null && widget.mission.medic1.trim().isNotEmpty
                  ? Text('medic/s: ${widget.mission.medic1} ${widget.mission.medic2}')
                  : Container(),
              SizedBox(height: 20),
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

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle submit logic
                      }
                    },
                    child: Text('Edit', style: TextStyle(color: white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(blue),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        markMissionAsDoneInDatabase();
                      }
                    },
                    child: Text('Mark as Done', style: TextStyle(color: white)),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(green),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
