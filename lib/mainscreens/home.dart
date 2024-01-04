import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/login/log_in.dart';
import 'package:markaz_maifadoun/mainscreens/profile.dart';
import 'package:markaz_maifadoun/mainscreens/status.dart';
import 'package:markaz_maifadoun/teamLeader/missions.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../database/users.dart';
import 'checkup.dart';
import 'library.dart';
import 'members.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int  role = 0;

  Future<void> initializeData() async {
    try {
      await Users.initUsersLists();
      await Users.initializeLoggedInUser();
      setState(() {
        role = Users.loggedInUser?.role ?? 0;
        print('role is $role');
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

  final List<Widget> _pages = [
    activeMembers(),
    CheckUp(),
    statusScreen(),
    libraryScreen(),
    Container(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: _currentIndex == 0 ? yellow : darkBlue),
            label: 'Active',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist_outlined, color: _currentIndex == 1 ? yellow : darkBlue),
            label: 'CheckUp',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb, color: _currentIndex == 2 ? yellow : darkBlue),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books, color: _currentIndex == 3 ? yellow : darkBlue),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, color: _currentIndex == 4 ? yellow : darkBlue),
            label: 'Menu',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 4) {
            _showMenuBottomSheet(context);
            initializeData();
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        selectedItemColor: yellow,
        unselectedItemColor: darkBlue,
        selectedLabelStyle: TextStyle(color: yellow),
        unselectedLabelStyle: TextStyle(color: darkBlue),
      ),
    );
  }

  void _showMenuBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      color: blue
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.person, color: yellow,),
                  ),
                  title: Text('Profile',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold)),
                  onTap: () {
                    // Handle Settings button tap
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=> const Profile()  )
                    );
                  },
                ),
                role==0? ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: blue
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset('assets/mission-icon.png',height: 25,width: 25,),
                  ),
                  title: Text('Missions',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> const Missions()  )
                    );
                  },
                ):Container(),
                role>0? ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(5.0),
                          bottomLeft: Radius.circular(5.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                        color: blue
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset('assets/shifts-icon.png',height: 25,width: 25,color: yellow,),
                  ),
                  title: Text('Shift',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=> const Missions()  )
                    );
                  },
                ):Container(),
                ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(5.0),
                    bottomLeft: Radius.circular(5.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  color: red
              ),
              padding: EdgeInsets.all(8.0),
              child: Image.asset('assets/logout-icon.png',height: 25,width: 25,color: white,),
            ),
            title: Text('Logout', style: TextStyle(color: red, fontWeight: FontWeight.bold)),
            onTap: () {
              logOutFunction();
            },
          )

          ],
            ),
          ),
        );
      },
    );
  }
  logOutFunction(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: red,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.exit_to_app_outlined, size: 100, color: white),
              SizedBox(height: 20),
              Text('Are you sure?', style: TextStyle(color: white,fontSize: 25,fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    fixedSize: MaterialStateProperty.all<Size>(Size(120.0, 30.0)),
                  ),
                  child: Text('No', style: TextStyle(color: white)),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
                    clearUserSession();
                    await signOut();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(blue),
                    fixedSize: MaterialStateProperty.all<Size>(Size(120.0, 30.0)),
                  ),
                  child: Text('Yes', style: TextStyle(color: white)),
                ),
              ],
            ),
          ],

        );
      },
    );
  }
  Future<void> clearUserSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
    // Clear other user-related information if needed
  }
  Future<void> signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
