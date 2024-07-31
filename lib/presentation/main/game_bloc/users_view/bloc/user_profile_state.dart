part of 'user_profile_bloc.dart';

sealed class UserProfileState extends Equatable {
  const UserProfileState();
}

final class UserProfileInitial extends UserProfileState {
  @override
  List<Object> get props => [];
}
final class UserProfileReset extends UserProfileState {
  @override
  List<Object> get props => [];
}

class UserProfileStateLoading extends UserProfileState {
  const UserProfileStateLoading();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserProfileStateFailure extends UserProfileState {
  final String message;

  const UserProfileStateFailure({required this.message});

  @override
  List<Object> get props => [message];
}
class UserProfileStateSuccess extends UserProfileState {
  final ProfileDataModel profileDataModel;

  const UserProfileStateSuccess({required this.profileDataModel});

  @override
  List<Object> get props => [profileDataModel];
}