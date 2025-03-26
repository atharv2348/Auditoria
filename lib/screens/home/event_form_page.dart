import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/router/app_router.dart';
import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/utils/custom_colors.dart';
import 'package:auditoria/widgets/custom_button.dart';
import 'package:auditoria/utils/custom_snackbar.dart';
import 'package:auditoria/repositories/user_repo.dart';
import 'package:auditoria/utils/custom_text_fields.dart';
import 'package:auditoria/utils/custom_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:auditoria/widgets/custom_loading_overlay.dart';
import 'package:auditoria/blocs/create_event_bloc/create_event_bloc.dart';
import 'package:auditoria/blocs/fetch_booked_events/fetch_booked_events_bloc.dart';

class EventFormPage extends StatefulWidget {
  const EventFormPage({super.key});

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _organizerController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _expAttendeesController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  String formatToISO8601({required String date, required String time}) {
    try {
      DateTime parsedDate = DateFormat("yyyy-MM-dd").parse(date);
      DateTime parsedTime = DateFormat("h:mm a").parse(time);

      DateTime combinedDateTime = DateTime(
        parsedDate.year,
        parsedDate.month,
        parsedDate.day,
        parsedTime.hour,
        parsedTime.minute,
      );

      return "${combinedDateTime.toIso8601String()}Z";
    } catch (e) {
      return "";
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (picked != null) {
      _dateController.text = picked.toString().split(" ")[0];
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final localizations = MaterialLocalizations.of(context);
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      final formattedTime = localizations.formatTimeOfDay(picked);
      if (isStart) {
        _startTimeController.text = formattedTime;
      } else {
        _endTimeController.text = formattedTime;
      }
    }
  }

  void _handleSendRequest() async {
    FocusScope.of(context).unfocus();
    bool isAllFilled = _checkAllFields();

    if (!isAllFilled) {
      CustomSnackbar.showErrorSnackbar('Please fill all the required fields.');
      return;
    }

    if (!_isEndTimeValid()) {
      CustomSnackbar.showErrorSnackbar(
          'End time must be greater than start time.');
      return;
    }

    // Call API to create event
    EventModel event = await getEventModel();
    if (mounted) {
      context.read<CreateEventBloc>().add(CreateEventEvent(event: event));
    }
  }

  bool _isEndTimeValid() {
    try {
      DateFormat format = DateFormat("h:mm a");

      DateTime startTime = format.parse(_startTimeController.text);
      DateTime endTime = format.parse(_endTimeController.text);

      return endTime.isAfter(startTime);
    } catch (e) {
      return false;
    }
  }

  Future<EventModel> getEventModel() async {
    final UserModel? user = await UserRepo.getUserDetailsFromLocalStorage();

    EventModel event = EventModel(
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        organizer: _organizerController.text.trim(),
        startTime: formatToISO8601(
            date: _dateController.text, time: _startTimeController.text),
        endTime: formatToISO8601(
            date: _dateController.text, time: _endTimeController.text),
        requestedBy: user?.id,
        expectedAttendees: int.parse(_expAttendeesController.text.trim()),
        contactEmail: user?.email,
        contactPhoneNumber: user?.phoneNumber,
        instructions: _instructionsController.text.trim());
    return event;
  }

  bool _checkAllFields() {
    return (_titleController.text.isNotEmpty &&
        _descController.text.isNotEmpty &&
        _organizerController.text.isNotEmpty &&
        _dateController.text.isNotEmpty &&
        _startTimeController.text.isNotEmpty &&
        _endTimeController.text.isNotEmpty &&
        _expAttendeesController.text.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CreateEventBloc, CreateEventState>(
        listener: (context, state) {
          if (state is CreateEventLoadingState) {
            _overlayPortalController.show();
          } else {
            _overlayPortalController.hide();
          }

          if (state is CreateEventSuccessState) {
            if (state.isSuccess) {
              CustomSnackbar.showSuccessSnackbar(state.message,
                  duration: const Duration(seconds: 5));
              context.read<FetchBookedEventsBloc>().add(FetchEvents());
              router.pop();
            } else {
              CustomSnackbar.showErrorSnackbar(state.message);
            }
          } else if (state is CreateEventErrorState) {
            CustomSnackbar.showErrorSnackbar(state.error);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SingleChildScrollView(
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
                            "Event Form",
                            style: CustomTextstyles.medium.copyWith(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                    TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.black),
                        decoration: CustomInputDecoration.getDecoration(
                            labelText: 'Event Name*')),
                    SizedBox(height: 20.h),
                    TextField(
                        controller: _descController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(color: Colors.black),
                        decoration: CustomInputDecoration.getDecoration(
                            labelText: 'Event Description*')),
                    SizedBox(height: 20.h),
                    TextField(
                        controller: _organizerController,
                        style: const TextStyle(color: Colors.black),
                        decoration: CustomInputDecoration.getDecoration(
                            labelText: 'Organizer*')),
                    SizedBox(height: 20.h),
                    TextField(
                      onChanged: (value) {
                        _dateController.text = value;
                      },
                      onTap: () {
                        _selectDate(context);
                      },
                      controller: _dateController,
                      style: const TextStyle(color: Colors.black),
                      decoration: CustomInputDecoration.getDecoration(
                          labelText: 'Date*'),
                      readOnly: true,
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              _startTimeController.text = value;
                            },
                            enableInteractiveSelection: true,
                            enableSuggestions: true,
                            controller: _startTimeController,
                            style: const TextStyle(color: Colors.black),
                            decoration: CustomInputDecoration.getDecoration(
                                labelText: 'Start Time*'),
                            readOnly: true,
                            onTap: () {
                              _selectTime(context, true);
                            },
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: TextField(
                            onChanged: (value) {},
                            controller: _endTimeController,
                            style: const TextStyle(color: Colors.black),
                            decoration: CustomInputDecoration.getDecoration(
                                labelText: 'End Time*'),
                            readOnly: true,
                            onTap: () {
                              _selectTime(context, false);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                        keyboardType: TextInputType.number,
                        controller: _expAttendeesController,
                        minLines: 1,
                        maxLines: null,
                        style: const TextStyle(color: Colors.black),
                        decoration: CustomInputDecoration.getDecoration(
                            labelText: 'Expected Attendees')),
                    SizedBox(height: 20.h),
                    TextField(
                        controller: _instructionsController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(color: Colors.black),
                        decoration: CustomInputDecoration.getDecoration(
                            labelText: 'Instructions')),
                    SizedBox(height: 40.h),
                    customNeoPopButton(
                        text: "Send request", onTap: _handleSendRequest),
                    CustomLoadingOverlay(
                        overlayPortalController: _overlayPortalController)
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
