import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/teamLeader/start_mission.dart';

import '../database/vehicle.dart';
import '../utils/colors_util.dart';
import '../utils/reuseable_widget.dart';
class Missions extends StatefulWidget {
  const Missions({super.key});

  @override
  State<Missions> createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  bool active = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.07,
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                  Expanded(child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        active = true;
                      });
                    },
                    child: Expanded(child: Text("Active Missions", style: TextStyle(color: white,fontSize: 12)),),
                    style: ButtonStyle(
                        backgroundColor: !active?MaterialStateProperty.all<Color>(darkBlue):MaterialStateProperty.all<Color>(grey),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            )
                        )
                    ),
                  ),),
                  Expanded(child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        active = false;
                      });
                    },
                    child: Expanded(child: Text("History", style: TextStyle(color: white)),),
                    style: ButtonStyle(
                        backgroundColor: active?MaterialStateProperty.all<Color>(darkBlue):MaterialStateProperty.all<Color>(grey),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            )
                        )
                    ),
                  ),),
                  SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                ],
              ),
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width*0.02,),
          active?ActiveMissions():HistoryMissions(),
        ],
      ),
    );
  }
} class ActiveMissions extends StatefulWidget {
  const ActiveMissions({super.key});

  @override
  State<ActiveMissions> createState() => _ActiveMissionsState();
}

class _ActiveMissionsState extends State<ActiveMissions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Positioned(
          bottom: 13,
            right: 5,
            child: IconButton(
              onPressed: (){
                Navigator.push(
                    context, 
                  MaterialPageRoute(builder: (context)=>StartMission())
                );
              },
              icon: Icon(Icons.add),
            )
        )
      ],
    );
  }


}


class HistoryMissions extends StatefulWidget {
  const HistoryMissions({super.key});

  @override
  State<HistoryMissions> createState() => _HistoryMissionsState();
}

class _HistoryMissionsState extends State<HistoryMissions> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


