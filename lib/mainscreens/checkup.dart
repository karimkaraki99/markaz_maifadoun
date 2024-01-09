import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:markaz_maifadoun/teamLeader/start_mission.dart';
import 'package:markaz_maifadoun/utils/reuseable_widget.dart';

import '../database/users.dart';
import '../database/vehicle.dart';
import '../utils/colors_util.dart';

class CheckupPage extends StatefulWidget {
  @override
  _CheckupPageState createState() => _CheckupPageState();
}

class _CheckupPageState extends State<CheckupPage> {
  List<String> checkupItems = [
    'Stretcher',
    'Spinal Board',
    'CPR Board',
    'KED',
    'Oxygen',
    'Gauze',
    'Bandages',
    'Suction',
    'Airways',
    'Gloves',
    'Face Mask',
  ];
  List<String> clinicCheckup = [
    'Oxygen Solution',
    'Iodine Solution',
    'Gauze',
    'Paraffin Gauze',
    'Sterile Gauze',
    'Ecopore',
    'Dressing Roll',
  ];
  bool clinic = false;
  bool buttonLoading = false;
  List<String> selectedItems = [];
  List<String> unselectedItems = [];
  late CollectionReference checkupCollection;
  Car?  selectedCar;
  Users? selectedUser;
  bool isDriver = false;

  @override
  void initState() {
    super.initState();
    checkupCollection = FirebaseFirestore.instance.collection('checkup');
    selectedItemsList();
    initializeData();
  }

  selectedItemsList(){
    if(clinic){
      selectedItems.clear();
      selectedItems = List.from(clinicCheckup);
    }
    else{
      selectedItems.clear();
      selectedItems = List.from(checkupItems);
    }
  }

  Future<void> initializeData() async {
    try {
      await Users.initUsersLists();
      await Users.initializeLoggedInUser();
      setState(() {
        selectedUser = Users.loggedInUser;
        isDriver = Users.loggedInUser!.isDriver;

      });
    } catch (e) {
      print("Error initializing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkup Page'),
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
                  const SizedBox(width: 5,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          clinic = false;
                          selectedItemsList();
                        });
                      },
                      child: Text("Vehicle Checkup ",style: TextStyle(color: white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(!clinic?grey:darkBlue),
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
                          clinic = true;
                          selectedItemsList();
                        });
                      },
                      child: Text("Clinic Checkup",style: TextStyle(color: white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(clinic?grey:darkBlue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),

                  ),
                  const SizedBox(width: 5,),
                ],
              ),
            ),
          ),
          !clinic?CarDropDown(
              onCarSelected: (car){
                setState(() {
                  selectedCar = car;
                });
              },
              color: yellow
          ):Container(),
          !clinic?Expanded(
            child: ListView.builder(
              itemCount: checkupItems.length,
              itemBuilder: (context, index) {
                var item = checkupItems[index];
                return ListTile(
                  title: Text(item),
                  trailing: Checkbox(
                    value: selectedItems.contains(item),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            selectedItems.add(item);
                            unselectedItems.remove(item);
                          } else {
                            selectedItems.remove(item);
                            unselectedItems.add(item);
                          }
                        }
                      });
                    },
                  ),
                );
              },
            ),
          )
          :Expanded(
            child: ListView.builder(
              itemCount: clinicCheckup.length,
              itemBuilder: (context, index) {
                var item = clinicCheckup[index];
                return ListTile(
                  title: Text(item),
                  trailing: Checkbox(
                    value: selectedItems.contains(item),
                    onChanged: (value) {
                      setState(() {
                        if (value != null) {
                          if (value) {
                            selectedItems.add(item);
                            unselectedItems.remove(item);
                          } else {
                            selectedItems.remove(item);
                            unselectedItems.add(item);
                          }
                        }
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: !clinic?buttonLoading?CircularProgressIndicator():CustomButton(
                text: 'Save Vehicle Checkup',
                color: blue,
                toDo: ()async{
                  setState(() {
                    buttonLoading=true;
                  });
                  await saveCheckupList();
                  setState(() {
                    buttonLoading=false;
                  });
                }
            ):buttonLoading?CircularProgressIndicator():CustomButton(
                text: 'Save Clinic Checkup',
                color: blue,
                toDo: ()async{
                  setState(() {
                    buttonLoading=true;
                  });
                  await saveClinicCheckupList();
                  setState(() {
                    buttonLoading=false;
                  });
                }
            )
          ),
        ],
      ),
    );
  }

  Future<void> saveCheckupList() async {
    try {
      if (selectedCar == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a car.'),
          ),
        );
        return;
      }

      DateTime now = DateTime.now();
      String formattedDate = '${now.year}${now.month}${now.day}_${selectedCar?.name}';
      String userName = '${selectedUser?.firstName} ${selectedUser?.lastName}';

      // Check if the document already exists
      DocumentReference docRef = checkupCollection.doc(formattedDate);
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.set({
          'selectedCar': selectedCar?.name,
          'availableItems': selectedItems,
          'unavailableItems': unselectedItems,
          'date': now,
          'submittedBy':userName
        }, SetOptions(merge: true));

        showSuccessDialogMessage('List Submitted successfully');
      } else {
        await docRef.set({
          'selectedCar': selectedCar?.name,
          'availableItems': selectedItems,
          'unavailableItems': unselectedItems,
          'date': now,
          'submittedBy':userName
        });
        showSuccessDialogMessage('List Updated successfully');
      }
    } catch (e) {
      print('Error saving checkup list: $e');
    }
  }
  Future<void> saveClinicCheckupList() async {
    try {

      DateTime now = DateTime.now();
      String formattedDate = '${now.year}${now.month}${now.day}_clinic';
      String userName = '${selectedUser?.firstName} ${selectedUser?.lastName}';

      // Check if the document already exists
      DocumentReference docRef = checkupCollection.doc(formattedDate);
      var docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.set({
          'availableItems': selectedItems,
          'unavailableItems': unselectedItems,
          'date': now,
          'submittedBy':userName
        }, SetOptions(merge: true));
        showSuccessDialogMessage('List Submitted successfully');
      } else {
        await docRef.set({
          'availableItems': selectedItems,
          'unavailableItems': unselectedItems,
          'date': now,
          'submittedBy':userName
        });
        showSuccessDialogMessage('List Updated successfully');
      }
    } catch (e) {
      print('Error saving checkup list: $e');
    }
  }
  void showSuccessDialogMessage( String message){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: green,
          title: Icon(Icons.check_circle ,size: 80, color: white,),
          content: Text(message,style: TextStyle(color: white),textAlign: TextAlign.center,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();// Close the dialog
              },
              child: Text('OK',style: TextStyle(color: white),),
            ),
          ],
        );
      },
    );
  }


}
