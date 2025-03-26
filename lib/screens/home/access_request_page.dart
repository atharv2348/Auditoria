import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/utils/custom_snackbar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/widgets/user_request_tile.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/widgets/custom_loading_overlay.dart';
import 'package:auditoria/blocs/requested_access/requested_access_bloc.dart';
import 'package:auditoria/cubits/update_user_access/update_user_access_cubit.dart';

class AccessRequestPage extends StatefulWidget {
  const AccessRequestPage({super.key});

  @override
  State<AccessRequestPage> createState() => _AccessRequestPageState();
}

class _AccessRequestPageState extends State<AccessRequestPage>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    Timer(const Duration(milliseconds: 200),
        () => _animationController.forward());
    context.read<RequestedAccessBloc>().add(FetchRequestedAccessEvent());
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
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
                      "Access Requests",
                      style: CustomTextstyles.medium.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: RefreshIndicator(
                  color: CustomColors.color5,
                  onRefresh: () async {
                    context
                        .read<RequestedAccessBloc>()
                        .add(FetchRequestedAccessEvent());
                  },
                  child: BlocBuilder<RequestedAccessBloc, RequestedAccessState>(
                    builder: (context, state) {
                      if (state is FetchRequestedAccessLoadingState) {
                        return const Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: SpinKitFadingCircle(color: Colors.black45),
                          ),
                        );
                      } else if (state is FetchRequestedAccessErrorState) {
                        return Center(
                          child: Text(state.error),
                        );
                      } else if (state is FetchRequestedAccessSuccessState) {
                        List<UserModel> requestedAccess = state.requestedAccess;
                        if (requestedAccess.isEmpty) {
                          return Center(
                            child: Text("No access requests found",
                                style: CustomTextstyles.medium),
                          );
                        }
                        _animationController.reset();
                        _animationController.forward();

                        return ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              stops: [0.0, 0.05],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[Colors.white10, Colors.white],
                            ).createShader(bounds);
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 10.h, bottom: 15.h),
                            itemCount: requestedAccess.length,
                            itemBuilder: (context, index) {
                              UserModel user = requestedAccess[index];
                              return UserRequestTile(
                                animationController: _animationController,
                                index: index,
                                user: user,
                                onAccept: () {
                                  // call accept api
                                  _showConfirmationDialog(
                                    isAccepting: true,
                                    onConfirm: () {
                                      context.pop();
                                      context
                                          .read<UpdateUserAccessCubit>()
                                          .updateUserAccess(
                                            userId: user.id!,
                                            isApprove: true,
                                          );
                                    },
                                  );
                                },
                                onReject: () {
                                  // call rejectapi
                                  _showConfirmationDialog(
                                      isAccepting: false,
                                      onConfirm: () {
                                        context.pop();
                                        context
                                            .read<UpdateUserAccessCubit>()
                                            .updateUserAccess(
                                              userId: user.id!,
                                              isApprove: false,
                                            );
                                      });
                                },
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(child: Text("No data"));
                      }
                    },
                  ),
                ),
              ),
              BlocListener<UpdateUserAccessCubit, UpdateUserAccessState>(
                listener: (context, state) {
                  if (state is UpdateUserAccessLoadingState) {
                    _overlayPortalController.show();
                  } else {
                    _overlayPortalController.hide();
                  }

                  if (state is UpdateUserAccessSuccessState) {
                    if (state.isSuccess) {
                      context
                          .read<RequestedAccessBloc>()
                          .add(FetchRequestedAccessEvent());

                      CustomSnackbar.showSuccessSnackbar(state.message);
                    } else {
                      CustomSnackbar.showErrorSnackbar(state.message);
                    }
                  } else if (state is UpdateUserAccessErrorState) {
                    CustomSnackbar.showErrorSnackbar(state.error);
                  }
                },
                child: CustomLoadingOverlay(
                    overlayPortalController: _overlayPortalController),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog({
    required bool isAccepting,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isAccepting ? "Grant User Access?" : "Revoke User Access?",
          style: CustomTextstyles.subHeading.copyWith(
            color: CustomColors.color5,
          ),
        ),
        content: Text(
          isAccepting
              ? "Are you sure you want to grant this user access to book the auditorium?"
              : "Are you sure you want to revoke this user's access to book the auditorium?",
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
}
