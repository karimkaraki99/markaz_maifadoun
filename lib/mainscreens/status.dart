import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';
import '../database/users.dart';
import '../utils/reuseable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class statusScreen extends StatefulWidget {
  const statusScreen({super.key});

  @override
  State<statusScreen> createState() => _statusScreenState();
}

class _statusScreenState extends State<statusScreen> {
  bool isPressed = false;
  bool isLoading = true;
  String name = '';
  String image = '';

  Future<String?> getUserPhoneNumber() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null && user.phoneNumber != null) {
      String phoneNumber = user.phoneNumber!.startsWith('+961')
          ? user.phoneNumber!.substring(4)
          : user.phoneNumber!;
      return phoneNumber;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      await Users.initUsersLists();
      await Users.initializeLoggedInUser();

      setState(() {
        name = '${Users.loggedInUser!.firstName} ${Users.loggedInUser!.lastName}';
        isPressed = Users.loggedInUser?.isActive ?? false;
        isLoading = false;
      });
    } catch (e) {
      print("Error initializing data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const SpinKitFadingCircle(
        color: Colors.blue,
        size: 50.0,
      ):SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
              TextBox(title1: 'Team Leader', value1: Users.activeTeamMemberUsersList.length, title2: 'Driver', value2: Users.activeDriverUsersList.length, title3: 'Members', value3: Users.activeUsersList.length,height: 60,width: 350,),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
              ListTile(
                title: isPressed?Text("Welcome to Duty,",style: TextStyle(fontSize: 20,color: green),)
                    :Text("Hello,",style: TextStyle(fontSize: 20,color: darkBlue),),
                subtitle: Text(name,style: TextStyle(fontSize: 30,color: darkBlue,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
              Text.rich(
                TextSpan(
                    children:[
                      TextSpan(
                        text: "Status: ",
                        style: TextStyle(
                          color: darkBlue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      !isPressed?TextSpan(
                        text: "Not Available",
                        style: TextStyle(
                          color: red,
                          fontWeight: FontWeight.bold
                        ),
                      ):TextSpan(
                        text: "Available",
                        style: TextStyle(
                            color: green,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ]
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                  !isPressed?grey:blue,
                  border: Border.all(
                    color: !isPressed?darkGrey:blue2,
                    width: 10.0,
                  ),
                ),
                child: IconButton(
                  onPressed: () async {
                    setState(() {
                      isPressed = !isPressed;
                    });
          
                    try {
                      String? phoneNumber = await getUserPhoneNumber();
                      print(phoneNumber);
          
                      if (phoneNumber != null) {
                        showDialog(
                          context: context,
                          barrierDismissible: false, // Prevent user interaction
                          builder: (context) => Center(child: CircularProgressIndicator()),
                        );
          
                        await Users.updateActiveStatus(phoneNumber, isPressed);
          
                        Navigator.pop(context); // Close the loading dialog
          
                        print('Active status for $phoneNumber updated to $isPressed');
                      } else {
                        print('Error: Phone number not found in SharedPreferences');
          
                      }
                    } catch (e) {
                      print("Error updating isActive status: $e");
                    }
                  },
                  icon: !isPressed?Image.asset(
                    'assets/buttonOff.png',
                    width: 150,
                    height: 150,
                    ):Image.asset('assets/buttonOn.png',
                    width: 150,
                    height: 150,
                    ),
          
                ),
              )
            ],
          ),
        ),
      ),

    );
  }

}