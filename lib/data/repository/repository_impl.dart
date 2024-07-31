


import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:point/data/mapper/mapper.dart';
import 'package:point/data/network/request.dart';
import 'package:point/domain/models/game_firebase_model.dart';
import 'package:point/domain/models/models.dart';
import 'package:point/domain/models/profile_data_model.dart';
import 'package:point/domain/models/sumbit_room_model.dart';

import '../../domain/repository/repository.dart';
import '../data_source/local_data_source.dart';
import '../data_source/remote_data_source.dart';
import '../network/error_handler.dart';
import '../network/failure.dart';
import '../network/firebase_services.dart';
import '../network/network_info.dart';


class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final FireStoreServices _fireStoreServices;

  RepositoryImpl(this._remoteDataSource, this._networkInfo,
      this._localDataSource,this._fireStoreServices);

  @override
  Future<Either<Failure, RoomModel>> room(RoomRequest roomRequest) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.room(roomRequest);
        print("status ---> ${response.status}");

        if (response.isOk!) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.error ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, CategoryResponseModel>> categories()async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.categories();
        print("status ---> ${response.status}");

        if (response.isOk!) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.error ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, QuestionResponseModel>> questions(QuestionRequest questionRequest)async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.Questions(questionRequest);
        print("status ---> ${response.status}");

        if (response.isOk!) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.error ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Stream<Either<Failure, List<GameFireBaseModel>>> game(String roomId, String createdBy, String currentCategoryId, bool readyToPlay, int totalQuestions, UserModel userModel,String currentUserId,String room) async*{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API

      yield* _fireStoreServices.startGame(
        roomId: roomId,
        createdBy: createdBy,
        currentCategoryId: currentCategoryId,
        readyToPlay: readyToPlay,
        totalQuestions: totalQuestions,
        userModel: userModel,
        currentUserId: currentUserId,
        room: room
      );




    } else {
      // return internet connection error
      // return either left

      yield Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      return;


    }
  }

  @override
  Future<Either<Failure, ProfileDataModel>> profile(String userId)async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.profile(userId);
        print("status ---> ${response.status}");

        if (response.isOk!) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.error ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Stream<Either<Failure, List<GameFireBaseModel>>> joinGame(String roomId,UserModel userModel)async* {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API

      yield* _fireStoreServices.joinGame(
          roomId: roomId,

          userModel: userModel
      );




    } else {
      // return internet connection error
      // return either left

      yield Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      return;


    }
  }

  @override
  Future<Either<Failure, bool>> clearGame(String roomId)async {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        await _fireStoreServices.clearGame(roomId);

        return const Right(true);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> startPlay(String roomId) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        await _fireStoreServices.startPlay(roomId);


         return const Right(null);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> initializeQuestions(String roomId, String currentUserId, List<UserModel> users)async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        await _fireStoreServices.initializeQuestions(roomId,currentUserId,users);


        return const Right(null);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateCategoryAndUsers(String roomId, String currentCategoryId, List<UserModel> users) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        await _fireStoreServices.updateCategoryAndUsers(roomId,currentCategoryId,users);


        return const Right(null);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateQuestion(String roomId, List<UserModel> users) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        await _fireStoreServices.updateListItem(roomId,users);


        return const Right(null);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<QuestionResponseModel>>> fetchQuestions(List<QuestionRequest> requests) async{
    List<QuestionResponseModel> responses = [];
    for (int i = 0; i < requests.length; i++) {
      final result = await questions(requests[i]);
      result.fold(
            (error) => Left(ErrorHandler.handle(error).failure!),
            (user) => responses.add(user),
      );
    }
    return Right(responses);
  }

  @override
  Stream<Either<Failure, List<GameFireBaseModel>>> gameDetails(String roomId)async* {
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API

      yield* _fireStoreServices.gameDetails(
          roomId: roomId,


      );




    } else {
      // return internet connection error
      // return either left

      yield Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
      return;


    }
  }

  @override
  Future<Either<Failure, void>> updateAnswers(String roomId, List<UserModel> users) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        await _fireStoreServices.updateAnswers(roomId,users);


        return const Right(null);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, SumbitRoomModel>> sumbitRoom(String roomId, String winner, String points) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        final response = await _remoteDataSource.sumbitRoom(roomId,winner,points);
        print("status ---> ${response.status}");

        if (response.isOk!) {
          // success
          // return either right
          // return data
          return Right(response.toDomain());
        } else {
          // failure --return business error
          // return either left
          return Left(Failure(ApiInternalStatus.FAILURE,
              response.error ?? ResponseMessage.DEFAULT));
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRoom(String roomId) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        await _fireStoreServices.clearGame(roomId);


        return const Right(null);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateUsers(String roomId, List<UserModel> users) async{
    if (await _networkInfo.isConnected) {
      // its connected to internet, its safe to call API
      try {
        await _fireStoreServices.updateUsers(roomId,users);


        return const Right(null);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure!);
      }
    } else {
      // return internet connection error
      // return either left
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }




}