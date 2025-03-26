import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auditoria/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/router/app_router.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_snackbar.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/utils/custom_text_fields.dart';
import 'package:auditoria/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/widgets/custom_loading_overlay.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _emailController = TextEditingController();
  final List<String> features = [
    "Book!",
    "Attend!",
    "Engage!",
    "Participate!",
  ];
  String myOTP = "";

  final ValueNotifier<String> animatedText = ValueNotifier("");
  int currentFeatureIndex = 0;
  int charIndex = 0;
  Timer? timer;
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  void handleSendOtp() {
    FocusScope.of(context).unfocus();
    String email = _emailController.text.trim();
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      CustomSnackbar.showErrorSnackbar('Enter a valid email');
      return;
    }

    context.read<UserBloc>().add(UserSentOtpEvent(email: email));
  }

  @override
  void initState() {
    super.initState();
    _startTypingAnimation();
  }

  @override
  void dispose() {
    _emailController.dispose();
    timer!.cancel();

    super.dispose();
  }

  void _startTypingAnimation() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (charIndex < features[currentFeatureIndex].length) {
        animatedText.value =
            features[currentFeatureIndex].substring(0, charIndex + 1);
        charIndex++;
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          _startDeletingAnimation();
        });
        timer.cancel();
      }
    });
  }

  void _startDeletingAnimation() {
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (charIndex > 0) {
        animatedText.value =
            features[currentFeatureIndex].substring(0, charIndex - 1);
        charIndex--;
      } else {
        currentFeatureIndex = (currentFeatureIndex + 1) % features.length;
        Future.delayed(const Duration(milliseconds: 500), () {
          _startTypingAnimation();
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserSendOtpLoadingState) {
            _overlayPortalController.show();
          } else {
            _overlayPortalController.hide();
          }

          if (state is UserSendOtpSucessState) {
            CustomSnackbar.showSuccessSnackbar(state.message);
            router.push(Routes.otpScreen, extra: _emailController.text);
          } else if (state is UserSendOtpErrorState) {
            CustomSnackbar.showErrorSnackbar(state.error);
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 350.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: const BoxDecoration(
                      color: CustomColors.color1,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 4),
                            spreadRadius: 10,
                            color: Colors.grey,
                            blurRadius: 10)
                      ]),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30.h),
                        Text("Hey there!",
                            style: CustomTextstyles.heading
                                .copyWith(color: Colors.grey.shade800)),
                        SizedBox(height: 20.h),
                        Text("Your GCEK Events, Your Way!",
                            style: CustomTextstyles.subHeading
                                .copyWith(color: Colors.grey.shade800)),
                        ValueListenableBuilder(
                          valueListenable: animatedText,
                          builder: (context, value, child) {
                            return Row(
                              children: [
                                Text(
                                  "You can ",
                                  style: CustomTextstyles.medium
                                      .copyWith(color: Colors.grey.shade800),
                                ),
                                Text(
                                  value,
                                  style: CustomTextstyles.medium
                                      .copyWith(color: CustomColors.color4),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Text("Enter Email",
                        style: CustomTextstyles.subHeading
                            .copyWith(color: Colors.grey.shade800)),
                    SizedBox(height: 40.h),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: CustomInputDecoration.getDecoration(
                        labelText: "Email",
                        icon: const Icon(Icons.email_rounded),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    customNeoPopButton(text: "Send OTP", onTap: handleSendOtp),
                  ],
                ),
              ),
              CustomLoadingOverlay(
                  overlayPortalController: _overlayPortalController),
            ],
          );
        },
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);

    path.quadraticBezierTo(
        size.width * 0.20, size.height, size.width * 0.5, size.height - 60);
    path.quadraticBezierTo(
        size.width * 0.75, size.height - 120, size.width, size.height - 60);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => false;
}
