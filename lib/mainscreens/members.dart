import 'package:flutter/material.dart';
import '../database/users.dart';
import '../database/vehicle.dart';
import '../login/log_in.dart';
import '../utils/colors_util.dart';
import '../utils/reuseable_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActiveMembersScreen extends StatefulWidget {
  const ActiveMembersScreen({Key? key}) : super(key: key);

  @override
  _ActiveMembersScreenState createState() => _ActiveMembersScreenState();
}

class _ActiveMembersScreenState extends State<ActiveMembersScreen> {
  bool isLoading = true;
  bool isFrozen = false;
  @override
  void initState() {
    loading();
    checkIsFrozen();
    super.initState();

  }
  Future<void> loading() async{
    await Users.initUsersLists().then((value) async {
      setState(()  {
        isLoading = false;
      });
    });
  }
  Future<void> checkIsFrozen() async{
    await Users.initializeLoggedInUser();
    isFrozen =  await Users.loggedInUser?.isFrozen ?? false;
    print('isFroezn : $isFrozen');
    if(isFrozen){signOut();}
  }

  Future<void> signOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("""You don't have authority"""),
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      print("Error signing out: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:   isLoading
          ? const SpinKitFadingCircle(
        color: Colors.blue,
        size: 50.0,
      )
          :Column(
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
              ? const CircularProgressIndicator()
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
            decoration: const BoxDecoration(),
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
                  child: const ActiveMembersList(),
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
                    child: const OnMissionMembersList(),
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
  List<Users> _activeUsers = [];
  late int activeNumber;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadActiveUsers();
  }

   loadActiveUsers() async {
    setState((){
      Users.initUsersLists();
      _activeUsers = Users.availableMembers;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SpinKitFadingCircle(
      color: Colors.blue,
      size: 50.0,
    ) : ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _activeUsers.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          Users user = _activeUsers[index];
          return ListTile(
            leading: Icon(
                user.isDriver
                    ? Icons.drive_eta
                    : (user.role == 2 || user.role == 1)
                    ? Icons.medical_services
                    : Icons.person,
                color: yellow),
            title: Text('${user.firstName} ${user.lastName}',
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            subtitle: Text('Role: ${user.userRole}',
                style: TextStyle(
                    color: darkGrey, fontWeight: FontWeight.w300)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    final String phoneNumber = user.phoneNumber;
                    final Uri launchUri = Uri(
                      scheme: 'tel',
                      path: phoneNumber,
                    );
                    if (await canLaunchUrl(launchUri)) {
                      await launchUrl(launchUri);
                    } else {
                      print('Could not launch phone call');
                    }
                  },
                  icon: const Icon(Icons.phone, color: Colors.green),
                ),
                IconButton(
                  onPressed: () async {
                    final String phoneNumber = user.phoneNumber;
                    final String uriString = 'https://wa.me/961$phoneNumber';
                    if (await canLaunchUrl(Uri.parse(uriString))) {
                      await launchUrl(Uri.parse(uriString));
                    } else {
                      print('Could not launch WhatsApp');
                    }
                  },
                  icon: Icon(Icons.message, color: Colors.green),
                ),
              ],
            )
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
    loadingMissionUsers();
  }

  Future<void> loadingMissionUsers() async {
    setState(() {
      _onMissionUsers = Users.onMissionMembers;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero, // Set padding to zero
      child: ListView.builder(
        padding: EdgeInsets.zero,
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
