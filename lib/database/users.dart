
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Users {
  final String firstName;
  final String lastName;
  final bool isDriver;
  final bool isActive;
  final int role;
  final int rank;
  final String phoneNumber;
  final int duty;
  final int duty2;
  final String year;
  final bool onMission;
  final bool isFrozen;

  final String userRole;
  final String userRank;
  final String dutyDay;
  final String dutyDay2;

  Users({
    required this.firstName,
    required this.lastName,
    required this.isDriver,
    required this.isActive,
    required this.role,
    required this.rank,
    required this.phoneNumber,
    required this.duty,
    required this.duty2,
    required this.year,
    required this.onMission,
    required this.isFrozen
  })   : userRole = _calculateUserRole(role,rank),
        userRank = _calculateUserRank(rank),
        dutyDay = _calculateUserDutyDay(duty),
        dutyDay2 = _calculateUserDutyDay(duty2);

  static Users? _loggedInUser;
  static Users? get loggedInUser => _loggedInUser;

  static Future<void> initializeLoggedInUser() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;

    if (currentUser != null) {
      String loggedInPhoneNumber = currentUser.phoneNumber!.startsWith('+961')
          ? currentUser.phoneNumber!.substring(4)
          : currentUser.phoneNumber!;
      _loggedInUser = allUsersList.firstWhere(
            (user) => user.phoneNumber == loggedInPhoneNumber,
      );
    }
  }

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

  static String _calculateUserRole(int role,rank) {
    if (role == 0) {
      return _calculateUserRank(rank);
    } else if (role == 1) {
      return 'Team Leader';
    } else {
      return 'Admin';
    }
  }

  static String _calculateUserRank(int rank) {
    if (rank == 0) {
      return 'EMR';
    } else if (rank == 1) {
      return 'EMT';
    } else if (rank == 2) {
      return 'Paramedic';
    } else {
      return 'Unknown Rank';
    }
  }
  static String _calculateUserDutyDay(int duty){
    if(duty == 0){
      return '';
    }else if(duty == 1){
      return 'Monday';
    }else if(duty == 2){
      return 'Tuesday';
    }else if(duty ==3){
      return 'Wednesday';
    }else if(duty == 4){
      return 'Thursday';
    }else if(duty == 5){
      return 'Friday';
    }else if(duty == 6){
      return 'Saturday';
    }else if(duty == 7){
      return 'Sunday';
    }else{
      return 'Unknown Day';
    }
  }
  static List<Users> allUsersList = [];
  static List<Users> activeUsersList = [];
  static List<Users> activeDriverUsersList = [];
  static List<Users> activeTeamMemberUsersList = [];
  static List<Users> allDriversList = [];
  static List<Users> allTeamLeadersList = [];
  static List<Users> allOnlyMembers=[];
  static List<Users> onMissionMembers=[];
  static List<Users> availableMembers=[];
  static List<Users> availableAllMembers=[];
  static List<Users> availableTeamLeaders=[];
  static List<Users> availableDrivers=[];

  static Future<void> initUsersLists() async {
    allUsersList = await getUsers();
    activeUsersList = allUsersList.where((user) => user.isActive).toList();
    availableMembers = activeUsersList.where((user) => !user.onMission).toList();
    onMissionMembers = allUsersList.where((user) => user.onMission).toList();
    activeDriverUsersList = activeUsersList.where((user) => user.isDriver).toList();
    activeTeamMemberUsersList = activeUsersList.where((user) => user.role==1 || user.role==2).toList();
    allDriversList = allUsersList.where((user) => user.isDriver).toList();
    allTeamLeadersList = allUsersList.where((user) => user.role==1 || user.role==2).toList();
    allOnlyMembers = allUsersList.where((user) => user.role==0).toList();
    availableAllMembers =  allUsersList.where((user) => !user.onMission).toList();
    availableTeamLeaders =  allTeamLeadersList.where((user) => !user.onMission).toList();
    availableDrivers = allDriversList..where((user) => !user.onMission).toList();
  }
  static Future<void> memberPage() async {
    allUsersList = await getUsers();
    activeUsersList = allUsersList.where((user) => user.isActive).toList();
    availableMembers = activeUsersList.where((user) => !user.onMission).toList();
    onMissionMembers = allUsersList.where((user) => user.onMission).toList();
  }

  static Future<List<Users>> getUsers() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    List<Users> userList = [];

    try {
      QuerySnapshot querySnapshot = await users.get();
      allUsersList.clear();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        Map<String, dynamic> userData = docSnapshot.data() as Map<String, dynamic>;

        Users user = Users(
          firstName: userData['fname'] ?? '',
          lastName: userData['lname'] ?? '',
          isDriver: userData['isDriver'] ?? false,
          isActive: userData['isActive'] ?? false,
          role: userData['role'] ?? 0,
          rank: userData['rank'] ?? 0,
          phoneNumber: docSnapshot.id,
          duty: userData['duty'] ?? 0,
          duty2: userData['duty2'] ?? 0,
          year: userData['since'] ?? '',
          onMission: userData['onMission']?? false,
          isFrozen: userData['isFrozen'] ?? false,
        );

        userList.add(user);
        allUsersList.add(user);
      }
    } catch (e) {
      print(e);
    }

    return userList;
  }

  static Future<void> getActiveUsers() async {
    allUsersList = await getUsers();
    activeUsersList = allUsersList.where((user) => user.isActive).toList();
    availableMembers = activeUsersList.where((user) => !user.onMission).toList();
  }
  static Future<List<Users>> getActiveDriverUsers() async {
    await initUsersLists();
    return activeDriverUsersList;
  }
  static Future<List<Users>> getActiveTeamMemberUsers() async {
    await initUsersLists();
    return activeTeamMemberUsersList;
  }

  static Future<void> updateActiveStatus(String phoneNumber, bool isActive) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    try {
      await users.doc(phoneNumber).update({'isActive': isActive});
      print('User $phoneNumber isActive status updated to $isActive');
    } catch (e) {
      print("Error updating isActive status: $e");
    }
  }
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
        firstName: map['fname'] ?? '',
        lastName: map['lname'] ?? '',
        isDriver: map['isDriver'] ?? false,
        isActive: map['isActive'] ?? false,
        role: map['role'] ?? 0,
        rank: map['rank'] ?? 0,
        phoneNumber: map['phoneNumber'] ?? 0,
        duty: map['duty'] ?? 0,
        duty2: map['duty2'] ?? 0,
        year: map['since'] ?? '',
        onMission: map['onMission']?? false,
        isFrozen: map['isFrozen'] ?? false,
    );
  }

}



