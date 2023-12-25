import 'package:flutter/material.dart';

import '../utils/colors_util.dart';
import '../utils/reuseable_widget.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  bool _isPressed = false;
  String _profile = 'Profile';
  String _editProfile = 'Edit Profile';
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!_isPressed?_profile:_editProfile, style: TextStyle(color: darkBlue)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/profile_background.png'),
                  fit: BoxFit.cover,
                ),
              ),
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
                          _isPressed?IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt , size: 40,color: yellow,)):Container()
                        ],
                      ),
                  SizedBox(height: 20.0),
                  !_isPressed?const Column(
                    children: [
                      Text(
                        'Karim Karaki',
                        style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Team Leader',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ):Container(),
                  !_isPressed? CustomButton(text: _editProfile, color: blue, toDo: (){setState(() {
                    _isPressed = true;
                  });})
                      :Container(),
                  !_isPressed?ViewProfile():EditProfile(),
                  _isPressed?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    CustomButton(text: 'Back', color: blue, toDo: (){ setState(() {_isPressed = false;});}),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05,),
                    CustomButton(text: 'Edit', color: green,
                        toDo: (){ showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: green,
                              title: Icon(Icons.check_circle ,size: 80, color: white,),
                              content: Text('Profile updated successfully!',style: TextStyle(color: white),textAlign: TextAlign.center,),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                    setState(() {
                                      _isPressed = false; // Update the _isPressed state
                                    });
                                  },
                                  child: Text('OK',style: TextStyle(color: white),),
                                ),
                              ],
                            );
                          },
                        );
                    })
                  ],):Container(),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ViewProfile extends StatefulWidget {
   ViewProfile({super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        SizedBox(height: MediaQuery.of(context).size.height *0.025),
        Padding(
            padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Phone', value: '70779006',),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Role|s', value: 'Team Leader',),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Duty', value: 'Friday',),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Since', value: '2022',),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Hours', value: '100',),
            )
        ),
      ],
    );
  }
}
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: TextField(
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
              )
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 16.3, right: 16.3),
            child: Align(
                alignment: Alignment.topCenter,
                child: TextField(
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
                )
            )
        ),

      ],
    );
  }
}
