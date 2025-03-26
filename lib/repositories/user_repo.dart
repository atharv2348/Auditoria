import 'package:shared_preferences/shared_preferences.dart';
import 'package:auditoria/models/user_model.dart';
import 'package:auditoria/utils/apis.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// this file will contain all the api calls related to user
class UserRepo {
  /// This function will send OTP on given email
  static Future<String> getOtp(String email) async {
    String url = Apis.getOtpUrl;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        final String message = jsonDecode(response.body)['message'];
        return message;
      } else {
        throw Exception('Failed to get OTP');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will verify the OTP given by user
  static Future<Map<String, dynamic>> verifyOtp(
      String email, String otp) async {
    String url = Apis.verifyOtpUrl;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Incorrect OTP!');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will create new user
  static Future<Map<String, dynamic>> createUser(UserModel user) async {
    String url = Apis.createUser;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "firstName": user.firstName,
          "lastName": user.lastName,
          "email": user.email,
          "phoneNumber": user.phoneNumber,
          "role": user.role,
          "prnNumber": user.prnNumber,
        }),
      );
      Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will create new user
  static Future<Map<String, dynamic>> verifyToken(String token) async {
    String url = Apis.verifyTokenUrl;

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      Map<String, dynamic> data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will fetch all requested access
  static Future<List<UserModel>> getRequestedAccess() async {
    String url = Apis.getBookingAccessRequest;
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
        List<UserModel> users = [];
        for (var user in jsonData) {
          users.add(UserModel.fromJson(user['user']));
        }
        return users;
      } else {
        throw 'Error occured while fetching events!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will fetch all requested access
  static Future<Map<String, dynamic>> updateUserAccess(
      {required String userId, required bool hasBookingAccess}) async {
    String url = Apis.getBookingAccessRequest;
    String? token = await UserRepo.getUserTokenFromLocalStorage();
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(
            {"userId": userId, "hasBookingAccess": hasBookingAccess}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        throw 'Error occured while updating the status!';
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// This function will send the feedback
  static Future<Map<String, dynamic>> sendFeedback(
      {required String feedback, required int rating}) async {
    String url = Apis.feedbackUrl;
    String? token = await UserRepo.getUserTokenFromLocalStorage();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({"feedback": feedback, "rating": rating}),
      );

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

  //? Local Storage

  /// Store user details and token locally
  static storeUserLocally(String token, UserModel user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', jsonEncode(user.toJson()));
  }

  /// Remove user details and token locally
  static removeUserLocally() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  /// Get token from local storage
  static Future<String?> getUserTokenFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token;
  }

  /// Get user details from local storage
  static Future<UserModel?> getUserDetailsFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  /// If user authenticated -> 1 otherwise -> 0
  static Future<bool> checkIfUserAuthenticated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? isTokenPresent = prefs.getString('token');
    return isTokenPresent != null;
  }

  /// This function will update the booking access in local storage
  static Future<void> updateHasBookingAccessLocally(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');

    if (userData != null) {
      UserModel user = UserModel.fromJson(jsonDecode(userData));
      user.hasBookingAccess = value;
      await prefs.setString('user', jsonEncode(user.toJson()));
    } else {
      throw Exception('No user data found in local storage');
    }
  }

  /// This function return
  static Future<bool> getHasBookingAccessFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData)).hasBookingAccess!;
    }
    return false;
  }
}
