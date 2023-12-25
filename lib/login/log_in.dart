import 'package:flutter/material.dart';
import 'package:markaz_maifadoun/mainscreens/home.dart';
import 'package:markaz_maifadoun/utils/colors_util.dart';
import '../utils/image_utils.dart';
import '../utils/reuseable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLogin = true;
  String ? enteredOTP;
  String ? verificationIdReceived;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: RadialGradient(
                    colors:[
                      Color(0xff0A58b8),
                      Color(0xffF5F5F5)
                    ],
              center: Alignment.center,
              radius: 2.5,
            ),),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                 LogoWidget('assets/app-logo.png', 200, 200),
                  isLogin?Text(
                    "Log in",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: yellow,
                    ),
                  ):Text(
                    "OTP Verification",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: yellow,
                    ),
                  ),
                   const SizedBox(height: 20),
                   isLogin? Text(
                    "Enter your mobile number",
                    style: TextStyle(
                      color: white,
                      fontSize: 15,
                    ),
                  ):Text.rich(
                     textAlign: TextAlign.center,
                     TextSpan(
                       children: [
                         TextSpan(
                           text: "Enter the OTP sent to ",
                           style: TextStyle(
                             color: white,
                           ),
                         ),
                         TextSpan(
                           text:_phoneController.text,
                           style: TextStyle(
                             color: white,
                             fontSize: 16,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 20,),
                   isLogin? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                    child: TextFormField(
                      controller: _phoneController,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        color: yellow,
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        hintText: " 70 111 111",
                        hintStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey
                        ),
                        prefixIcon: Icon(Icons.phone,color: white,),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.yellow),
                        ),
                         // Optional label
                      ),
                    ),
                  ):  OtpInput(
                     onEnteredOTP: (otp) {
                         enteredOTP = otp;
                         },
                   ),
                  !isLogin?Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '''Don't receive the OTP?''',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 5),
                      TextButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: yellow,
                        ),
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ):const SizedBox(height: 0),
                  
                  const SizedBox(height: 40),

                  isLoading?CircularProgressIndicator(
                    color: Colors.white,
                  ):SubmitButton(
                    onpress: () async {

                      setState(() {
                        isLoading = true;
                      });


                      if (enteredOTP!=null && verificationIdReceived != null && !isLogin){

                        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationIdReceived!, smsCode: enteredOTP!);
                        await auth.signInWithCredential(credential).then((value){
                          setState(() {
                            isLoading = false;
                          });

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context)=> HomePage())
                          );

                        });
                      }

                      await auth.verifyPhoneNumber(
                        phoneNumber: '+961${_phoneController.text}',
                        codeSent: (String verificationId, int? resendToken) async {
                          setState(() {
                            isLoading = false;
                          });
                          verificationIdReceived = verificationId;

                          if (!mounted){
                            setState(() {
                              isLogin = false;
                            });
                          }
                        },
                        verificationFailed: (FirebaseAuthException error) {},
                        codeAutoRetrievalTimeout: (String verificationId) {  },
                        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {  },
                      );
                    },
                    text: isLogin?"Verify":"Login"
                  ),



                  const SizedBox(height: 40),
                  !isLogin?TextButton(onPressed: (){setState(() {
                    isLogin = true;
                  });},
                      style: ElevatedButton.styleFrom(
                      ),
                      child: Text("Return to log in Screen",style: TextStyle(
                        color: yellow
                      ),)):const Text(""),

                  TextButton(onPressed: (){
                    Navigator.pushReplacement(
                      context,
                    MaterialPageRoute(builder: (context)=> HomePage())
                    );
                  },
                      child: const Text("home", style: TextStyle(color: Colors.red),)
                  )
                ],
              ),
            ),
          ),
        ),

    );
  }
}

