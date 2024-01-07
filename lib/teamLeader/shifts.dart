import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../database/users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../utils/colors_util.dart';

class Shifts extends StatefulWidget {
  const Shifts({super.key});

  @override
  _ShiftsState createState() => _ShiftsState();
}

class _ShiftsState extends State<Shifts> {
  String? selectedDutyDay;
  String? userDutyDay;
  String? userDutyDay2;
  int? userDuty;
  bool isLoading = true;
  Map<String, bool> presenceStatus = {};
  bool documentExists = true;
  late String today;
  bool isUserDutyDay = false;

  @override
  void initState(){
    initializeData();
    super.initState();
  }
  String getDayName() {
    DateTime now = DateTime.now();
    String dayName = DateFormat('EEEE').format(now);
    return dayName;
  }

  bool isTodayUserDutyDay(String userDutyDay,String userDutyDay2){
    if(today == userDutyDay){
      setState(() {
        selectedDutyDay = userDutyDay;
      });
      return true;
    } else if(today == userDutyDay2){
      setState(() {
        selectedDutyDay = userDutyDay2;
      });
    }
    return false;
  }

  Future<bool> doesDocumentExist(String collectionName) async {
    try {
      final currentDate = DateTime.now().toLocal().toString().split(' ')[0];

      final collectionReference = FirebaseFirestore.instance.collection(collectionName);

      final documentSnapshot = await collectionReference.doc(currentDate).get();

      return documentSnapshot.exists;
    } catch (e) {
      print('Error checking document existence: $e');
      return false;
    }
  }


  Future<void> initializeData() async {
    try {
      await Users.initUsersLists();
      await Users.initializeLoggedInUser();
      documentExists = await doesDocumentExist('shifts');
      setState(()  {
        userDutyDay = Users.loggedInUser?.dutyDay;
        userDutyDay2 = Users.loggedInUser?.dutyDay2;
        userDuty = Users.loggedInUser?.duty;
        today = getDayName();
        isUserDutyDay = isTodayUserDutyDay(userDutyDay!,userDutyDay2!);
        isLoading = false;
        presenceStatus = Map.fromIterable(
          Users.allUsersList,
          key: (user) => user.phoneNumber,
          value: (user) => true,
        );
      });
    } catch (e) {
      print("Error initializing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> dropdownItems = [];
    if (userDutyDay != null && userDutyDay!.isNotEmpty) {
      dropdownItems.add(userDutyDay!);
    }
    if (userDutyDay2 != null && userDutyDay2!.isNotEmpty) {
      dropdownItems.add(userDutyDay2!);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Shifts'),
        centerTitle: true,
      ),
      body: isLoading
          ? const SpinKitFadingCircle(
        color: Colors.blue,
        size: 50.0,
      )
          :isUserDutyDay? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(selectedDutyDay!),

              const SizedBox(height: 20),
              buildUserList(),

              // Button to save shifts
              documentExists?ElevatedButton(
                onPressed: () async {
                  await editShifts(context);
                },
                child: Text('Edit Shift'),
              ): ElevatedButton(
                onPressed: () async {
                  await saveShifts(context);
                },
                child: Text('Save Shift'),
              )

            ],
          ),
        ),
      ):Center(
        child: Container(
          height: 150,
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
            color: blue,
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: white,
                    size: 32,
                  ),
                  Text(
                    'It is not your Duty Day',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget buildUserList() {
    List<Users> usersWithSelectedDutyDay = Users.allUsersList
        .where((user) => user.dutyDay == selectedDutyDay)
        .toList();

    return usersWithSelectedDutyDay.isNotEmpty
        ? ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: usersWithSelectedDutyDay.length,
      itemBuilder: (context, index) {
        Users user = usersWithSelectedDutyDay[index];
        return Card(
          color: Colors.blue.shade100,
          elevation: 3.0,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Role: ${user.userRole}'),
                Text('Rank: ${user.userRank}'),
              ],
            ),
            trailing: Switch(
              value: presenceStatus[user.phoneNumber] ?? false,
              onChanged: (value) {
                // Update the presence status for this user
                setState(() {
                  presenceStatus[user.phoneNumber] = value;
                });
              },
            ),
          ),
        );
      },
    )
        : Center(
      child: Text('No users found for the selected duty day.'),
    );
  }

  Future<void> saveShifts(BuildContext buildContext) async {
    // Filter users based on the selected duty day
    List<Users> filteredUsers = Users.allUsersList
        .where((user) => user.dutyDay == selectedDutyDay)
        .toList();

    // Create a document with the date as the document ID
    final shiftsCollection = FirebaseFirestore.instance.collection('shifts');
    final documentId = DateTime.now().toLocal().toString().split(' ')[0];
    final shiftsDocument = shiftsCollection.doc(documentId);

    Map<String, bool> shiftsData = {};

    filteredUsers.forEach((user) {
      shiftsData[user.phoneNumber] = presenceStatus[user.phoneNumber] ?? false;
    });

    await shiftsDocument.set(shiftsData);

    // Show a dialog instead of a SnackBar
    showDialog(
      context: buildContext,
      builder: (context) {
        return AlertDialog(
          title: Text('Shifts Saved', style: TextStyle(color: white)),
          content: Text('Shifts saved successfully.', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Colors.black)),
            ),
          ],
          backgroundColor: green,
        );
      },
    );

  }
  Future<void> editShifts(BuildContext buildContext) async {
    try {
      // Get the current date
      final currentDate = DateTime.now().toLocal().toString().split(' ')[0];

      // Reference to the Firestore collection
      final shiftsCollection = FirebaseFirestore.instance.collection('shifts');
      final shiftsDocument = shiftsCollection.doc(currentDate);

      // Check if the document exists
      final documentSnapshot = await shiftsDocument.get();
      if (documentSnapshot.exists) {
        // Document exists, update the shifts data

        // Filter users based on the selected duty day
        List<Users> filteredUsers = Users.allUsersList
            .where((user) => user.dutyDay == selectedDutyDay)
            .toList();

        Map<String, bool> shiftsData = {};

        filteredUsers.forEach((user) {
          shiftsData[user.phoneNumber] = presenceStatus[user.phoneNumber] ?? false;
        });

        await shiftsDocument.update(shiftsData);

        // Show a dialog
        showDialog(
          context: buildContext,
          builder: (context) {
            return AlertDialog(
              title: Text('Shifts Updated', style: TextStyle(color: white)),
              content: Text('Shifts updated successfully.', style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.black)),
                ),
              ],
              backgroundColor: green,
            );
          },
        );
      } else {
        // Document does not exist, show an error message
        showDialog(
          context: buildContext,
          builder: (context) {
            return AlertDialog(
              title: Text('Error', style: TextStyle(color: white)),
              content: Text('Shifts document not found for today.', style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK', style: TextStyle(color: Colors.black)),
                ),
              ],
              backgroundColor: red,
            );
          },
        );
      }
    } catch (e) {
      print('Error editing shifts: $e');
    }
  }



}
