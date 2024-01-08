import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/database/users.dart';
import '../database/missions.dart';
import '../database/vehicle.dart';
import '../utils/colors_util.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../utils/reuseable_widget.dart';
import 'missions.dart';
import 'package:http/http.dart' as http;


class StartMission extends StatefulWidget {
  const StartMission({super.key});

  @override
  State<StartMission> createState() => _StartMissionState();
}


class _StartMissionState extends State<StartMission> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState<Car?>> carKey = GlobalKey();
  GlobalKey<FormFieldState<Users?>> teamLeaderKey = GlobalKey();
  GlobalKey<FormFieldState<Users?>> driverKey = GlobalKey();
  Car? selectedCar;
  Users? selectedTeamLeader;
  Users? selectedDriver;
  Users? selectedMedic1;
  Users? selectedMedic2;
  Color colorCar = darkBlue;
  Color colorDriver = darkBlue;
  Color colorTeamLeader = darkBlue;
  DateTime? selectedDateTime;
  String? selectedDate;
  String? selectedTime;
  String? selectedMissionType = "Emergency";



  formatDateTime(DateTime dateTime) {
    selectedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    selectedTime = DateFormat('HH:mm').format(dateTime);
  }


  TextEditingController patientName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController destination = TextEditingController();
  TextEditingController approvalId = TextEditingController();


  Future<void> _createMission() async {
    String? missionTypeValue = selectedMissionType;
    String patientNameValue = patientName.text;
    String locationValue = location.text;
    String destinationValue = destination.text;
    String approvalIdValue = approvalId.text;
    String? dateValue = selectedDate;
    String? timeValue = selectedTime;

    String selectedCarName = selectedCar?.name ?? '';
    String selectedTeamLeaderName =
        '${selectedTeamLeader?.firstName ?? ''} ${selectedTeamLeader?.lastName ?? ''}';
    String selectedDriverName =
        '${selectedDriver?.firstName ?? ''} ${selectedDriver?.lastName ?? ''}';
    String selectedMedic1Name =
        '${selectedMedic1?.firstName ?? ''} ${selectedMedic1?.lastName ?? ''}';
    String selectedMedic2Name =
        '${selectedMedic2?.firstName ?? ''} ${selectedMedic2?.lastName ?? ''}';
    bool isActive=true;
    String? leaderPhoneNumber = selectedTeamLeader?.phoneNumber;
    String? driverPhoneNumber = selectedDriver?.phoneNumber;
    String? medic1PhoneNumber = selectedMedic1?.phoneNumber;
    String? medic2PhoneNumber = selectedMedic2?.phoneNumber;

    Map<String, dynamic> missionData = {
      'patientName': patientNameValue,
      'location': locationValue,
      'destination': destinationValue,
      'approvalId': approvalIdValue,
      'selectedCar': selectedCarName,
      'selectedTeamLeader': selectedTeamLeaderName,
      'selectedDriver': selectedDriverName,
      'selectedMedic1': selectedMedic1Name,
      'selectedMedic2': selectedMedic2Name,
      'isActive': isActive,
      'date': dateValue,
      'time': timeValue,
      'type': missionTypeValue,
      'leaderPhone': leaderPhoneNumber,
      'driverPhoneNumber': driverPhoneNumber,
      'medic1PhoneNumber': medic1PhoneNumber,
      'medic2PhoneNumber': medic2PhoneNumber,
    };

    await FirebaseFirestore.instance.collection('missions').add(missionData);

    print('Mission created successfully');
    try {
      // Update onMission field for the selected car
      await FirebaseFirestore.instance
          .collection('cars')
          .where('name', isEqualTo: selectedCarName)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((DocumentSnapshot doc) async {
          String carId = doc.id;

          await FirebaseFirestore.instance
              .collection('cars')
              .doc(carId)
              .update({'onMission': true});
        });
      });

      print('Car is on mission');

      // Update onMission field for each selected user
      final List<Users?> selectedUsers = [
        selectedTeamLeader,
        selectedDriver,
        selectedMedic1,
        selectedMedic2,
      ];

      for (Users? user in selectedUsers) {
        if (user != null) {
          try {
            String userId = user.phoneNumber;

            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .update({'onMission': true});

            print('User $userId is on mission');
          } catch (e) {
            print('Error updating user fields: $e');
            // Handle error as needed
          }
        }
      }

      print('Users are on mission');


      sendStartNotification();

      showSuccessDialogMessage();




    } catch (e) {
      print('Error updating fields: $e');
      
    }
  }
  void showSuccessDialogMessage( ){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: green,
          title: Icon(Icons.check_circle ,size: 80, color: white,),
          content: Text('Mission created successfully!',style: TextStyle(color: white),textAlign: TextAlign.center,),
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
  Future<void> sendStartNotification() async {
    try{
      await http.post(
          Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers:<String,String>{'Content-Type':'application/json',
            'Authorization':'key=AAAALeyHDpI:APA91bEAkTrkng8nW3Kbu0wq68Kp23FP6e6yrod275qmIs73TAs2Hdt2u7qcRUw4yTgtFT6QatmEvb8hXOIT7JecTzJppOf1mvWVnzfjFtfxp4QuRRJdQtSddLqieLl9dr_n_yjDcEgo'},
          body:jsonEncode({
            'to': "/topics/admin",
            'data': {
              'via': 'FlutterFire Cloud Messaging!!!',
              'count': '',
            },
            'notification': {
              'title': 'New Mission!',
              'body': '${selectedCar?.name} moved into a new mission, ${selectedDriver?.firstName} ${selectedDriver?.lastName} is the driver.',
            },})).then((value){
        print(value.reasonPhrase);
      });

      print('Success notification sent to all users');
    } catch (e) {
      print('Error sending success notification: $e');
    }
  }
  void showErrorDialogMessage(String e ){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: red,
          title: Icon(Icons.check_circle ,size: 80, color: white,),
          content: Text('Error Creating Missions: $e',style: TextStyle(color: white),textAlign: TextAlign.center,),
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
        title: Text('Start a Mission',style: TextStyle(color: white),),
        centerTitle: true,
        backgroundColor: blue,
        iconTheme: IconThemeData(
          color: white
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    DateTimePickerTextField(
                      initialDateTime: selectedDateTime,
                      onDateTimeChanged: (dateTime) {
                        setState(() {
                          selectedDateTime=dateTime;
                          formatDateTime(dateTime);
                        });
                      },
                    ),
                    CarDropDown(
                      key: carKey,
                      color: colorCar,
                      onCarSelected: (car) {
                        setState(() {
                          selectedCar = car;
                        });
                      },
                    ),
                    TeamLeaderDropDown(
                      key: teamLeaderKey,
                      onTeamLeaderSelected: (teamLeader) {
                        setState(() {
                          selectedTeamLeader = teamLeader;
                        });
                      },
                    ),
                    DriverDropDown(
                      key: driverKey,
                      color: colorTeamLeader,
                      driverSelected: (driver) {
                        setState(() {
                          selectedDriver = driver;
                        });
                      },
                    ),
                    TeamMembersDropDown(
                      memberSelected: (medic1) {
                        setState(() {
                          selectedMedic1 = medic1;
                        });
                      },
                    ),
                    TeamMembersDropDown(
                      memberSelected: (medic2) {
                        setState(() {
                          selectedMedic2 = medic2;
                        });
                      },
                    ),

                    SizedBox(height: 20,),
                    CustomButton(
                      text: 'Submit',
                      color: blue,
                      toDo: () async {
                        if (_formKey.currentState!.validate() &&
                            selectedCar != null &&
                            selectedTeamLeader != null &&
                            selectedDriver != null) {
                          await formatDateTime(selectedDateTime!);
                          _createMission();

                        } else {
                          if (selectedCar == null) {
                            setState(() {
                              carKey.currentState?.validate();
                              colorCar = red;
                            });
                          }
                          if (selectedTeamLeader == null) {
                            setState(() {
                              teamLeaderKey.currentState?.validate();
                              colorTeamLeader = red;
                            });
                          }
                          if (selectedDriver == null) {
                            driverKey.currentState?.validate();
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: blue
                ),
                width: double.infinity,
                height: 1,
              ),
              SizedBox(height: 10,),
              MissionTypeDropdown(
                initialValue: selectedMissionType,
                onChanged: (newValue) {
                  setState(() {
                    selectedMissionType = newValue;
                  });
                },
              ),
              SizedBox(height: 20,),
              LabeledTextField(
                labelText: 'Patient Name',
                hintText: 'Enter patient name',
                cursorColor: Colors.yellow,
                controller: patientName,
              ),
              LabeledTextField(
                labelText: 'Location',
                hintText: 'Enter Location',
                cursorColor: Colors.yellow,
                controller: location,
              ),
              LabeledTextField(
                labelText: 'Destination',
                hintText: 'Enter Destination',
                cursorColor: Colors.yellow,
                controller: destination,
              ),
              LabeledTextField(
                labelText: 'Approval ID',
                hintText: 'Enter Approval ID',
                cursorColor: Colors.yellow,
                controller: approvalId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class MissionTypeDropdown extends StatefulWidget {
  const MissionTypeDropdown({
    Key? key,
    this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  final String? initialValue;
  final Function(String) onChanged;

  @override
  State<MissionTypeDropdown> createState() => _MissionTypeDropdownState();
}

class _MissionTypeDropdownState extends State<MissionTypeDropdown> {
  late  List<String> missionTypes = [];
  late String selectedMissionType;

  @override
  void initState() {
    super.initState();
    selectedMissionType = widget.initialValue??"";
    missionTypes = Mission.missionTypes;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedMissionType,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.grey,
      ),
      hint: Text('Mission Type'),
      onChanged: (String? newValue) {
        setState(() {
          selectedMissionType = newValue ?? 'Emergency';
          widget.onChanged(selectedMissionType ?? '');
        });
      },
      items: missionTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

class CarDropDown extends StatefulWidget {
  final ValueChanged<Car?> onCarSelected;
  final Color color;
   CarDropDown({Key? key,required this.onCarSelected,required this.color, String? initialValue}) : super(key: key);

  @override
  _CarDropDownState createState() => _CarDropDownState();
}

class _CarDropDownState extends State<CarDropDown> {
  List<Car> cars = [];
  Car? selectedValue;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Car.initCarsLists();
      setState(() {
        cars = Car.activeNowCarsList;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Container(
          width: double.infinity,
          alignment: Alignment.center  ,
          child: DropdownButton<Car>(
            value: selectedValue,
            icon: Image.asset(
              'assets/ambulance_icon.png',
              height: 25,
              color: widget.color,
            ),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              width: 100,
              color: widget.color,
            ),
            onChanged: (Car? newValue) {
              setState(() {
                selectedValue = newValue!;
                widget.onCarSelected(newValue);
              });
            },
            hint: Text('Select a car  '),
            items: cars.map<DropdownMenuItem<Car>>((Car car) {
              return DropdownMenuItem<Car>(
                value: car,
                child: Text(car.name),
              );
            }).toList(),

          ),
        ),
      ),
    );
  }
}

class DriverDropDown extends StatefulWidget {
  final ValueChanged<Users?> driverSelected;
  final Color color;
  DriverDropDown({Key? key,required this.driverSelected,required this.color, String? initialValue}) : super(key: key);

  @override
  State<DriverDropDown> createState() => _DriverDropDownState();
}

class _DriverDropDownState extends State<DriverDropDown> {
  List<Users> drivers = [];
  Users? selectedValue;
  bool isLoading = true;
  GlobalKey<AutoCompleteTextFieldState<Users>> key = GlobalKey();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Users.initUsersLists();
      setState(() {
        drivers = Users.availableDrivers;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = widget.color;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
          children: [
            AutoCompleteTextField<Users>(
              controller: controller,
              key: key,
              clearOnSubmit: false,
              suggestions: drivers,
              decoration: InputDecoration(
                labelText: 'Select a Driver',
                labelStyle: TextStyle(color: borderColor),
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: borderColor),
                ),
              ),
              itemBuilder: (BuildContext context, Users suggestion) {
                return ListTile(
                  title: Text(
                      '${suggestion.firstName} ${suggestion.lastName}'),
                );
              },
              itemFilter: (Users suggestion, String query) {
                return suggestion.firstName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                    suggestion.lastName
                        .toLowerCase()
                        .contains(query.toLowerCase());
              },
              itemSorter: (Users a, Users b) {
                return a.firstName.compareTo(b.firstName);
              },
              itemSubmitted: (Users value) {
                setState(() {
                  selectedValue = value;
                  controller.text =
                  '${value.firstName} ${value.lastName}';
                  widget.driverSelected(value);
                });
              },
              textSubmitted: (String query) {
                print("Text submitted: $query");
              },
            ),
          ],
        ),
      ),
    );
  }
}


class TeamMembersDropDown extends StatefulWidget {
  final ValueChanged<Users?> memberSelected;
   TeamMembersDropDown({Key? key,required this.memberSelected, String? initialValue}) : super(key: key);

  @override
  State<TeamMembersDropDown> createState() => _TeamMembersDropDownState();
}

class _TeamMembersDropDownState extends State<TeamMembersDropDown> {
  List<Users> members = [];
  Users? selectedValue;
  bool isLoading = true;
  GlobalKey<AutoCompleteTextFieldState<Users>> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Users.initUsersLists();
      setState(() {
        members = Users.availableAllMembers;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
          children: [
            AutoCompleteTextField<Users>(
              controller: controller,
              key: key,
              clearOnSubmit: false,
              suggestions: members,
              decoration: InputDecoration(
                labelText: 'Select a Medic',
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              itemBuilder: (BuildContext context, Users suggestion) {
                return ListTile(
                  title: Text('${suggestion.firstName} ${suggestion.lastName}'),
                );
              },
              itemFilter: (Users suggestion, String query) {
                return suggestion.firstName.toLowerCase().contains(query.toLowerCase()) ||
                    suggestion.lastName.toLowerCase().contains(query.toLowerCase());
              },
              itemSorter: (Users a, Users b) {
                return a.firstName.compareTo(b.firstName);
              },
            itemSubmitted: (Users value) {
              setState(() {
                selectedValue = value;
                controller.text = '${value.firstName} ${value.lastName}';
                widget.memberSelected(value);
              });
            },
              textSubmitted: (String query) {
                print("Text submitted: $query");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TeamLeaderDropDown extends StatefulWidget {
  final ValueChanged<Users?> onTeamLeaderSelected;
  TeamLeaderDropDown({Key? key,required this.onTeamLeaderSelected, String? initialValue}) : super(key: key);

  @override
  State<TeamLeaderDropDown> createState() => _TeamLeaderDropDownState();
}

class _TeamLeaderDropDownState extends State<TeamLeaderDropDown> {
  List<Users> teamLeaders = [];
  Users? selectedLeader;
  bool isLoading = true;
  GlobalKey<AutoCompleteTextFieldState<Users>> key = GlobalKey();
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      await Users.initUsersLists();
      setState(() {
        teamLeaders = Users.availableTeamLeaders;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
          children: [
            AutoCompleteTextField<Users>(
              controller: controller,
              key: key,
              clearOnSubmit: false,
              suggestions: teamLeaders,
              decoration: InputDecoration(
                labelText: 'Select a Team Leader',
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              itemBuilder: (BuildContext context, Users suggestion) {
                return ListTile(
                  title: Text('${suggestion.firstName} ${suggestion.lastName}'),
                );
              },
              itemFilter: (Users suggestion, String query) {
                return suggestion.firstName.toLowerCase().contains(query.toLowerCase()) ||
                    suggestion.lastName.toLowerCase().contains(query.toLowerCase());
              },
              itemSorter: (Users a, Users b) {
                return a.firstName.compareTo(b.firstName);
              },
              itemSubmitted: (Users value) {
                setState(() {
                  selectedLeader = value;
                  controller.text = '${value.firstName} ${value.lastName}';
                  widget.onTeamLeaderSelected(value);
                });
              },
              textSubmitted: (String query) {
                print("Text submitted: $query");
              },
            ),
          ],
        ),
      ),
    );
  }
}


class DateTimePickerTextField extends StatefulWidget {
  const DateTimePickerTextField({
    Key? key,
    this.initialDateTime,
    required this.onDateTimeChanged,
  }) : super(key: key);

  final DateTime? initialDateTime;
  final Function(DateTime) onDateTimeChanged;

  @override
  State<DateTimePickerTextField> createState() => _DateTimePickerTextFieldState();
}

class _DateTimePickerTextFieldState extends State<DateTimePickerTextField> {
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? pickedDateTime = await showDatePickerAndTimePicker(
          context: context,
          initialDateTime: selectedDateTime ?? DateTime.now(),
        );

        if (pickedDateTime != null && pickedDateTime != selectedDateTime) {
          setState(() {
            selectedDateTime = pickedDateTime;
            widget.onDateTimeChanged(pickedDateTime);
          });
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Row(
            children: [
              Icon(Icons.calendar_today),
              SizedBox(width: 10),
              Text(
                selectedDateTime != null
                    ? _formatDateTime(selectedDateTime!)
                    : 'Choose Date and Time',
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  Future<DateTime?> showDatePickerAndTimePicker({
    required BuildContext context,
    DateTime? initialDateTime,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
      );

      if (pickedTime != null) {
        pickedDate = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }

    return pickedDate;
  }
}



class LabeledTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Color cursorColor;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const LabeledTextField({
    required this.labelText,
    required this.hintText,
    required this.cursorColor,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 2, right: 2),
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          height: 50,
          child: TextFormField(
            controller: controller,
            cursorColor: cursorColor,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              labelStyle: TextStyle(color: darkBlue),
              filled: false,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: blue),
              ),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }
}



