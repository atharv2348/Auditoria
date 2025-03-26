part of 'requested_access_bloc.dart';

@immutable
sealed class RequestedAccessEvent {}

final class FetchRequestedAccessEvent extends RequestedAccessEvent {}
