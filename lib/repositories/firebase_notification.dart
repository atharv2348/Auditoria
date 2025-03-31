import 'package:auditoria/repositories/user_repo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  // create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize notification
  Future<void> initNotification() async {
    // request permission from user (will prompt user)
    await _firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fcmToken = await _firebaseMessaging.getToken();

    // send notification 
    UserRepo.sendFCMToken(fcmToken: fcmToken!);
  }
}
