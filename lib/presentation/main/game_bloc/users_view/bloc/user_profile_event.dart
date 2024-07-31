part of 'user_profile_bloc.dart';

sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();
}
class FetchUser extends UserProfileEvent {

  final String userId;




  const FetchUser({required this.userId});

  @override
  List<Object> get props => [userId];
}
class InitializeUser extends UserProfileEvent {








  @override
  List<Object> get props => [];
}