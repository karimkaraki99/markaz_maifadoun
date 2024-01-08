import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markaz_maifadoun/admin/view_members.dart';
import 'package:markaz_maifadoun/utils/reuseable_widget.dart';
import '../database/users.dart';
import '../utils/colors_util.dart';

class EditUserPage extends StatefulWidget {
  final Users user;

  const EditUserPage({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
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
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  void _initializeFormFields() {
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    phoneNumberController.text = widget.user.phoneNumber;
    isDriver = widget.user.isDriver;
    isActive = widget.user.isActive;
    role = widget.user.role;
    rank = widget.user.rank;
    duty = widget.user.duty;
    duty2 = widget.user.duty2 ?? 0;
    isDuty2Visible = duty2 != 0;
    onMission = widget.user.onMission;
    isFrozen = widget.user.isFrozen;
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
              'Edit Member',
              style: TextStyle(color: white, fontWeight: FontWeight.bold),
            ),
            actions: [
              isFrozen?IconButton(
                  icon: Icon(Icons.lock_open, color: white),
                  onPressed: () {
                    _showUnFreezeConfirmationDialog();
                  }
              )
                  :
              IconButton(
                icon: Icon(Icons.lock, color: white),
                onPressed: () {
                  _showFreezeConfirmationDialog();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: white),
                onPressed: () {
                  _showDeleteConfirmationDialog();
                }
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
                            isFrozen ? 'Status: Frozen' : 'Status: Available',
                            style: TextStyle(
                             fontWeight: FontWeight.bold,
                              color: isFrozen ?red:green,
                            ),
                            textAlign: TextAlign.center,
                          ),

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
                            decoration:
                            InputDecoration(labelText: 'Phone Number'),
                            readOnly: true,
                          ),
                          SizedBox(height: 16.0),
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
                          SizedBox(height: 16.0),
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
                                ],
                                hint: const Text('Select Role'),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
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
                          SizedBox(height: 16.0),
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
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isDuty2Visible = !isDuty2Visible;
                                    });
                                  },
                                  icon: Icon(isDuty2Visible
                                      ? Icons.minimize_outlined
                                      : Icons.add)),
                            ],
                          ),
                          SizedBox(height: 16.0),
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
                          SizedBox(height: 20),
                          CustomButton(
                            toDo:  () {
                              _updateUser();
                            },
                            text: 'Update Member',
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

  Future<void> _updateUser() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    try {
      await users.doc(phoneNumberController.text).update({
        'fname': firstNameController.text,
        'lname': lastNameController.text,
        'isDriver': isDriver,
        'isActive': isActive,
        'role': role,
        'rank': rank,
        'duty': duty,
        'duty2': duty2,
        'onMission': onMission,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User updated successfully!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user: $e'),
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
          title: Text('Delete User',style: TextStyle(color: white,fontWeight: FontWeight.bold),),
          content: Text('Are you sure you want to delete this user?',style: TextStyle(color: white),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel',style: TextStyle(color: white),),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteUser();
              },
              child: Text('Delete',style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }
  Future<void> _deleteUser() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    try {
      await users.doc(widget.user.phoneNumber).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('User deleted successfully!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $e'),
        ),
      );
    }
  }
  Future<void> _showFreezeConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: red,
          title: Text('Freeze User',style: TextStyle(color: white,fontWeight: FontWeight.bold),),
          content: Text('Are you sure you want to freeze this user?',style: TextStyle(color: white),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',style: TextStyle(color: white),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _toggleFreezeUser();
              },
              child: Text('Freeze',style: TextStyle(color: white,fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }
  Future<void> _showUnFreezeConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: green,
          title: Text('Unfreeze User',style: TextStyle(color: white,fontWeight: FontWeight.bold),),
          content: Text('Are you sure you want to unfreeze this user?',style: TextStyle(color: white),),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',style: TextStyle(color: white),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _toggleFreezeUser();
              },
              child: Text('Unfreeze',style: TextStyle(color: white,fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleFreezeUser() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    try {
      DocumentSnapshot userSnapshot = await users.doc(widget.user.phoneNumber).get();
      bool currentIsFrozen = userSnapshot['isFrozen'] ?? false;

      bool updatedIsFrozen = !currentIsFrozen;

      await users.doc(widget.user.phoneNumber).update({'isFrozen': updatedIsFrozen});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(updatedIsFrozen ? 'User frozen successfully!' : 'User unfrozen successfully!'),
        ),
      );

      Navigator.pop(context);
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ShowUsers()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update user status: $e'),
        ),
      );
    }
  }


}
