import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/teamLeader/start_mission.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';
import '../database/vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckUp extends StatefulWidget {
  const CheckUp({Key? key}) : super(key: key);

  @override
  State<CheckUp> createState() => _CheckUpState();
}

class _CheckUpState extends State<CheckUp> {
  bool clinic = false;
  Car? selectedCar;
  TextEditingController vehicleCheckupController = TextEditingController();
  TextEditingController clinicCheckupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          ListTile(
            title: Container(
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const SizedBox(width: 5,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          clinic = false;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(!clinic ? grey : darkBlue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                        ),
                      ),
                      child: Text("Vehicle Checkup", style: TextStyle(color: white)),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          clinic = true;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(clinic ? grey : darkBlue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                      child: Text("Clinic Checkup", style: TextStyle(color: white)),
                    ),
                  ),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          !clinic?CarDropDown(
            color: yellow,
            onCarSelected: (car) {
              setState(() {
                selectedCar = car;
              });
            },
          ):Container(),
          !clinic? Form(
            child: Column(
              children: [
                ListTile(
                  title: Text('Stretcher'),
                ),
                ListTile(
                  title: Text('Stretcher'),
                  ),
              ],
            ),
          )
              :Form(
              child: Column(
                children: [

                ],
              ))
          ,
        ],
      ),
    );
  }

}


