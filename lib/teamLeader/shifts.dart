import 'package:flutter/material.dart';
import '../utils/colors_util.dart';
import '../database/users.dart';

class Shifts extends StatefulWidget {
  @override
  _ShiftsState createState() => _ShiftsState();
}

class _ShiftsState extends State<Shifts> {
  String selectedDutyDay = 'Monday';
  String? userDutyDay;
  String? userDutyDay2;
  int? userDuty;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    try {
      await Users.initUsersLists();
      await Users.initializeLoggedInUser();
      setState(() {
        userDutyDay = Users.loggedInUser?.dutyDay;
        userDutyDay2 = Users.loggedInUser?.dutyDay2;
        userDuty = Users.loggedInUser?.duty;
        selectedDutyDay = userDutyDay ?? '';
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
        title: Text('Shifts $userDutyDay $userDuty $userDutyDay2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: selectedDutyDay,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedDutyDay = newValue;
                  });
                }
              },
              items: dropdownItems.map((String day) {
                return DropdownMenuItem<String>(
                  value: day,
                  child: Text(day),
                );
              }).toList(),
            ),

            SizedBox(height: 20),
            // List of users with the selected duty day
            Expanded(
              child: buildUserList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserList() {
    List<Users> usersWithSelectedDutyDay = Users.allUsersList
        .where((user) => user.dutyDay == selectedDutyDay)
        .toList();

    return usersWithSelectedDutyDay.isNotEmpty
        ? ListView.builder(
      itemCount: usersWithSelectedDutyDay.length,
      itemBuilder: (context, index) {
        Users user = usersWithSelectedDutyDay[index];
        return ListTile(
          title: Text(user.firstName),
          subtitle: Text(user.dutyDay),
          // You can customize the list tile based on your needs
        );
      },
    )
        : Center(
      child: Text('No users found for the selected duty day.'),
    );
  }
}
