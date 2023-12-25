import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';

import '../utils/reuseable_widget.dart';

class statusScreen extends StatefulWidget {
  const statusScreen({super.key});

  @override
  State<statusScreen> createState() => _statusScreenState();
}

class _statusScreenState extends State<statusScreen> {
  @override
  String name = 'Karim Karaki';
  String image = 'assets/test_profile.png';
  bool isPressed= false;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
            TextBox(title1: 'Team Leader', value1: 3, title2: 'Driver', value2: 2, title3: 'Members', value3: 1,height: 60,width: 350,),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            Align(
              alignment: Alignment.center,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.04,),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isPressed?Text("Welcome to Duty,",style: TextStyle(fontSize: 20,color: green),):Text("Hello,",style: TextStyle(fontSize: 20,color: darkBlue),),
                        Text(name,style: TextStyle(fontSize: 30,color: darkBlue,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.15,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      width: 100, // Adjust the width as needed
                      height: 100, // Adjust the height as needed
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: !isPressed?red:green, // Border color
                          width: 2.0, // Border width
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 50, // Adjust the radius as needed
                        backgroundImage: AssetImage('assets/test_profile.png'),
                      ),
                    ),
                  ),
                ],
              ),
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
                  color: !isPressed?darkGrey:blue2, // Border color
                  width: 10.0, // Border width
                ),
              ),
              child: IconButton(
                onPressed: (){
                  setState(() {
                    isPressed = !isPressed;
                  });
                    print(isPressed);
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

    );
  }

}