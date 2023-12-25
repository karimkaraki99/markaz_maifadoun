import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';

import '../utils/vehicle_checkup.dart';

class CheckUp extends StatefulWidget {
  const CheckUp({Key? key}) : super(key: key);

  @override
  State<CheckUp> createState() => _CheckUpState();
}

class _CheckUpState extends State<CheckUp> {
  bool clinic = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        clinic = false;
                      });
                    },
                    child: Text("Vehicle Checkup", style: TextStyle(color: white)),
                    style: ButtonStyle(
                      backgroundColor: clinic?MaterialStateProperty.all<Color>(darkBlue):MaterialStateProperty.all<Color>(grey),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        clinic = true;
                      });
                    },
                    child: Text("Clinic Checkup", style: TextStyle(color: white)),
                    style: ButtonStyle(
                      backgroundColor: !clinic?MaterialStateProperty.all<Color>(darkBlue):MaterialStateProperty.all<Color>(grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          clinic ? CheckUpForm() : VehicleCheckup(),
        ],
      ),
    );
  }
}

class CheckUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Clinic Checkup List', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            TextField(label: 'Oxygen'),
              CheckboxField(label: 'Gauze'),
              CheckboxField(label: 'Sterile Gauze'),
              CheckboxField(label: 'Bandage'),
              CheckboxField(label: 'Plaster'),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Edit'),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(grey) ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TextField extends StatelessWidget {
  final String label;

  const TextField({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align to the right
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              width: 100.0, // Adjust the width as needed
              child: TextFormField(
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Divider(
            color: darkGrey,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}

class CheckboxField extends StatelessWidget {
  final String label;

  const CheckboxField({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Checkbox(
              value: false,
              onChanged: (bool? value) {

              },
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Divider(
            color: darkGrey,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}
class VehicleCheckup extends StatefulWidget {
  const VehicleCheckup({super.key});

  @override
  State<VehicleCheckup> createState() => _VehicleCheckupState();
}

class _VehicleCheckupState extends State<VehicleCheckup> {
  final List<Widget> _checkuplist = [
    Car1CheckUpForm(),
    Car2CheckUpForm(),
    Car3CheckUpForm(),
    Car4CheckUpForm(),
    Car5CheckUpForm(),
  ];
  int checkupIndex = 0;
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i <= 5; i++)
              Row(
                children: [
                  Column(
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
                                setState(() {
                                  checkupIndex = i-1;
                                  _isPressed = true;
                                });
                              },
                              icon: Icon(
                                Icons.car_crash,
                                color: white,
                              ),
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(blue)),
                          )
                      ),
                      Text('car ${i}')
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.04,
                  ),
                ],
              )
          ],
        ),
        SizedBox(height:MediaQuery.of(context).size.height * 0.04 ,),
        _checkuplist[checkupIndex],
      ],
    );
  }
}
class Car1CheckUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Car 1 Checkup List', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            CheckboxField(label: 'Stretcher'),
            CheckboxField(label: 'Spinal Board'),
            TextField(label: 'Oxygen'),
            TextField(label: 'Handled Oxygen'),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Edit'),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(grey) ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Car2CheckUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Car 2 Checkup List', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            CheckboxField(label: 'Splints'),
            TextField(label: 'Oxygen'),
            TextField(label: 'Handled Oxygen'),
            CheckboxField(label: 'Bag'),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Edit'),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(grey) ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Car3CheckUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Car 3 Checkup List', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            CheckboxField(label: 'CPR Board'),
            CheckboxField(label: 'Chair'),
            TextField(label: 'Oxygen'),
            TextField(label: 'Handled Oxygen'),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Edit'),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(grey) ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Car4CheckUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Car 4 Checkup List', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            CheckboxField(label: 'KED'),
            CheckboxField(label: 'Trauma Bag'),
            TextField(label: 'Oxygen'),
            TextField(label: 'Handled Oxygen'),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Edit'),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(grey) ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class Car5CheckUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Car 5 Checkup List', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            TextField(label: 'Gauze'),
            CheckboxField(label: 'Spinal Board'),
            TextField(label: 'Oxygen'),
            TextField(label: 'Handled Oxygen'),

            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Edit'),
                  style: ButtonStyle(backgroundColor:MaterialStateProperty.all<Color>(grey) ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit logic
                  },
                  child: Text('Submit'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}