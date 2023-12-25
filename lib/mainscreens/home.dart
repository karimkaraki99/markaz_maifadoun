import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/login/log_in.dart';
import 'package:markaz_maifadoun/mainscreens/profile.dart';
import 'package:markaz_maifadoun/mainscreens/status.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';

import 'checkup.dart';
import 'library.dart';
import 'members.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Initially selected index

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
                  leading: Icon(Icons.person, color: darkBlue,),
                  title: Text('Profile',style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold)),
                  onTap: () {
                    // Handle Settings button tap
                    Navigator.push(context, 
                    MaterialPageRoute(builder: (context)=> const Profile()  )
                    );
                  },
                ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: red),
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false,
                    );
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
}
