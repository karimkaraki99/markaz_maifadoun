import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/teamLeader/start_mission.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';

import '../database/missions.dart';

class MissionListPage extends StatefulWidget {
  @override
  State<MissionListPage> createState() => _MissionListPageState();
}

class _MissionListPageState extends State<MissionListPage> {
  bool active = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mission List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            MissionList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StartMission()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: blue,
      ),
    );
  }
}

class MissionList extends StatefulWidget {
  @override
  State<MissionList> createState() => _MissionListState();
}

class _MissionListState extends State<MissionList> {
  List<Mission> _missions = [];

  @override
  void initState() {
    super.initState();
    loadMissions();
  }

  Future<void> loadMissions() async {
    // Assuming Mission.getMissions() fetches the mission data
    _missions = await Mission.getMissions();
    setState(() {}); // Refresh the UI after loading missions
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _missions.length,
      itemBuilder: (context, index) {
        Mission mission = _missions[index];
        return ListTile(
          title: Text(mission.missionType),
          subtitle: Text(mission.patientName),
          onTap: () {
            // Handle tapping on a mission, if needed
          },
        );
      },
    );
  }
}
