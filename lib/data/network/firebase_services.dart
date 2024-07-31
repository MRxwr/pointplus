import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:point/domain/models/game_firebase_model.dart';

import 'error_handler.dart';
import 'failure.dart';

class FireStoreServices {
  final FirebaseFirestore _firebaseFirestore;
  FireStoreServices(this._firebaseFirestore);
  Stream<Either<Failure, List<GameFireBaseModel>>> startGame({
    required String roomId,
    required String createdBy,
    required String currentCategoryId,
    required bool readyToPlay,
    required int totalQuestions,
    required UserModel userModel,
    required String currentUserId,
    required String room


  })  async*  {



      await _firebaseFirestore.collection('game').doc(roomId).set({
        'roomId':roomId,
        'createdBy':createdBy,
        'currentCategoryId':currentCategoryId,
        'readyToPlay':readyToPlay,
        'totalQuestions':totalQuestions,
        'currentUserId':currentUserId,
        'room':room,



        'users': FieldValue.arrayUnion([userModel.toMap()]),


      });





    Query query = _firebaseFirestore.collection('game');

    query = query.where("roomId", isEqualTo: roomId);

    yield*   query.snapshots().map((snapshot) {
      try {

        final users = snapshot.docs.map((doc) => GameFireBaseModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
        return Right(users);

      } catch (e) {
        return Left(ErrorHandler.handle(e).failure!);
      }
    });


  }

  Stream<Either<Failure, List<GameFireBaseModel>>> joinGame({

    required UserModel userModel,
    required String roomId


  })  async*  {

    Query query = _firebaseFirestore.collection('game');
    query = query.where("roomId", isEqualTo: roomId);
    QuerySnapshot querySnapshot = await query.get();

    List<GameFireBaseModel> gameFireBaseList = querySnapshot.docs.map((doc) => GameFireBaseModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
List<UserModel> users= gameFireBaseList[0].users;
users.add(userModel);
    Map<String,dynamic> map ={};
    map['users'] = users.map((question) => question.toMap()).toList();

    await _firebaseFirestore.collection('game').doc(roomId).update(map);









    yield*   query.snapshots().map((snapshot) {
      try {

        final users = snapshot.docs.map((doc) => GameFireBaseModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
        return Right(users);

      } catch (e) {
        return Left(ErrorHandler.handle(e).failure!);
      }
    });


  }
  Future<void> clearGame(String roomId) async {
    await _firebaseFirestore.collection('game').doc(roomId).delete();
  }

  Future<void> startPlay(String roomId) async{
    Map<String,dynamic> map ={};
    map['readyToPlay']= true;

    await _firebaseFirestore.collection('game').doc(roomId).update(map);

  }

  Future<void> initializeQuestions(String roomId,String currentUserId,List<UserModel> users) async{
    Map<String,dynamic> map ={};
    map['currentUserId']= currentUserId;
    map['users'] = users.map((question) => question.toMap()).toList();


    await _firebaseFirestore.collection('game').doc(roomId).update(map);

  }

  Future<void> updateUsers(String roomId,List<UserModel> users) async{
    Map<String,dynamic> map ={};

    map['users'] = users.map((question) => question.toMap()).toList();


    await _firebaseFirestore.collection('game').doc(roomId).update(map);

  }
  Future<void> updateCategoryAndUsers(String roomId,String currentCategoryId,List<UserModel> users) async{
    Map<String,dynamic> map ={};
    map['currentCategoryId']= currentCategoryId;
    map['users'] = users.map((question) => question.toMap()).toList();


    await _firebaseFirestore.collection('game').doc(roomId).update(map);

  }

  Future<void> updateAnswers(String roomId,List<UserModel> users)async{
    Map<String,dynamic> map ={};
    map['currentCategoryId']= "";
    map['currentUserId']= "";
  map['users'] = users.map((question) => question.toMap()).toList();

  print(map['users']);




    DocumentReference gameDocRef  =     _firebaseFirestore.collection('game').doc(roomId);
    await  gameDocRef.update(map);
    // for (var answer in results) {
    //   await gameDocRef.collection('answers').add(answer.toMap());
    // }




  }

  Future<void> updateListItem(String roomId,List<UserModel> users) async {
    Map<String,dynamic> map ={};
    map['users'] = users.map((question) => question.toMap()).toList();


    await _firebaseFirestore.collection('game').doc(roomId).update(map);

  }
  Stream<Either<Failure, List<GameFireBaseModel>>> gameDetails({
    required String roomId,



  })  async*  {









    Query query = _firebaseFirestore.collection('game');

    query = query.where("roomId", isEqualTo: roomId);

    yield*   query.snapshots().map((snapshot) {
      try {

        final users = snapshot.docs.map((doc) => GameFireBaseModel.fromMap(doc.data() as Map<String, dynamic>)).toList();
        return Right(users);

      } catch (e) {
        return Left(ErrorHandler.handle(e).failure!);
      }
    });


  }

}

