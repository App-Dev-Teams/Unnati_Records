import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';
import 'package:unnati_app/features/forgot_pass/pass_reset_screen.dart';
import 'package:unnati_app/services/api_service.dart';

class OtpVerification extends StatefulWidget {
  final String emailSent;

  const OtpVerification({super.key, required this.emailSent});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  String _otp = '';
  bool _isVerifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        foregroundColor: Colors.black,
      ),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
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
                    'assets/lottie/otp_verification_lottie.json',
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              //otp sent statement
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Center(
                  child: Text(
                    'OTP sent to : ${widget.emailSent}',
                    style: GoogleFonts.oswald(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: const Color.fromARGB(255, 118, 118, 118),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),

              Center(
                child: Text(
                  'Enter OTP',
                  style: GoogleFonts.oswald(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 7),

              //pinput //otp filling
              Padding(
                padding: EdgeInsets.only(left: 30.w, right: 30.w),
                child: Center(
                  child: Pinput(
                    length: 6,
                    onChanged: (value) {
                      _otp = value;
                    },
                    onCompleted: (value) {
                      _otp = value;
                    },
                  ),
                ),
              ),

              SizedBox(height: 15),

              //button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                    backgroundColor: const Color.fromARGB(255, 9, 75, 128),
                  ),

                  onPressed: _isVerifying
                      ? null
                      : () async {
                          final otp = _otp.trim();
                          if (otp.length != 6) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a 6-digit OTP'),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            _isVerifying = true;
                          });

                          final response = await ApiService.verifyOtp(
                            email: widget.emailSent,
                            otp: otp,
                          );

                          setState(() {
                            _isVerifying = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(response['message'] as String),
                            ),
                          );

                          if (response['success'] == true) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PasswordResetScreen(
                                  email: widget.emailSent,
                                ),
                              ),
                            );
                          }
                        },
                  child: Center(
                    child: _isVerifying
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Verify OTP',
                            style: GoogleFonts.cormorantSc(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              SizedBox(height: 12),
              //didn't reciece OTP
              Center(
                child: Text(
                  "Didn't receive OTP ?",
                  style: GoogleFonts.oswald(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: const Color.fromARGB(255, 118, 118, 118),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    //resend logic
                  },
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 118, 118, 118),
                      decoration: TextDecoration.underline,
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
