import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/teamLeader/edit_mission.dart';
import 'package:markaz_maifadoun/teamLeader/start_mission.dart';
import '../database/missions.dart';
import '../utils/colors_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../utils/reuseable_widget.dart';

class Missions extends StatefulWidget {
  const Missions({super.key});


  @override
  State<Missions> createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  bool active = true;
  DateTime selectedDateTime = DateTime.now();
  String? dateString ;
  List<Mission> _historyMissions = [];

  Future<void> loadMissionsByDate( ) async {
    try {
      await Mission.initMissionsLists();
      setState(() {
        _historyMissions = Mission.historyMissionsList.where((mission) => mission.date == dateString).toList();
      });
    } catch (e) {
      print("Error loading missions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Missions'),
        centerTitle: true,
        actions: [
          !active?DateSelectionWidget(
            initialDate: selectedDateTime,
            onDateSelected: (DateTime pickedDate)  {
              setState(() {
                selectedDateTime = pickedDate;
                dateString = DateFormat('yyyy-MM-dd').format(pickedDate);
                loadMissionsByDate( );
              });
            },

          ):Container()
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Container(
              decoration: BoxDecoration(
                color: darkBlue,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          active = true;
                        });
                      },
                      child: Text("Active Missions",style: TextStyle(color: white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(active?grey:darkBlue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          active = false;
                        });
                      },
                      child: Text("History",style: TextStyle(color: white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(!active?grey:darkBlue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height*0.02,),
          active?Container(
            height: MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width*0.9,
            child: missionListRow(),
          ):Container(
            height: MediaQuery.of(context).size.height*0.7,
            width: MediaQuery.of(context).size.width*0.9,
            child: ListView.builder(
              itemCount: _historyMissions.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                if (_historyMissions.isEmpty) {
                  return SizedBox.shrink();
                }

                Mission mission = _historyMissions[index];
                return Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context)=>  EditMissionPage(mission: mission,)  )
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: (index % 2 != 0) ? Radius.circular(5.0) : Radius.circular(15.0),
                              topRight: (index % 2 != 0) ? Radius.circular(15.0) : Radius.circular(5.0),
                              bottomLeft: (index % 2 != 0) ? Radius.circular(15.0) : Radius.circular(5.0),
                              bottomRight: (index % 2 != 0) ? Radius.circular(5.0) : Radius.circular(15.0),
                            ),
                            color: index%2!=0?Colors.grey.shade200:Colors.grey.shade400
                        ),
                        child: ListTile(
                          leading: Text(mission.car,style: TextStyle(
                              color: darkBlue, fontWeight: FontWeight.bold,fontSize: 18),),
                          title: Text(
                            mission.patientName,
                            style: TextStyle(
                                color: darkBlue, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            mission.missionType,
                            style: TextStyle(
                                color: darkGrey, fontWeight: FontWeight.w300),
                          ),
                          trailing: Text(
                            mission.time,
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                  ],
                );
              },
            )
          ),
        ],
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
class missionListRow extends StatefulWidget {
  const missionListRow({Key? key}) : super(key: key);

  @override
  State<missionListRow> createState() => _missionListRow();
}

class _missionListRow extends State<missionListRow> {
  List<Mission> _activeMissions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadActiveMissions();
  }

  Future<void> loadActiveMissions() async {
    try {
      await Mission.initMissionsLists();
      setState(() {
        _activeMissions = Mission.activeMissionsList;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading missions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SpinKitFadingCircle(
      color: Colors.blue,
      size: 50.0,
    )
        : ListView.builder(
      itemCount: _activeMissions.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        if (_activeMissions.isEmpty) {
          return SizedBox.shrink();
        }

        Mission mission = _activeMissions[index];
        return Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>  EditMissionPage(mission: mission,)  )
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: (index % 2 != 0) ? Radius.circular(5.0) : Radius.circular(15.0),
                      topRight: (index % 2 != 0) ? Radius.circular(15.0) : Radius.circular(5.0),
                      bottomLeft: (index % 2 != 0) ? Radius.circular(15.0) : Radius.circular(5.0),
                      bottomRight: (index % 2 != 0) ? Radius.circular(5.0) : Radius.circular(15.0),
                    ),
                    color: index%2!=0?Colors.blue.shade200:Colors.blue.shade400
                ),
                child: ListTile(
                  leading: Text(mission.car,style: TextStyle(
                      color: darkBlue, fontWeight: FontWeight.bold,fontSize: 18),),
                  title: Text(
                    mission.patientName,
                    style: TextStyle(
                        color: darkBlue, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    mission.missionType,
                    style: TextStyle(
                        color: darkGrey, fontWeight: FontWeight.w300),
                  ),
                  trailing: Text(
                    mission.time,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.02,),
          ],
        );
      },
    );
  }
}






