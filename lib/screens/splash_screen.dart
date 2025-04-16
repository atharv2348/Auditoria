import 'package:flutter/material.dart';
import 'package:auditoria/utils/routes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/router/app_router.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/cubits/verify_token/verify_token_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ValueNotifier<double> iconSizeNotifier = ValueNotifier(50.w);
  final ValueNotifier<double> opacityNotifier = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      iconSizeNotifier.value = 150.w;
      opacityNotifier.value = 1.0;
    });
    Future.delayed(const Duration(seconds: 4), () {
      navigateToNextPage();
    });
  }

  void navigateToNextPage() {
    // call verify token
    context.read<VerifyTokenCubit>().verifyToken();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyTokenCubit, VerifyTokenState>(
      listener: (context, state) {
        if (state is VerifyTokenSuccessState) {
          router.go(Routes.homeScreen);
        } else {
          router.go(Routes.emailScreen);
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<double>(
                valueListenable: iconSizeNotifier,
                builder: (context, size, child) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 50.w, end: size),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeInOut,
                    builder: (context, animatedSize, child) {
                      return SizedBox(
                        width: animatedSize,
                        height: animatedSize,
                        child: SvgPicture.asset(
                          './assets/images/logo.svg',
                          semanticsLabel: 'App Logo',
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),
              ValueListenableBuilder<double>(
                valueListenable: opacityNotifier,
                builder: (context, opacity, child) {
                  return AnimatedOpacity(
                    curve: Curves.easeInOut,
                    duration: const Duration(seconds: 2),
                    opacity: opacity,
                    child: Text(
                      "Auditoria",
                      style: CustomTextstyles.heading
                          .copyWith(fontSize: 38.sp, fontFamily: 'K2D'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
