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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: darkBlue)),
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
                AppBar().preferredSize.height+20,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 130,
                      height: 130,
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
                  SizedBox(height: 20.0),
                  Text(
                    'Karim Karaki',
                    style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Team Leader',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 20,),
                  ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(blue),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          )
                        ),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
                          )
                      ),
                      onPressed: (){},
                      child: Text('Edit Button',style: TextStyle(fontSize: 18),)),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
