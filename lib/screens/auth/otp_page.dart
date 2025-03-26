import 'dart:async';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:auditoria/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/router/app_router.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/custom_snackbar.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/widgets/custom_loading_overlay.dart';

class OtpPage extends StatefulWidget {
  final String email;
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final ValueNotifier myOtp = ValueNotifier<String>("");
  late ValueNotifier resendTimer;
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    resendTimer = ValueNotifier<int>(120);
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (resendTimer.value >= 0) resendTimer.value--;
      },
    );
  }

  void handleOnSubmit() {
    context
        .read<UserBloc>()
        .add(UserVerifyOtpEvent(otp: myOtp.value, email: widget.email));
  }

  void handleResendOTP() {
    context.read<UserBloc>().add(UserSentOtpEvent(email: widget.email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserVerifyOtpLoadingState ||
              state is UserSendOtpLoadingState) {
            _overlayPortalController.show();
          } else {
            startTimer();
            _overlayPortalController.hide();
          }

          if (state is UserVerifyOtpSucessState) {
            CustomSnackbar.showSuccessSnackbar(state.message!);

            if (!state.isSuccess!) {
              CustomSnackbar.showErrorSnackbar(state.message!);
              return;
            }

            // check if user is new
            if (state.isNewUser!) {
              router.push(Routes.userDetailsScreen, extra: widget.email);
            } else {
              router.go(Routes.homeScreen);
            }
          } else if (state is UserVerifyOtpErrorState) {
            CustomSnackbar.showErrorSnackbar(state.error);
          } else if (state is UserSendOtpErrorState) {
            CustomSnackbar.showErrorSnackbar(state.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () {
                      context.pop();
                      HapticFeedback.vibrate();
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: CustomColors.color5,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "Change Email",
                          style: CustomTextstyles.medium
                              .copyWith(color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 180.h),
                  Text("Enter OTP",
                      style: CustomTextstyles.subHeading
                          .copyWith(color: Colors.grey.shade800)),
                  SizedBox(height: 50.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Pinput(
                        length: 6,
                        defaultPinTheme: PinTheme(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: CustomColors.color5)),
                        ),
                        keyboardType: TextInputType.number,
                        focusedPinTheme: PinTheme(
                          width: 50.w,
                          height: 50.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: CustomColors.color5),
                          ),
                        ),
                        onCompleted: (pin) => myOtp.value = pin,
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  ValueListenableBuilder(
                      valueListenable: resendTimer,
                      builder: (context, value, child) {
                        return customNeoPopButton(
                          text: value >= 0
                              ? 'Resend in ${value.toString()}'
                              : "Resend OTP",
                          onTap: value < 0 ? handleResendOTP : null,
                        );
                      }),
                  SizedBox(height: 20.h),
                  ValueListenableBuilder(
                    valueListenable: myOtp,
                    builder: (context, value, child) {
                      return customNeoPopButton(
                        text: "Submit",
                        onTap: value.toString().length == 6
                            ? handleOnSubmit
                            : null,
                      );
                    },
                  ),
                  CustomLoadingOverlay(
                      overlayPortalController: _overlayPortalController),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
