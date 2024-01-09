import 'package:flutter/material.dart';
import '../database/vehicle.dart'; // Import your vehicle class
import '../utils/colors_util.dart';
import 'add_cars.dart';
import 'edit_cars.dart';

class ShowVehicles extends StatefulWidget {
  const ShowVehicles({Key? key}) : super(key: key);

  @override
  State<ShowVehicles> createState() => _ShowVehiclesState();
}

class _ShowVehiclesState extends State<ShowVehicles> {
  List<Car> _originalVehicleList = [];
  List<Car> _filteredVehicleList = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getVehiclesData();
  }

  Future<void> getVehiclesData() async {
    List<Car> vehicles = await Car.getCars();
    setState(() {
      _originalVehicleList = vehicles;
      _filteredVehicleList = vehicles;
      isLoading = false;
    });
  }

  List<Car> getFilteredVehicles(String query) {
    if (query.isEmpty) {
      return _originalVehicleList;
    }

    return _originalVehicleList.where((vehicle) {
      return vehicle.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),
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
                        _filteredVehicleList = getFilteredVehicles(query);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search by Vehicle Name',
                      labelStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
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
                itemCount: _filteredVehicleList.length,
                itemBuilder: (context, index) {
                  Car vehicle = _filteredVehicleList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditCarPage(car: vehicle)),
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
                          color: vehicle.isActive ?  Colors.blue.shade300 : Colors.red.shade300,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
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
                              vehicle.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: darkBlue,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'On Mission: ${vehicle.onMission ? 'Yes' : 'No'}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade800,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              vehicle.type==0?'Type: Ambulance ':'Type: Pickup ',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCarPage()),
          );
        },
        child: Icon(Icons.add,color: white,),
        backgroundColor: blue,
        elevation: 3,
      ),
    );
  }
}
