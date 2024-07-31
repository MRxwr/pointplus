import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:point/domain/usecases/profile_use_case.dart';

import '../../../../../domain/models/profile_data_model.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ProfileUseCase profileUseCase;

  UserProfileBloc(this.profileUseCase) : super(UserProfileInitial()) {

    on<FetchUser>((event, emit) async {
      emit( const UserProfileStateLoading());
      (await profileUseCase.execute(ProfileUseCaseInput(event.userId))).fold(
            (failure) {

          print("failture ---> $failure");
          emit(UserProfileStateFailure(message: failure.message)) ;
        },
            (response) async {


          emit(UserProfileStateSuccess(profileDataModel: response));



        },
      );

    });
    on<InitializeUser>((event, emit)async{
      emit(  UserProfileReset());
    });
    add( InitializeUser());
  }



}
