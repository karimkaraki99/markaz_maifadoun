import 'package:flutter/material.dart';
import '../database/users.dart';
import '../database/vehicle.dart';
import '../utils/colors_util.dart';
import '../utils/reuseable_widget.dart';

class ActiveMembersScreen extends StatefulWidget {
  const ActiveMembersScreen({Key? key}) : super(key: key);

  @override
  _ActiveMembersScreenState createState() => _ActiveMembersScreenState();
}

class _ActiveMembersScreenState extends State<ActiveMembersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    Users.initUsersLists();
    super.initState();
    _scrollController.animateTo(
      0,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
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
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.09,
            child: CarsListScreen(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          isLoading
              ? CircularProgressIndicator()
              : TextBox(
            title1: 'Team Leader',
            value1: Users.activeTeamMemberUsersList.length,
            title2: 'Driver',
            value2: Users.activeDriverUsersList.length,
            title3: 'Members',
            value3: Users.activeUsersList.length,
            height: 60,
            width: 350,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          // Active members widget
          Container(
            decoration: BoxDecoration(),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Active Members",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darkBlue),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.27,
                  alignment: Alignment.topCenter,
                  child: ActiveMembersList(),
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
                width: MediaQuery.of(context).size.width *
                    0.9, // Set the desired width for the Divider
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
          // On a mission members widget
          Container(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "On a mission",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: darkBlue),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                IntrinsicHeight(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: OnMissionMembersList(),
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

class ActiveMembersList extends StatefulWidget {
  const ActiveMembersList({Key? key}) : super(key: key);

  @override
  State<ActiveMembersList> createState() => _ActiveMembersListState();
}

class _ActiveMembersListState extends State<ActiveMembersList> {
  final ScrollController _scrollController = ScrollController();
  List<Users> _activeUsers = [];
  late int activeNumber;

  @override
  void initState() {
    super.initState();
    loadActiveUsers();
  }

  Future<void> loadActiveUsers() async {
    setState(() {
      _activeUsers = Users.availableMembers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: _activeUsers.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          Users user = _activeUsers[index];
          return ListTile(
            leading: Icon(
                user.isDriver
                    ? Icons.car_crash_sharp
                    : (user.role == 2 || user.role == 1)
                    ? Icons.medical_services
                    : Icons.person,
                color: yellow),
            title: Text('${user.firstName} ${user.lastName}',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            subtitle: Text('Role: ${user.userRole}',
                style: TextStyle(
                    color: darkGrey, fontWeight: FontWeight.w300)),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.phone, color: Colors.green),
            ),
          );
        },
    );
  }
}

class OnMissionMembersList extends StatefulWidget {
  const OnMissionMembersList({Key? key}) : super(key: key);

  @override
  State<OnMissionMembersList> createState() => _OnMissionMembersListState();
}

class _OnMissionMembersListState extends State<OnMissionMembersList> {
  List<Users> _onMissionUsers = [];

  @override
  void initState() {
    super.initState();
    loadonMissionUsers();
  }

  Future<void> loadonMissionUsers() async {
    setState(() {
      _onMissionUsers = Users.onMissionMembers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero, // Set padding to zero
      child: ListView.builder(
        itemCount: _onMissionUsers.length,
        itemBuilder: (context, index) {
          Users user = _onMissionUsers[index];
          return ListTile(
            leading: Icon(
                user.isDriver
                    ? Icons.car_crash_sharp
                    : (user.role == 2 || user.role == 1)
                    ? Icons.medical_services
                    : Icons.person,
                color: yellow),
            title: Text('${user.firstName} ${user.lastName}',
                style: TextStyle(
                    color: darkBlue, fontWeight: FontWeight.bold)),
            subtitle: Text(user.userRole,
                style: TextStyle(
                    color: darkGrey, fontWeight: FontWeight.w300)),
            trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.phone, color: green),
            ),
          );
        },
      ),
    );
  }
}
