import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_snackbar.dart';
import 'package:auditoria/utils/custom_text_fields.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/cubits/feedback/feedback_cubit.dart';
import 'package:auditoria/widgets/custom_loading_overlay.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({super.key});

  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();
  final TextEditingController _feedbackController = TextEditingController();
  final Rating _rating = Rating();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocConsumer<FeedbackCubit, FeedbackState>(
          listener: (context, state) {
            if (state is SendFeedbackLoadingState) {
              _overlayPortalController.show();
            } else {
              _overlayPortalController.hide();
            }

            if (state is SendFeedackSuccessState) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Thank you for your feedback!",
                    style: CustomTextstyles.subHeading.copyWith(
                      color: CustomColors.color5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    smallButton(
                      text: "Go back",
                      color: CustomColors.color5,
                      paddingVertical: 10.h,
                      paddingHorizontal: 15.w,
                      onTap: () {
                        context.pop();
                        context.pop();
                      },
                    ),
                  ],
                ),
              );
            } else if (state is SendFeedbackErrorState) {
              CustomSnackbar.showErrorSnackbar(state.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
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
                          "Feedback",
                          style: CustomTextstyles.medium.copyWith(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                  Text(
                    "How was your experience?",
                    style: CustomTextstyles.medium
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  ListenableBuilder(
                    listenable: _rating,
                    builder: (context, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _rating.rating.asMap().entries.map((entry) {
                        int index = entry.key;
                        bool value = entry.value;
                        return GestureDetector(
                          onTap: () {
                            _rating.updateRating(index);
                          },
                          child: Icon(
                            key: ValueKey(index),
                            value
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: value ? Colors.yellow : Colors.grey,
                            size: 60,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  TextField(
                    controller: _feedbackController,
                    minLines: 1,
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    decoration: CustomInputDecoration.getDecoration(
                      labelText: "Feedback",
                      icon: const Icon(Icons.feedback),
                    ),
                  ),
                  CustomLoadingOverlay(
                      overlayPortalController: _overlayPortalController),
                  SizedBox(height: 40.h),
                  customNeoPopButton(
                      text: "Submit",
                      onTap: () {
                        int rating = _rating.getRating();
                        context.read<FeedbackCubit>().sendFeedback(
                            feedback: _feedbackController.text.trim(),
                            rating: rating);
                      }),
                ],
              ),
            ));
          },
        ),
      ),
    );
  }
}

class Rating extends ChangeNotifier {
  List<bool> rating = [false, false, false, false, false];

  void updateRating(int index) {
    for (int i = 0; i < 5; i++) {
      rating[i] = (i <= index);
    }
    notifyListeners();
  }

  int getRating() {
    int res = 0;
    for (int i = 0; i < 5; i++) {
      if (rating[i]) {
        res++;
      }
    }
    return res;
  }
}
