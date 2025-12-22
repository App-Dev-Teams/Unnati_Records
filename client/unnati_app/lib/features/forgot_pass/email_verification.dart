import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:unnati_app/components/textfield_util.dart';
import 'package:unnati_app/features/forgot_pass/otp_verification.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({super.key});

  @override
  Widget build(BuildContext context) {

    TextEditingController _emailController = TextEditingController(); //email data


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white,foregroundColor: Colors.black,automaticallyImplyLeading: true,),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          FocusScope.of(context).unfocus();
        },

        //main body
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                //lottie
                child: Container(
                  height: 200.h,
                  width: 200.w,
                  child: Lottie.asset(
                    'assets/lottie/email_verification_lottie.json',
                  ),
                ),
              ),
              //middle command to enter email
              Padding(
                padding: EdgeInsets.only(left:30.w),
                child: Text(
                  'Enter your email address',
                  style: GoogleFonts.oswald(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(height: 7,),
        
              //textfield
              Padding(
                padding:  EdgeInsets.only(left: 30.w,right: 30.w),
                child: TextField(
                   controller: _emailController,
                   decoration: InputDecoration(
                    label: Text('email'),
                    labelStyle: TextStyle(color: Colors.grey,fontSize: 12),
                    enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: Colors.blue)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(color: Colors.blue,width: 2))
                   ),
                ),
              ),
        
        
              SizedBox(height: 20,),
        //button
              Padding(
                padding:  EdgeInsets.only(left: 30.w,right: 30.w),
                child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        // fixedSize: Size(300.w, 40.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                        backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpVerification(emailSent: _emailController.text,),
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          'Send OTP',
                          style: GoogleFonts.cormorantSc(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
