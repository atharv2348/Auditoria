import 'package:auditoria/router/app_router.dart';
import 'package:auditoria/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/theme/theme_mode.dart';
import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/widgets/custom_popup.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_snackbar.dart';
import 'package:auditoria/repositories/user_repo.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/widgets/custom_loading_overlay.dart';
import 'package:auditoria/cubits/email_alert_toggle/email_alert_toggle_cubit.dart';
import 'package:auditoria/cubits/request_booking_access/request_booking_access_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: GestureDetector(
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
                      "Profile Page",
                      style: CustomTextstyles.medium.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      stops: [0.0, 0.05],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Colors.white10, Colors.white],
                    ).createShader(bounds);
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10.h),
                        _buildProfileHeader(),
                        SizedBox(height: 20.h),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("User Details",
                                style: CustomTextstyles.subHeading)),
                        SizedBox(height: 10.h),
                        const Divider(),
                        SizedBox(height: 10.h),
                        _buildUserDetails(context),
                        if (!(user.hasBookingAccess ?? false))
                          RequestBookingAccess(),
                        SizedBox(height: 10.h),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Preferences",
                                style: CustomTextstyles.subHeading)),
                        SizedBox(height: 10.h),
                        const Divider(),
                        SizedBox(height: 10.h),
                        const Preferences(),
                        SizedBox(height: 20.h),
                        customNeoPopButton(
                          text: "LogOut",
                          color: CustomColors.color6,
                          onTap: () {
                            _showConfirmationDialog(
                              context: context,
                              onConfirm: () {
                                router.pop();
                                _handelLogout();
                              },
                            );
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handelLogout() async {
    await UserRepo.removeUserLocally();
    router.go(Routes.emailScreen);
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Logout",
          style: CustomTextstyles.subHeading.copyWith(
            color: CustomColors.color5,
          ),
        ),
        content: Text(
          "Are you sure you want to log out?",
          style: CustomTextstyles.regular.copyWith(color: Colors.grey.shade800),
        ),
        actions: [
          smallButton(
            text: "Cancel",
            color: CustomColors.disabled,
            paddingVertical: 10.h,
            paddingHorizontal: 15.w,
            onTap: () {
              context.pop();
            },
          ),
          smallButton(
            text: "Confirm",
            color: CustomColors.color5,
            paddingVertical: 10.h,
            paddingHorizontal: 15.w,
            onTap: onConfirm,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 30.h,
        horizontal: 30.w,
      ),
      decoration: BoxDecoration(
          color: CustomColors.color5,
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
          boxShadow: const [
            BoxShadow(
              color: CustomColors.color3,
              spreadRadius: 2,
              blurRadius: 10,
              blurStyle: BlurStyle.inner,
            ),
            BoxShadow(
              color: Colors.black,
              spreadRadius: 2,
              blurRadius: 2,
              blurStyle: BlurStyle.outer,
            ),
          ]),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 60.sp, color: CustomColors.color5),
          ),
          SizedBox(height: 10.h),
          Text(
            "${user.firstName ?? "Unknown"} ${user.lastName ?? ""}",
            style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 5.h),
          Text(
            user.role ?? "User",
            style: TextStyle(fontSize: 16.sp, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(BuildContext context) {
    return Column(
      children: [
        _detailTile(
            Icons.email_outlined, "Email", user.email ?? "Not provided"),
        _detailTile(Icons.phone, "Phone", user.phoneNumber ?? "Not provided"),
        _detailTile(
            Icons.badge_outlined, "PRN Number", user.prnNumber ?? "N/A"),
        _detailTile(Icons.verified_user_outlined, "Role", user.role ?? "N/A"),
      ],
    );
  }

  Widget _detailTile(IconData icon, String label, String value) {
    return Card(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            SizedBox(width: 15.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600)),
                Text(value, style: TextStyle(fontSize: 14.sp)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RequestBookingAccess extends StatelessWidget {
  RequestBookingAccess({super.key});
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "You don't have the necessary permissions to book an event.",
                style: CustomTextstyles.regular,
              ),
            ),
            SizedBox(height: 5.h),
            Align(
              alignment: Alignment.centerRight,
              child: Tooltip(
                message: "Request booking access from admin",
                child: smallButton(
                  text: "Request Booking Access",
                  color: Colors.blue,
                  paddingVertical: 15.h,
                  paddingHorizontal: 20.w,
                  onTap: () {
                    showConfirmationDialog(
                      context: context,
                      title: "Request Booking Access",
                      content:
                          "Do you want to request booking access from the admin?",
                      onCancel: () => context.pop(),
                      onConfirm: () {
                        context.pop();
                        context
                            .read<RequestBookingAccessCubit>()
                            .requestBookingAccessEvent();
                      },
                    );
                  },
                ),
              ),
            ),
            BlocListener<RequestBookingAccessCubit, RequestBookingAccessState>(
              listener: (context, state) {
                if (state is RequestBookingAccessLoadingState) {
                  _overlayPortalController.show();
                } else {
                  _overlayPortalController.hide();
                }

                if (state is RequestBookingAccessSuccessState) {
                  CustomSnackbar.showSuccessSnackbar(state.message);
                } else if (state is RequestBookingAccessErrorState) {
                  CustomSnackbar.showErrorSnackbar(state.error);
                }
              },
              child: CustomLoadingOverlay(
                  overlayPortalController: _overlayPortalController),
            ),
          ],
        ),
      ),
    );
  }
}

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  ValueNotifier<bool>? isEmailSubscribed;
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();
  final ThemeManager _themeManager = ThemeManager();

  @override
  void initState() {
    super.initState();
    isEmailSubscribed = ValueNotifier<bool>(false);
    initializeEmailSubscribedValue();
  }

  void initializeEmailSubscribedValue() async {
    bool value = await UserRepo.getHasBookingAccessFromLocalStorage();
    isEmailSubscribed!.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmailAlertToggleCubit, EmailAlertToggleState>(
      listener: (context, state) {
        if (state is EmailALertToggleLoadingState) {
          _overlayPortalController.show();
        } else {
          _overlayPortalController.hide();
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            if (isEmailSubscribed != null)
              ValueListenableBuilder(
                  valueListenable: isEmailSubscribed!,
                  builder: (context, value, child) {
                    return _buildSettingTile(
                      icon: Icons.email_outlined,
                      title: "Email Alerts",
                      subtitle: "Stay updated with the latest updates",
                      value: isEmailSubscribed!.value,
                      onChanged: (val) {
                        showConfirmationDialog(
                            context: context,
                            title: val
                                ? "Subscribe Email Alerts"
                                : "Unsubscribe Email Alerts",
                            content: val
                                ? "Do you want to subscribe to email alerts?"
                                : "Do you want to unsubscribe from email alerts?",
                            onCancel: () {
                              context.pop();
                            },
                            onConfirm: () {
                              isEmailSubscribed!.value = val;
                              context
                                  .read<EmailAlertToggleCubit>()
                                  .toggleEmailAlert(val);
                              context.pop();
                            });
                      },
                    );
                  }),
            const SizedBox(height: 12),
            ValueListenableBuilder(
              valueListenable: _themeManager.themeNotifier,
              builder: (context, value, child) {
                return _buildSettingTile(
                  icon: Icons.dark_mode_outlined,
                  title: "Dark Mode",
                  subtitle: "Switch between light and dark themes",
                  value: _themeManager.themeNotifier.value == ThemeMode.dark,
                  onChanged: (val) {
                    HapticFeedback.vibrate();
                    _themeManager.setTheme(val);
                  },
                );
              },
            ),
            CustomLoadingOverlay(
                overlayPortalController: _overlayPortalController)
          ],
        );
      },
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 28, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.blueAccent,
        ),
      ),
    );
  }
}
