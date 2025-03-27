import 'package:flutter/material.dart';
import 'package:auditoria/utils/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/router/app_router.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_snackbar.dart';
import 'package:auditoria/utils/custom_text_fields.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:auditoria/blocs/user_bloc/user_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/widgets/custom_loading_overlay.dart';

class CreateUserPage extends StatelessWidget {
  CreateUserPage({super.key, required this.email})
      : _emailController = TextEditingController(text: email);

  final String email;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _prnNumberController = TextEditingController();
  final ValueNotifier selectedRole = ValueNotifier<String>("Student");
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  void handleOnSubmit(BuildContext context) {
    FocusScope.of(context).unfocus();
    UserModel userModel = UserModel(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: email,
        phoneNumber: _phoneNumberController.text.trim(),
        role: selectedRole.value,
        prnNumber: _prnNumberController.text.trim());

    context.read<UserBloc>().add(UserCreateEvent(user: userModel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserCreateLoadingState) {
            _overlayPortalController.show();
          } else {
            _overlayPortalController.hide();
          }

          if (state is UserCreateSuccessState) {
            if (state.isSuccess!) {
              CustomSnackbar.showSuccessSnackbar(state.message!);
              router.go(Routes.homeScreen);
            } else {
              CustomSnackbar.showErrorSnackbar(state.message!);
            }
          } else if (state is UserCreateErrorState) {
            CustomSnackbar.showErrorSnackbar(state.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text('Create your free account',
                        style: CustomTextstyles.subHeading
                            .copyWith(color: Colors.grey.shade800)),
                    SizedBox(height: 40.h),
                    TextField(
                      controller: _firstNameController,
                      decoration: CustomInputDecoration.getDecoration(
                        labelText: "First Name *",
                        icon: const Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextField(
                      controller: _lastNameController,
                      decoration: CustomInputDecoration.getDecoration(
                        labelText: "Last name *",
                        icon: const Icon(Icons.person),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    TextField(
                      controller: _emailController,
                      decoration: CustomInputDecoration.getDecoration(
                        labelText: "Email",
                        icon: const Icon(Icons.email_rounded),
                      ),
                      // enabled: false,
                      readOnly: true,
                    ),
                    SizedBox(height: 15.h),
                    TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: CustomInputDecoration.getDecoration(
                        labelText: "Phone No. *",
                        icon: const Icon(Icons.phone),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Flexible(
                      child: DropdownMenu<String>(
                        requestFocusOnTap: false,
                        enableFilter: false,
                        enableSearch: false,
                        width: double.maxFinite,
                        initialSelection: selectedRole.value,
                        inputDecorationTheme: const InputDecorationTheme(
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.color1)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: CustomColors.color5)),
                          suffixIconColor: CustomColors.color5,
                        ),
                        hintText: "Role *",
                        onSelected: (String? val) {
                          selectedRole.value = val!;
                        },
                        menuStyle: MenuStyle(
                          backgroundColor:
                              WidgetStateProperty.all(CustomColors.color3),
                        ),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'Student', label: 'Student'),
                          DropdownMenuEntry(
                              value: 'Professor', label: 'Professor'),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    ValueListenableBuilder(
                      valueListenable: selectedRole,
                      builder: (context, value, child) {
                        return Visibility(
                          visible: value == 'Student',
                          child: TextField(
                            controller: _prnNumberController,
                            keyboardType: TextInputType.number,
                            decoration: CustomInputDecoration.getDecoration(
                              labelText: "PRN Number *",
                              icon: const Icon(Icons.numbers),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 40.h),
                    customNeoPopButton(
                      text: "Submit",
                      onTap: () => handleOnSubmit(context),
                    ),
                    CustomLoadingOverlay(
                        overlayPortalController: _overlayPortalController),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
