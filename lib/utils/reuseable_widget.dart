import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int value1,value2,value3;
  String title1,title2,title3;

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
              style: TextStyle(fontSize: 15.0, color: white),
            ),
          ),
          Expanded(
            child: Text(
              '${title2}: ${value2}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, color: white),
            ),
          ),
          Expanded(
            child: Text(
              '${title3}: ${value3}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, color: white),
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
  String pdfName;

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




