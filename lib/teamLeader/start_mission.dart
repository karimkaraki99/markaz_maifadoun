import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/database/users.dart';
import '../database/vehicle.dart';
import '../utils/colors_util.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';


class StartMission extends StatefulWidget {
  const StartMission({super.key});

  @override
  State<StartMission> createState() => _StartMissionState();
}

class _StartMissionState extends State<StartMission> {
  TextEditingController patientName = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController destination = TextEditingController();
  TextEditingController approvalId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start a Mision',style: TextStyle(color: white),),
        centerTitle: true,
        backgroundColor: blue,
        iconTheme: IconThemeData(
          color: white
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CarDropDown(),
              TeamLeaderDropDown(),
              DriverDropDown(),
              TeamMembersDropDown(),
              TeamMembersDropDown(),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                  color: blue
                ),
                width: double.infinity,
                height: 1,
              ),
              SizedBox(height: 10,),
              MissionTypeDropdown(
                onChanged: (selectedMissionType) {
                },
              ),
              DatePickerTextField(
                initialDate: DateTime.now(),
                onDateChanged: (selectedDate) {
                  print("Selected Date: $selectedDate");
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
  final Function(String?) onChanged;

  @override
  State<MissionTypeDropdown> createState() => _MissionTypeDropdownState();
}

class _MissionTypeDropdownState extends State<MissionTypeDropdown> {
  final List<String> missionTypes = ['Rescue', 'Medical', 'Transport', 'Other'];
  String? selectedMissionType;

  @override
  void initState() {
    super.initState();
    selectedMissionType = widget.initialValue;
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
          selectedMissionType = newValue;
          widget.onChanged(newValue);
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
  const CarDropDown({Key? key}) : super(key: key);

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
        cars = Car.allCarsList;
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
              color: yellow,
            ),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              width: 100,
              color: Colors.grey,
            ),
            onChanged: (Car? newValue) {
              setState(() {
                selectedValue = newValue!;
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
  const DriverDropDown({Key? key}) : super(key: key);

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
        drivers = Users.allDriversList;
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
              suggestions: drivers,
              decoration: InputDecoration(
                labelText: 'Select a Driver',
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
                  selectedValue = value;
                  controller.text = '${value.firstName} ${value.lastName}'; // Update text field with name
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
  const TeamMembersDropDown({Key? key}) : super(key: key);

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
        members = Users.allUsersList;
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
  const TeamLeaderDropDown({Key? key}) : super(key: key);

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
        teamLeaders = Users.allTeamLeadersList;
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
                  controller.text = '${value.firstName} ${value.lastName}'; // Update text field with name
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


class DatePickerTextField extends StatefulWidget {
  const DatePickerTextField({
    Key? key,
    this.initialDate,
    required this.onDateChanged,
  }) : super(key: key);

  final DateTime? initialDate;
  final Function(DateTime) onDateChanged;

  @override
  State<DatePickerTextField> createState() => _DatePickerTextFieldState();
}

class

_DatePickerTextFieldState

    extends

    State<DatePickerTextField> {
  DateTime? selectedDate;

  @override


  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(
        text: selectedDate != null ? _formatDate(selectedDate!) : '',
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null && pickedDate != selectedDate) {
          setState(() {
            selectedDate = pickedDate;
            widget.onDateChanged(pickedDate);
          });
        }
      },
      decoration: InputDecoration(
        labelText: 'Choose Date',
        suffixIcon: Icon(Icons.calendar_today),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
class LabeledTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Color cursorColor;
  final TextEditingController controller;

  const LabeledTextField({
    required this.labelText,
    required this.hintText,
    required this.cursorColor,
    required this.controller,
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $labelText';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}


