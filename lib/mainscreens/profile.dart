import 'package:flutter/material.dart';

import '../database/users.dart';
import '../utils/colors_util.dart';
import '../utils/reuseable_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = true;
  String _editProfile = 'Edit Profile';
  String name='';
  String rank = '';
  String role = '';
  String phoneNumber = '';
  String dutyDay='';
  String dutyDay2='';
  bool isDriver = false;
  String year = '';
  String driver = '';

  Future<void> initializeData() async {
    try {
      await Users.initUsersLists();
      await Users.initializeLoggedInUser();

      setState(() {
        name = '${Users.loggedInUser!.firstName} ${Users.loggedInUser!.lastName}';
        rank = '${Users.loggedInUser!.userRank}';
        role = '${Users.loggedInUser!.userRole}';
        phoneNumber = '${Users.loggedInUser!.phoneNumber}';
        dutyDay = '${Users.loggedInUser!.dutyDay}';
        dutyDay2 = '${Users.loggedInUser!.dutyDay2}';
        year = '${Users.loggedInUser!.year}';
        isDriver = Users.loggedInUser?.isDriver ?? false;
        if(isDriver){driver = '- Driver';}
        isLoading = false;
      });
    } catch (e) {
      print("Error initializing data: $e");
    }
  }
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isLoading
          ? SpinKitFadingCircle(
        color: Colors.blue,
        size: 50.0,
      ): Stack(
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
             'Profile',
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

                        ],
                      ),
                  SizedBox(height: 20.0),
                  Column(
                    children: [
                      Text(
                        name,
                        style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '$rank - $role $driver',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                  CustomButton(text: _editProfile, color: blue, toDo: (){
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditProfile(phoneNumber: phoneNumber,)),
                    );
                  }),
                 ViewProfile(rank: rank, role: role, phoneNumber: phoneNumber, dutyDay: dutyDay, dutyDay2: dutyDay2, isDriver: isDriver, year: year)

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
  final String rank;
  final String role ;
  final String phoneNumber;
  final String dutyDay;
  final String dutyDay2;
  final bool isDriver;
  final String year;
   ViewProfile({super.key , required this.rank, required this.role,required this.phoneNumber,required this.dutyDay,required this.dutyDay2,required this.isDriver,required this.year});

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
              child: ValueBox(title: 'Phone', value: widget.phoneNumber,),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Role', value: widget.role,),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Rank', value: widget.rank,),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Duty', value: '${widget.dutyDay} ${widget.dutyDay2}',),
            )
        ),
        Padding(
            padding: EdgeInsets.only(top: 10.0, bottom: 5.0, left: 16.3, right: 16.3),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueBox(title: 'Since', value: widget.year,),
            )
        ),
      ],
    );
  }
}

