import 'package:flutter/material.dart';
import '../utils/colors_util.dart';
import 'library.dart';
import '../utils/reuseable_widget.dart';

class activeMembers extends StatefulWidget {
  const activeMembers({Key? key}) : super(key: key);

  @override
  State<activeMembers> createState() => _activeMembersState();
}

class _activeMembersState extends State<activeMembers> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('active members'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 5; i++)
                Row(
                  children: [
                    Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: blue,
                        ),
                        child: IconButton(
                            onPressed: () {
                              // Add functionality here
                            },
                            icon: Icon(
                              Icons.car_crash,
                              color: white,
                            ))),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                  ],
                )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          TextBox(
            title1: 'Team Leader',
            value1: 3,
            title2: 'Driver',
            value2: 2,
            title3: 'Members',
            value3: 1,
            height: 60,
            width: 350,
          ),

          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          //Active members widget
          Container(
            decoration: BoxDecoration(
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Active Members",
                      style: TextStyle(fontWeight: FontWeight.bold, color: darkBlue),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  height:  MediaQuery.of(context).size.height * 0.25,
                  child: ActiveMembers(),
                ),
              ],
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,  // Set the desired width for the Divider
                child: Divider(
                  color: yellow,
                  thickness: 0.5,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
            ],
          ),
          //On a mission members widget
          Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "On a mission",
                      style: TextStyle(fontWeight: FontWeight.bold, color: darkBlue),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  height:  MediaQuery.of(context).size.height * 0.25,
                  child: OnMissionMembers(),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}

class Member {
  final String name;
  final String role;
  final IconData icon;

  Member({required this.name, required this.role, required this.icon});
}
List<Member> members = [
  Member(
      name: 'Karim Karaki',
      role: 'Team Leader',
      icon: Icons.medical_services),
  Member(name: 'Ali Test', role: 'Driver', icon: Icons.car_crash),
  Member(name: 'Fadi Test', role: 'Paramedic', icon: Icons.medical_services),
  Member(name: 'Shadi Test', role: 'EMT', icon: Icons.person),
  Member(name: 'Rami Test', role: 'EMT', icon: Icons.person),
  // Add more members as needed
];
List<Member> missionMembers = [
  Member(
      name: 'Karim Karaki',
      role: '@4:00',
      icon: Icons.medical_services),
  Member(name: 'Ali Test', role: '@ 4:00', icon: Icons.car_crash),
  Member(name: 'Fadi Test', role: '@ 4:00', icon: Icons.medical_services),
  Member(name: 'Shadi Test', role: '@ 4:00', icon: Icons.person),
  Member(name: 'Rami Test', role: '@ 4:00', icon: Icons.person),
  // Add more members as needed
];
class ActiveMembers extends StatefulWidget {
  const ActiveMembers({super.key});

  @override
  State<ActiveMembers> createState() => _ActiveMembersState();
}

class _ActiveMembersState extends State<ActiveMembers> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: members.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context , index  ){
          Member member = members[index];
          return ListTile(
            leading: IconButton(onPressed: () {  }, icon: Icon(member.icon,color: yellow,),),
            title: Text(member.name,style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold),),
            subtitle: Text(member.role,style: TextStyle(color: darkGrey,fontWeight:FontWeight.w300),),
            trailing: IconButton(onPressed: () {  }, icon: Icon(Icons.phone,color: green,),),
          );
        }

    );
  }
}
class OnMissionMembers extends StatefulWidget {
  const OnMissionMembers({super.key});

  @override
  State<OnMissionMembers> createState() => _OnMissionMembers();
}

class _OnMissionMembers extends State<OnMissionMembers> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: members.length,
        itemBuilder: (context , index  ){
          Member member = missionMembers[index];
          return ListTile(
            leading: IconButton(onPressed: () {  }, icon: Icon(member.icon,color: yellow,),),
            title: Text(member.name,style: TextStyle(color: darkBlue,fontWeight: FontWeight.bold),),
            subtitle: Text(member.role,style: TextStyle(color: darkGrey,fontWeight:FontWeight.w300),),
            trailing: IconButton(onPressed: () {  }, icon: Icon(Icons.phone,color: green,),),
          );
        }

    );
  }
}