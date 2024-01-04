import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markaz_maifadoun/mainscreens/profile.dart';

import '../utils/colors_util.dart';
import '../utils/reuseable_widget.dart';
class EditProfile extends StatefulWidget {
  String phoneNumber;
  EditProfile({super.key,required this.phoneNumber});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();

  void _updateUserData() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String phoneNumber = widget.phoneNumber;

        if (phoneNumber != null) {
          // Update user data in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(phoneNumber)
              .update({
            'fname': _firstNameController.text,
            'lname': _lastNameController.text,
          });
          print('User data updated successfully');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: green,
                title: Icon(Icons.check_circle ,size: 80, color: white,),
                content: Text('Profile updated successfully!',style: TextStyle(color: white),textAlign: TextAlign.center,),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Profile()),
                      );// Close the dialog
                    },
                    child: Text('OK',style: TextStyle(color: white),),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Error updating user data: $e');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: red,
              title: Icon(Icons.check_circle ,size: 80, color: white,),
              content: Text('Error updating user data!',style: TextStyle(color: white),textAlign: TextAlign.center,),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK',style: TextStyle(color: white),),
                ),
              ],
            );
          },
        );
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
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
            title: Text(
              'Edit Profile',
              style: TextStyle(color: white,fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(
              color: white
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
                AppBar().preferredSize.height,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:yellow,
                              width: 4.0,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/test_profile.png'),
                          ),
                        ),
                      ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt , size: 40,color: yellow,))
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.3, right: 16.3),
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: TextFormField(
                                    controller: _firstNameController,
                                    cursorColor: yellow,
                                    decoration: InputDecoration(
                                      labelText: 'First Name',
                                      labelStyle: TextStyle(color: darkGrey),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(color: darkGrey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(color: darkGrey),
                                      ),
                                    ),
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                  )
                              )
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 16.3, right: 16.3),
                              child: Align(
                                  alignment: Alignment.topCenter,
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    cursorColor: yellow,
                                    decoration: InputDecoration(
                                      labelText: 'Last Name',
                                      labelStyle: TextStyle(color: darkGrey),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(color: darkGrey),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: BorderSide(color: darkGrey),
                                      ),
                                    ),
                                    validator: (value){
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your last name';
                                      }
                                      return null;
                                    },
                                  )
                              )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomButton(text: 'Back', color: blue, toDo: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                              CustomButton(text: 'Edit', color: green,
                                  toDo: (){
                                    _updateUserData();
                                  })
                            ],)
                        ],
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


