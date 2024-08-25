// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:temp/welcome_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({super.key, required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  late Timer _timer;
  int _start = 180;
  bool _resendEnabled = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _resendEnabled = false;
    _start = 180;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              _resendEnabled = true;
              timer.cancel();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _start--;
              if (_start <= 150) {
                _resendEnabled = true;
              }
            });
          }
        }
      },
    );
  }


  @override
  void dispose() {
    _timer.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent the layout from resizing
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.16),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.01, bottom: screenHeight * 0.01),
                child: Center(
                  child: Text(
                    'We have sent an OTP @ +91 ${widget.phoneNumber}',
                    style: TextStyle(fontSize: screenHeight * 0.02, color: const Color.fromARGB(255, 100, 99, 99)),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Handle change number
                  },
                  child: Text(
                    'Change Number',
                    style: TextStyle(fontSize: screenHeight * 0.018, color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              Center(
                child: Text(
                  timerText,
                  style: TextStyle(fontSize: screenHeight * 0.04, color: Colors.blue),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: screenWidth * 0.1,
                    child: TextField(
                      controller: otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        counterText: '',
                      ),
                      onChanged: (value) {
                        if (value.length == 1 && index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "If you didn't receive a code! ",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 100, 99, 99),
                        fontSize: screenHeight * 0.02,
                      ),
                    ),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: _resendEnabled ? () => startTimer() : null,
                      child: Text(
                        'Resend',
                        style: TextStyle(
                          color: _resendEnabled ? Colors.green : const Color.fromARGB(255, 100, 99, 99),
                          fontSize: screenHeight * 0.02,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.26),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle register tap
                  },
                  child: Text(
                    'Don’t have an account? Register',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  minimumSize: Size(double.infinity, screenHeight * 0.07),
                ),
                onPressed: () {
                  {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                  );
                }
                },
                child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: screenHeight * 0.024)),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
