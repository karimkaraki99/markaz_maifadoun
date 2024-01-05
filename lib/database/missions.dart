
import 'package:cloud_firestore/cloud_firestore.dart';

class Mission{
  String id;
  String car;
  String teamLeader;
  String driver;
  String medic1;
  String medic2;
  String missionType;
  String patientName;
  String location;
  String destination;
  String approvalId;
  bool isActive;
  String date;
  String time;
  String leaderPhoneNumber;
  String driverPhoneNumber;
  String medic1PhoneNumber;
  String medic2PhoneNumber;
  Mission({
    required this.id,
    required this.car,
    required this.teamLeader,
    required this.driver,
    required this.medic1,
    required this.medic2,
    required this.missionType,
    required this.patientName,
    required this.location,
    required this.destination,
    required this.approvalId,
    required this.isActive,
    required this.date,
    required this.time,
    required this.leaderPhoneNumber,
    required this.driverPhoneNumber,
    required this.medic1PhoneNumber,
    required this.medic2PhoneNumber

  });
  static List<Mission> allMissionsList = [];
  static List<Mission> activeMissionsList = [];
  static List<Mission> historyMissionsList = [];

  static Future<bool> initMissionsLists() async {
    bool isLoading = true;
    allMissionsList = await getMissions();
    activeMissionsList = allMissionsList.where((mission) => mission.isActive).toList();
    historyMissionsList = allMissionsList.where((mission) => !mission.isActive).toList();
    isLoading = false;
    return isLoading;
  }



  static Future<List<Mission>> getMissions() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference missions = firestore.collection('missions');

    List<Mission> missionList = [];
    try {
      QuerySnapshot querySnapshot = await missions.get();
      allMissionsList.clear();
      missionList.clear();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> missionData = docSnapshot.data() as Map<String, dynamic>;

        Mission mission = Mission(
          id: docSnapshot.id,
          car: missionData['selectedCar'] ?? '',
          teamLeader: missionData['selectedTeamLeader'] ?? '',
          driver: missionData['selectedDriver'] ?? '',
          medic1: missionData['selectedMedic1'] ?? '',
          medic2: missionData['selectedMedic2'] ?? '',
          missionType: missionData['type'] ?? '',
          patientName: missionData['patientName'] ?? '',
          location: missionData['location'] ?? '',
          destination: missionData['destination'] ?? '',
          approvalId: missionData['approvalId'] ?? '',
          isActive: missionData['isActive']?? false,
          date: missionData['date']??'',
          time:  missionData['time']??'',
          leaderPhoneNumber:  missionData['leaderPhone']??'',
          driverPhoneNumber:  missionData['driverPhoneNumber']??'',
          medic2PhoneNumber:  missionData['medic2PhoneNumber']??'',
          medic1PhoneNumber:  missionData['medic1PhoneNumber']??'',
        );
        missionList.add(mission);
        allMissionsList.add(mission);
      }
    } catch (e) {
      print("Error fetching missions: $e");
    }

    return missionList;
  }


}