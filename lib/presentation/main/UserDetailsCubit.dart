import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:point/domain/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/point_services.dart';

@immutable
abstract class UserDetailsState {}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsFetchInProgress extends UserDetailsState {}

class UserDetailsFetchSuccess extends UserDetailsState {
  UserDetailsFetchSuccess(this.id);

  final String id;
}

class UserDetailsFetchFailure extends UserDetailsState {
  UserDetailsFetchFailure(this.errorMessage);

  final String errorMessage;
}

class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit(this._profileManagementRepository)
      : super(UserDetailsInitial());
  final PointServices _profileManagementRepository;
  String id="";
  //to fetch user details form remote
  Future<void> fetchUserDetails() async {
    emit(UserDetailsFetchInProgress());

    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
       id = sharedPreferences.getString("id")??"";


      emit(UserDetailsFetchSuccess(id!));
    } catch (e) {
      emit(UserDetailsFetchFailure(e.toString()));
    }
  }
  String userId() => state is UserDetailsFetchSuccess
      ? (state as UserDetailsFetchSuccess).id!
      : '';


}