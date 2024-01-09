import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/colors_util.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  bool isDuty2Visible = false;

  bool isDriver = false;
  bool isActive = false;
  bool onMission = false;
  bool isFrozen = false;
  int role = 0;
  int rank = 0;
  int duty = 0;
  int duty2 = 0;


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
              icon: Icon(Icons.arrow_back_ios, color: white , weight:10 ,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Add Member',
              style: TextStyle(color: white,fontWeight: FontWeight.bold),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height+80,
            child:Center(
              child: Container(
                width: MediaQuery.of(context).size.width*1,
                height:  MediaQuery.of(context).size.height*1,
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
            ) ,
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height+80,
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
                            controller: firstNameController,
                            decoration: InputDecoration(labelText: 'First Name'),
                          ),
                          TextFormField(
                            controller: lastNameController,
                            decoration: InputDecoration(labelText: 'Last Name'),
                          ),
                          TextFormField(
                            controller: phoneNumberController,
                            decoration: InputDecoration(labelText: 'Phone Number'),
                          ),
                          SizedBox(height:16.0),
                          Row(
                            children: [
                              Text('Is Driver:   '),
                              Switch(
                                value: isDriver,
                                onChanged: (value) {
                                  setState(() {
                                    isDriver = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height:16.0),
                          Row(
                            children: [
                              Text('Select Role:  '),
                              DropdownButton<int>(
                                value: role,
                                onChanged: (value) {
                                  setState(() {
                                    role = value!;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text('Medic'),
                                  ),
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Team Leader'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Admin'),
                                  ),
                                  // Add more role options as needed
                                ],
                                hint: const Text('Select Role'),
                              ),
                            ],
                          ),
                          SizedBox(height:16.0),
                          Row(
                            children: [
                              const Text('Select Rank:  '),
                              DropdownButton<int>(
                                value: rank,
                                onChanged: (value) {
                                  setState(() {
                                    rank = value!;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text('EMR'),
                                  ),
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('EMT'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Paramedic'),
                                  ),
                                ],
                                hint: Text('Select Rank'),
                              ),
                            ],
                          ),
                          SizedBox(height:16.0),
                          Row(
                            children: [
                              Text('Select Duty Day:  '),
                              DropdownButton<int>(
                                value: duty,
                                onChanged: (value) {
                                  setState(() {
                                    duty = value!;
                                  });
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: 0,
                                    child: Text('No Duty Day'),
                                  ),
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Text('Monday'),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Text('Tuesday'),
                                  ),
                                  DropdownMenuItem(
                                    value: 3,
                                    child: Text('Wednesday'),
                                  ),
                                  DropdownMenuItem(
                                    value: 4,
                                    child: Text('Thursday'),
                                  ),
                                  DropdownMenuItem(
                                    value: 5,
                                    child: Text('Friday'),
                                  ),
                                  DropdownMenuItem(
                                    value: 6,
                                    child: Text('Saturday'),
                                  ),
                                  DropdownMenuItem(
                                    value: 7,
                                    child: Text('Sunday'),
                                  ),
                                ],
                                hint: Text('Select Duty'),
                              ),
                              IconButton(onPressed: (){
                                setState(() {
                                  isDuty2Visible = !isDuty2Visible;
                                });
                              }, icon: Icon(isDuty2Visible?Icons.minimize_outlined:Icons.add)),
                            ],
                          ),
                          SizedBox(height:16.0),
                          Visibility(
                            visible: isDuty2Visible,
                            child: Row(
                              children: [
                                Text('Select Duty Day 2:  '),
                                DropdownButton<int>(
                                  value: duty2,
                                  onChanged: (value) {
                                    setState(() {
                                      duty2 = value!;
                                    });
                                  },
                                  items: const [
                                    DropdownMenuItem(
                                      value: 0,
                                      child: Text('No Duty Day'),
                                    ),
                                    DropdownMenuItem(
                                      value: 1,
                                      child: Text('Monday'),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: Text('Tuesday'),
                                    ),
                                    DropdownMenuItem(
                                      value: 3,
                                      child: Text('Wednesday'),
                                    ),
                                    DropdownMenuItem(
                                      value: 4,
                                      child: Text('Thursday'),
                                    ),
                                    DropdownMenuItem(
                                      value: 5,
                                      child: Text('Friday'),
                                    ),
                                    DropdownMenuItem(
                                      value: 6,
                                      child: Text('Saturday'),
                                    ),
                                    DropdownMenuItem(
                                      value: 7,
                                      child: Text('Sunday'),
                                    ),
                                  ],
                                  hint: Text('Select Duty 2'),
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 20,),
                          ElevatedButton(
                            onPressed: () {
                              _addUser();
                            },
                            child: Text('Add Member'),
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

  Future<void> _addUser() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    String phoneNumber = phoneNumberController.text;

    try {
      // Check if the phone number already exists
      bool phoneNumberExists = await _checkPhoneNumberExists(phoneNumber);

      if (phoneNumberExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number already in use!'),
          ),
        );
      } else {
        await users.doc(phoneNumber).set({
          'fname': firstNameController.text,
          'lname': lastNameController.text,
          'isDriver': isDriver,
          'isActive': isActive,
          'role': role,
          'rank': rank,
          'phoneNumber': phoneNumber,
          'duty': duty,
          'duty2': duty2,
          'onMission': onMission,
          'isFrozen': isFrozen,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User added successfully!'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add user: $e'),
        ),
      );
    }
  }

  Future<bool> _checkPhoneNumberExists(String phoneNumber) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    DocumentSnapshot snapshot = await users.doc(phoneNumber).get();
    return snapshot.exists;
  }

}
