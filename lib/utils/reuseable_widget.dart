import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markaz_maifadoun/database/missions.dart';
import '../mainscreens/library.dart';
import 'colors_util.dart';


TextField reusableTextField(String text, IconData icon, bool isTextType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isTextType,
    enableSuggestions: !isTextType,
    autocorrect: !isTextType,
    cursorColor: white,
    style: TextStyle(color: white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: yellow,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isTextType
        ? TextInputType.text
        : TextInputType.phone,
  );
}
class SubmitButton extends StatelessWidget {
  final String text;
  final Function() onpress;
  const SubmitButton({
    super.key,
    required this.text,
    required this.onpress,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onpress,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: darkBlue,
        backgroundColor: white,
        elevation: 10,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18, color: Colors.black
        ),
      ),
    );
  }
}
class OtpInput extends StatefulWidget {
  final void Function(String) onEnteredOTP;
  const OtpInput({Key? key, required this.onEnteredOTP});

  @override
  _OtpInputState createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: List.generate(6, (index) {
          return Expanded(
            flex: 1, // Adjust the flex factor
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: TextFormField(
                controller: controllers[index],
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                onChanged: (value) {
                  if (value.length == 1) {
                    // Move focus to the next TextFormField
                    if (index < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                    // Store the entered value
                    controllers[index].text = value;

                    if (controllers.length == 6){
                      widget.onEnteredOTP(controllers.map((controller) => controller.text).join());
                    }

                  }
                },
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class TextBox extends StatelessWidget {
  TextBox({Key? key, this.width = 200.0, this.height = 50.0, required this.title1,required this.value1, required this.title2, required this.value2,required this.title3,required this.value3}) : super(key: key);

  final double width;
  final double height;
  final int value1,value2,value3;
  final String title1,title2,title3;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: darkBlue),
        borderRadius: BorderRadius.circular(8.0),
        color: darkBlue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Expanded(
            child: Text(
              '${title1}: ${value1}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.0, color: white),
            ),
          ),
          Expanded(
            child: Text(
              '${title2}: ${value2}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.0, color: white),
            ),
          ),
          Expanded(
            child: Text(
              '${title3}: ${value3}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.0, color: white),
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imagePath;
  final String text;
  final String pdfName;

  CardWidget({
    required this.imagePath,
    required this.text,
    required this.pdfName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewer(pdfAsset: pdfName),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5.0,
        child: Stack(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                imagePath,
                width: 150,
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
            // Gradient background behind the text
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40.0, // Adjust the height as needed
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Text at the bottom left
            Positioned(
              bottom: 8.0,
              left: 8.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  text,
                  style: TextStyle(
                    color: white,
                    fontSize: 12.0, // Adjust the font size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageButton extends StatefulWidget {
  String image = '';
  double size;// Added '_height' here

  ImageButton({Key? key, required this.image, required this.size,}) : super(key: key);
  @override
  State<ImageButton> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<ImageButton> {

  @override
  Widget build(BuildContext context) {
    double _imageSize = widget.size *0.8;
    return
      Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: blue,
          ),
          child: IconButton(
      onPressed: () {
        // Add functionality here
      },
      icon: Image.asset(
        widget.image,
        width: _imageSize,
        height: _imageSize,
      ),
    )
    );
  }
}
class ValueBox extends StatefulWidget {
  String title;
  String value;
   ValueBox({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  State<ValueBox> createState() => _ValueBoxState();
}

class _ValueBoxState extends State<ValueBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: 5.0),
          Text(
            widget.title,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: yellow
            ),
          ),
          SizedBox(width: 12.0),
          Container(
            width: 1.0,
            height: 20.0,
            color: white,
          ),
          SizedBox(width: 12.0),
          Text(
            widget.value,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 17.0,
              color: white
            ),
          ),
        ],
      ),
    );
  }
}
class CustomButton extends StatelessWidget {
  String text;
  VoidCallback toDo;
  Color color;
  CustomButton({super.key, required this.text,required this.color ,required this.toDo});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(color),
            shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                )
            ),
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 32.0),
            )
        ),
        onPressed: toDo,
        child: Text(text,style: TextStyle(fontSize: 18,color: white),)
    );
  }
}
class CustomIconButton extends StatefulWidget {
  String name;
  String icon;
  bool primaryBool;
  bool secondaryBool;
  VoidCallback toDo;
   CustomIconButton({super.key,required this.name,required this.icon,required this.primaryBool,required this.secondaryBool,required this.toDo});

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: widget.toDo,
            icon: Image.asset(widget.icon,color: widget.secondaryBool?yellow:white,),
          color: widget.primaryBool?blue:red,
        ),
      ],
    );
  }
}
class MissionTypeDropdown extends StatefulWidget {
  const MissionTypeDropdown({
    Key? key,
    this.initialValue,
    required this.onChanged,
  }) : super(key: key);

  final String? initialValue;
  final Function(String) onChanged;

  @override
  State<MissionTypeDropdown> createState() => _MissionTypeDropdownState();
}

class _MissionTypeDropdownState extends State<MissionTypeDropdown> {
   List<String> missionTypes =[];

  String? selectedMissionType;

  @override
  void initState() {
    super.initState();
    selectedMissionType = widget.initialValue;
    missionTypes = Mission.missionTypes;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedMissionType,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.black),
      underline: Container(
        height: 2,
        color: Colors.grey,
      ),
      hint: Text('Mission Type'),
      onChanged: (String? newValue) {
        setState(() {
          selectedMissionType = newValue;
          widget.onChanged(selectedMissionType ?? '');
        });
      },
      items: missionTypes.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
class DateSelectionWidget extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const DateSelectionWidget({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<DateSelectionWidget> createState() => _DateSelectionWidgetState();
}

class _DateSelectionWidgetState extends State<DateSelectionWidget> {
  late DateTime selectedDate;

  @override


  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate:

          DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (pickedDate != null) {
          setState(() {
            selectedDate = pickedDate;
            widget.onDateSelected(selectedDate);
          });
        }
      },
      icon: Icon(Icons.calendar_month),
    );
  }
}




