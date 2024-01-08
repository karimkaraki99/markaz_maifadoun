import 'package:flutter/material.dart';
import '../database/users.dart';
import '../utils/colors_util.dart';
import 'edit_members.dart';

class ShowUsers extends StatefulWidget {
  const ShowUsers({Key? key}) : super(key: key);

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  List<Users> _originalUserList = [];
  List<Users> _filteredUserList = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUsersData();
  }

  Future<void> getUsersData() async {
    List<Users> users = await Users.getUsers();
    setState(() {
      _originalUserList = users;
      _filteredUserList = users;
      isLoading = false;
    });
  }

  List<Users> getFilteredUsers(String query) {
    if (query.isEmpty) {
      return _originalUserList;
    }

    return _originalUserList.where((user) {
      final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
      return fullName.contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Members'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      setState(() {
                        _filteredUserList = getFilteredUsers(query);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search by Name',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500, // Slightly bolder label
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white), // Ensure text color is white
                  ),
                ),
              ),


              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: _filteredUserList.length,
                itemBuilder: (context, index) {
                  Users user = _filteredUserList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditUserPage(user: user)),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(9.0),
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: user.isFrozen ? Colors.red.shade200 : Colors.blue.shade300,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: user.isFrozen ? Colors.red.shade200 : Colors.grey.shade300,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user.firstName + ' ' + user.lastName,
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: darkBlue
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Role: ${user.userRole}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Rank: ${user.userRank}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
