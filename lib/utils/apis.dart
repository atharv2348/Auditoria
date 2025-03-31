class Apis {
  static const String baseUrl =
      "https://gcek-auditorium-backend.onrender.com/api/";

  // user auth apis
  static const getOtpUrl = "${baseUrl}auth/sendOTP";
  static const verifyOtpUrl = "${baseUrl}auth/verifyOTP";
  static const createUserUrl = "${baseUrl}auth/createUser";
  static const verifyTokenUrl = "${baseUrl}auth/verifyToken";
  static const emailAlertsUrl = "${baseUrl}user/emailSubscription";

  // event apis
  static const getUserEventsUrl = "${baseUrl}event/user";
  static const getRequestEventsUrl = "${baseUrl}event/requested";
  static const getBookedEventsUrl = "${baseUrl}event/booked";
  static const getUpcomingEventsUrl = "${baseUrl}event/upcomming";
  static const updateEventStatusUrl = "${baseUrl}event/updateStatus";
  static const sendEventRequestUrl = "${baseUrl}event";

  // booking access request
  static const getBookingAccessRequest = "${baseUrl}bookingAccessRequest";

  // feedback api
  static const feedbackUrl = "${baseUrl}feedback";

  // notification api
  static const sendFCMTokenUrl = "${baseUrl}notification";
}
