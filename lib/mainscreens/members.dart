import 'package:flutter/material.dart';
import '../database/users.dart';
import '../database/vehicle.dart';
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
  void initState() {
    Users.initUsersLists();
    super.initState();
  }
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          SizedBox(
            width:  MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.09,
            child: CarsListScreen(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          isLoading?CircularProgressIndicator(): TextBox(
            title1: 'Team Leader',
            value1: Users.activeTeamMemberUsersList.length,
            title2: 'Driver',
            value2: Users.activeDriverUsersList.length,
            title3: 'Members',
            value3:  Users.activeUsersList.length,
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
                  height: MediaQuery.of(context).size.height * 0.27,
                  alignment: Alignment.topCenter,  // Align content to the top
                  child: ActiveMembers(),
                )
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
                IntrinsicHeight(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: OnMissionMembers(),
                  ),
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
  List<Users> _activeUsers = [];
  late int activeNumber ;
  @override
  void initState() {
    super.initState();
    loadActiveUsers();
  }

  Future<void> loadActiveUsers() async {
    List<Users> users = await Users.getActiveUsers();
    setState(() {
      _activeUsers = users;
      int activeNumber = _activeUsers.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _activeUsers.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          Users user = _activeUsers[index];
          return ListTile(
            leading: Icon(user.isDriver?Icons.car_crash_sharp:(user.role ==2 || user.role ==1)?Icons.medical_services:Icons.person,color: yellow),
            title: Text('${user.firstName} ${user.lastName}', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            subtitle:  Text('Role: ${user.userRole}', style: TextStyle(color: darkGrey,fontWeight:FontWeight.w300),),
            trailing: IconButton(
              onPressed: () {
                // Perform action when the phone icon is pressed
              },
              icon: Icon(Icons.phone, color: Colors.green),
            ),
          );
        },
      ),
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
        itemCount: missionMembers.length,
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
