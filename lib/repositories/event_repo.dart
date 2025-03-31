import 'package:auditoria/models/event_model.dart';
import 'package:auditoria/repositories/user_repo.dart';
import 'package:auditoria/utils/apis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// this file will contain all the api calls related to event (booking req....)
class EventRepo {
  /// This function will call send event request API
  static Future<Map<String, dynamic>> sendEventRequest(EventModel event) async {
    String url = Apis.sendEventRequestUrl;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(event),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw 'Error occured while sending request!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will fetch all the events
  static Future<List<EventModel>> getBookedEvents() async {
    String url = Apis.getBookedEventsUrl;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        List<EventModel> events = [];
        for (var event in jsonData) {
          events.add(EventModel.fromJson(event));
        }
        return events;
      } else {
        throw 'Error occured while fetching events!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will fetch all requested events
  static Future<List<EventModel>> getRequestedEvents() async {
    String url = Apis.getRequestEventsUrl;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        List<EventModel> events = [];
        for (var event in jsonData) {
          events.add(EventModel.fromJson(event));
        }
        return events;
      } else {
        throw 'Error occured while fetching events!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will fetch all user events
  static Future<List<EventModel>> getUpcomingEvents() async {
    String url = Apis.getUpcomingEventsUrl;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        List<EventModel> events = [];
        for (var event in jsonData) {
          events.add(EventModel.fromJson(event));
        }
        return events;
      } else {
        throw 'Error occured while fetching events!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will fetch all user events
  static Future<List<EventModel>> getUserEvents() async {
    String url = Apis.getUserEventsUrl;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body)['data'];
        List<EventModel> events = [];
        for (var event in jsonData) {
          events.add(EventModel.fromJson(event));
        }
        return events;
      } else {
        throw 'Error occured while fetching events!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will toggle event alerts
  static Future<Map<String, dynamic>> toggleEmailAlert(bool value) async {
    String url = Apis.emailAlertsUrl;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.patch(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({"subscribedToEmails": value}));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        throw 'Error occured while toggling email alerts!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will accept or reject the events request
  static Future<Map<String, dynamic>> updateStatusOfRequestedEvent(
      String eventId, bool isApprove, String? reason) async {
    String url = Apis.updateEventStatusUrl;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.patch(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(
              {"eventId": eventId, "approve": isApprove, "reason": reason}));

      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonData;
      } else {
        throw jsonData['message'];
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will send the request for booking access
  static Future<Map<String, dynamic>> requestBookingAccess() async {
    String url = Apis.getBookingAccessRequest;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.post(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        throw 'Error occured while updating the status of an event!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
