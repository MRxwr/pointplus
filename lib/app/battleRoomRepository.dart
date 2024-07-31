import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/point_services.dart';
import '../domain/models/models.dart';
import '../domain/profile_model.dart';
import '../presentation/battle/models/answerOption.dart';
import '../presentation/battle/models/correctAnswer.dart';
import '../presentation/game_categories/models/battleRoom.dart';
import '../presentation/game_categories/models/message.dart';
import '../presentation/game_categories/models/questionCategory.dart';
import 'battleRoomException.dart';
import 'battleRoomRemoteDataSource.dart';
import 'constant.dart';
import 'error_message_keys.dart';

class BattleRoomRepository {
  final FirebaseFirestore _firebaseFirestore ;
  final BattleRoomRemoteDataSource _battleRoomRemoteDataSource;

  BattleRoomRepository(this._battleRoomRemoteDataSource,this._firebaseFirestore);

//create multi user battle room
  Future<DocumentSnapshot> createMultiUserBattleRoom({

    String? roomCode,

  }) async {
    try {
      return await _battleRoomRemoteDataSource.createMultiUserBattleRoom(

        roomCode: roomCode,

      );
    } catch (e) {
      throw BattleRoomException(errorMessageCode: e.toString());
    }
  }
//join multi user battle room
  Future<({String roomId})> joinMultiUserBattleRoom({

    String? roomCode,
    int? currentCoin,
  }) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String uid = sharedPreferences.getString("id")??"";
      Map<String,dynamic> map = {};
      map['id']= uid;
      PointServices pointServices = PointServices();
      ProfileModel? profileModel = await pointServices.profile(map);
      String name = profileModel!.data!.user![0].username!;
      String profileUrl = '$TAG_LOGO_URL${profileModel!.data!.user![0].favoTeam!.logo.toString()}';

      //verify roomCode is valid or not
      final querySnapshot = await _battleRoomRemoteDataSource
          .getMultiUserBattleRoom(roomCode);

      //invalid room code
      if (querySnapshot.docs.isEmpty) {
        throw BattleRoomException(errorMessageCode: errorCodeRoomCodeInvalid);
      }

      final roomData = querySnapshot.docs.first.data()! as Map<String, dynamic>;

      //game started code
      if (roomData['readyToPlay'] as bool) {
        throw BattleRoomException(errorMessageCode: errorCodeGameStarted);
      }

      // //not enough coins
      // if (roomData['entryFee'] as int > currentCoin!) {
      //   throw BattleRoomException(errorMessageCode: errorCodeNotEnoughCoins);
      // }


      //get roomRef
      final documentReference = querySnapshot.docs.first.reference;

      //using transaction so we get latest document before updating roomDocument
      return FirebaseFirestore.instance.runTransaction((transaction) async {
        //get latest document
        final documentSnapshot = await documentReference.get();
        final docData = documentSnapshot.data()! as Map<String, dynamic>;

        final user2 = docData['user2'] as Map<String, dynamic>;
        final user3 = docData['user3'] as Map<String, dynamic>;
        final user4 = docData['user4'] as Map<String, dynamic>;
        final user5 = docData['user5'] as Map<String, dynamic>;
        final user6 = docData['user6'] as Map<String, dynamic>;
        /// Join as available user
        if (user2['uid'].toString().isEmpty) {
          //join as user2
          transaction.update(documentReference, {
            'user2.name': name,
            'user2.uid': uid,
            'user2.profileUrl': profileUrl,
          });
        } else if (user3['uid'].toString().isEmpty) {
          //join as user3
          transaction.update(documentReference, {
            'user3.name': name,
            'user3.uid': uid,
            'user3.profileUrl': profileUrl,
          });
        } else if (user4['uid'].toString().isEmpty) {
          //join as user4
          transaction.update(documentReference, {
            'user4.name': name,
            'user4.uid': uid,
            'user4.profileUrl': profileUrl,
          });
        }
        else if (user5['uid'].toString().isEmpty) {
          //join as user4
          transaction.update(documentReference, {
            'user5.name': name,
            'user5.uid': uid,
            'user5.profileUrl': profileUrl,
          });
        }else if (user6['uid'].toString().isEmpty) {
          //join as user4
          transaction.update(documentReference, {
            'user6.name': name,
            'user6.uid': uid,
            'user6.profileUrl': profileUrl,
          });
        }
        else {
          //room is full
          throw BattleRoomException(errorMessageCode: errorCodeRoomIsFull);
        }

        return (
        roomId: documentSnapshot.id

        );
      });
    } catch (e) {
      throw BattleRoomException(errorMessageCode: e.toString());
    }
  }
//subscribe to battle room
  Stream<DocumentSnapshot> subscribeToBattleRoom(
      String? battleRoomDocumentId) {
    return _battleRoomRemoteDataSource.subscribeToBattleRoom(
      battleRoomDocumentId

    );
  }
  Future<void> subscribeToBattleRoomQuestions(
      String? battleRoomDocumentId,String? userId,int? noOfQuestions) {
    return  _battleRoomRemoteDataSource.questionsLoaded(
        battleRoomDocumentId.toString(),userId,noOfQuestions!

    );
  }


  Future<List<Questions>> getQuestionForCurrentUser(String battleRoomDocumentId) async{


    List<Questions> questions=[];
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uid = sharedPreferences.getString("id")??"";
    final DocumentReference documentReference = (await _firebaseFirestore
        .collection(multiUserBattleRoomCollection)
        .doc(battleRoomDocumentId)
        .get())
        .reference;
    final documentSnapshot = await documentReference.get();
    String catId  =documentSnapshot['currentCategoryId'];
    final docData = documentSnapshot.data()! as Map<String, dynamic>;
    final user1 = docData['user1'] as Map<String, dynamic>;
    final user2 = docData['user2'] as Map<String, dynamic>;
    final user3 = docData['user3'] as Map<String, dynamic>;
    final user4 = docData['user4'] as Map<String, dynamic>;
    final user5 = docData['user5'] as Map<String, dynamic>;
    final user6 = docData['user6'] as Map<String, dynamic>;
    if (user1['uid']== uid) {
      List allQuestionsInCategory = user1['questionCategory'];
      for(int i =0;i<allQuestionsInCategory.length;i++){
        String categoryId = allQuestionsInCategory[i]["categoryId"];
        if(categoryId == catId){
          List questionArrayList =  allQuestionsInCategory[i]["questions"];
          return questionArrayList
              .map((e) => Questions.fromJson(Map<String,dynamic>.from(e)))
              .toList();

        }

      }




    }else  if (user2['uid']== uid) {
      List allQuestionsInCategory = user2['questionCategory'];
      for(int i =0;i<allQuestionsInCategory.length;i++){
        String categoryId = allQuestionsInCategory[i]["categoryId"];
        if(categoryId == catId){
          print("test --> ${allQuestionsInCategory[i]["questions"]}") ;
          List questionArrayList =  allQuestionsInCategory[i]["questions"];
          return questionArrayList
              .map((e) => Questions.fromJson(Map<String,dynamic>.from(e)))
              .toList();

        }

      }

    }
    else  if (user3['uid']== uid) {
      List allQuestionsInCategory = user3['questionCategory'];
      for(int i =0;i<allQuestionsInCategory.length;i++){
        String categoryId = allQuestionsInCategory[i]["categoryId"];
        if(categoryId == catId){
          List questionArrayList =  allQuestionsInCategory[i]["questions"];
          return questionArrayList
              .map((e) => Questions.fromJson(Map<String,dynamic>.from(e)))
              .toList();

        }

      }


    }
    else  if (user4['uid']== uid) {
      List allQuestionsInCategory = user4['questionCategory'];
      for(int i =0;i<allQuestionsInCategory.length;i++){
        String categoryId = allQuestionsInCategory[i]["categoryId"];
        if(categoryId == catId){
          List questionArrayList =  allQuestionsInCategory[i]["questions"];
          return questionArrayList
              .map((e) => Questions.fromJson(Map<String,dynamic>.from(e)))
              .toList();

        }

      }


    }
    else  if (user5['uid']== uid) {
      List allQuestionsInCategory = user5['questionCategory'];
      for(int i =0;i<allQuestionsInCategory.length;i++){
        String categoryId = allQuestionsInCategory[i]["categoryId"];
        if(categoryId == catId){
          List questionArrayList =  allQuestionsInCategory[i]["questions"];
          return questionArrayList
              .map((e) => Questions.fromJson(Map<String,dynamic>.from(e)))
              .toList();

        }

      }


    }
    else  if (user6['uid']== uid) {
      List allQuestionsInCategory = user6['questionCategory'];
      for(int i =0;i<allQuestionsInCategory.length;i++){
        String categoryId = allQuestionsInCategory[i]["categoryId"];
        if(categoryId == catId){
          List questionArrayList =  allQuestionsInCategory[i]["questions"];
          return questionArrayList
              .map((e) => Questions.fromJson(Map<String,dynamic>.from(e)))
              .toList();

        }

      }


    }
    return questions;




  }
  Future<({String roomId})> insertQuestionsForCategory(
      String? battleRoomDocumentId,QuestionResponseModel? questionResponseModel,String? categoryId)
  async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String uid = sharedPreferences.getString("id")??"";
      print("battleRoomDocumentId ---> ${battleRoomDocumentId}");
      print("battleRoomCollection -> $battleRoomCollection");

      //verify roomCode is valid or not
      final DocumentReference documentReference = (await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(battleRoomDocumentId)
          .get())
          .reference;

      final docData = documentReference.get()! as Map<String, dynamic>;
      print("docData ---> $docData}");
      final user1 = docData['user1'] as Map<String, dynamic>;
      final user2 = docData['user2'] as Map<String, dynamic>;
      final user3 = docData['user3'] as Map<String, dynamic>;
      final user4 = docData['user4'] as Map<String, dynamic>;
      final user5 = docData['user5'] as Map<String, dynamic>;
      final user6 = docData['user6'] as Map<String, dynamic>;


      Map<String,dynamic> map = {};
      map['categoryId']= categoryId;
      List<Map<String,dynamic>> questionsList =[];
      //here insert
      for(int i=0;i<questionResponseModel!.questionResultModel.questionList.length;i++){
        Map<String,dynamic> questionMap = {};
        questionMap['answer1']= questionResponseModel!.questionResultModel.questionList[i].answer1;
        questionMap['answer2']= questionResponseModel!.questionResultModel.questionList[i].answer2;

        questionMap['answer3']= questionResponseModel!.questionResultModel.questionList[i].answer3;
        questionMap['question']= questionResponseModel!.questionResultModel.questionList[i].question;
        questionMap['isCorrect1']= questionResponseModel!.questionResultModel.questionList[i].isCorrect1;
        questionMap['isCorrect2']= questionResponseModel!.questionResultModel.questionList[i].isCorrect2;
        questionMap['isCorrect3']= questionResponseModel!.questionResultModel.questionList[i].isCorrect3;
        questionMap['image']= questionResponseModel!.questionResultModel.questionList[i].image;
        questionMap['points']= questionResponseModel!.questionResultModel.questionList[i].points;
        questionMap['score']= "";
        questionMap['attempted']= false;
        questionMap['id']=questionResponseModel!.questionResultModel.questionList[i].id;
        List<AnswerOption> answers = [];
        AnswerOption answerOption1= AnswerOption(id: "1",title: questionResponseModel!.questionResultModel.questionList[i].answer1);
        answers.add(answerOption1);
        AnswerOption answerOption2= AnswerOption(id: "2",title: questionResponseModel!.questionResultModel.questionList[i].answer2);
        answers.add(answerOption2);
        AnswerOption answerOption3= AnswerOption(id: "3",title: questionResponseModel!.questionResultModel.questionList[i].answer3);
        answers.add(answerOption3);
        questionMap['answerOptions']=answers.map((v) => v.toJson()).toList();
        CorrectAnswer? correctAnswer;
        if(questionResponseModel!.questionResultModel.questionList[i].isCorrect1 == "1"){
          correctAnswer = CorrectAnswer(answer:questionResponseModel!.questionResultModel.questionList[i].answer1.toString(),answerId: "1");

        }else if(questionResponseModel!.questionResultModel.questionList[i].isCorrect2 == "1"){
          correctAnswer = CorrectAnswer(answer:questionResponseModel!.questionResultModel.questionList[i].answer2.toString(),answerId: "2");

        }
        else if(questionResponseModel!.questionResultModel.questionList[i].isCorrect3 == "1"){
          correctAnswer = CorrectAnswer(answer:questionResponseModel!.questionResultModel.questionList[i].answer3.toString(),answerId: "3");

        }
        questionMap['correctAnswer'] = correctAnswer!.toJson();
        questionMap['submittedAnswerId']= "";




        questionsList.add(questionMap);
      }
      map['questions']= questionsList;
      //invalid room code





      //using transaction so we get latest document before updating roomDocument
      return FirebaseFirestore.instance.runTransaction((transaction) async {
        //get latest document
        final documentSnapshot = await documentReference.get();
        final docData = documentSnapshot.data()! as Map<String, dynamic>;
        print("docData ---> $docData}");
        final user1 = docData['user1'] as Map<String, dynamic>;
        final user2 = docData['user2'] as Map<String, dynamic>;
        final user3 = docData['user3'] as Map<String, dynamic>;
        final user4 = docData['user4'] as Map<String, dynamic>;
        final user5 = docData['user5'] as Map<String, dynamic>;
        final user6 = docData['user6'] as Map<String, dynamic>;
        /// Join as available user
        if (user1['uid']== uid) {

          //join as user2
          transaction.update(documentReference, {
            'user1.questionCategory': FieldValue.arrayUnion([map]),

          });
        } else if (user2['uid']==uid) {
          //join as user3
          transaction.update(documentReference, {
            'user2.questionCategory': FieldValue.arrayUnion([map]),
          });
        } else if (user3['uid']==uid) {
          //join as user4
          transaction.update(documentReference, {
            'user3.questionCategory': FieldValue.arrayUnion([map]),
          });
        }
        else if (user4['uid']==uid) {
          //join as user4
          transaction.update(documentReference, {
            'user4.questionCategory': FieldValue.arrayUnion([map]),

          });
        }else if (user5['uid']==uid) {
          //join as user4
          transaction.update(documentReference, {
            'user5.questionCategory': FieldValue.arrayUnion([map]),
          });
        }else if (user6['uid']==uid) {
          //join as user4
          transaction.update(documentReference, {
            'user6.questionCategory': FieldValue.arrayUnion([map]),
          });
        }
        else {
          //room is full
          throw BattleRoomException(errorMessageCode: errorCodeRoomIsFull);
        }

        return (
        roomId: documentSnapshot.id

        );
      });
    } catch (e) {
      print(e.toString());
      throw BattleRoomException(errorMessageCode: e.toString());
    }
  }


  Future<void> selectUserCategory(
      String? battleRoomDocumentId) {
    return _battleRoomRemoteDataSource.whichUserSelectBattleCategory(
       battleRoomDocumentId: battleRoomDocumentId

    );
  }
  Future<void> insertNoOfQuestions(
      String? battleRoomDocumentId,String? user,String? categoryId,int noOfQuestions) {

    return _battleRoomRemoteDataSource.insertNoOfQuestions(
        battleRoomDocumentId: battleRoomDocumentId,categoryId: categoryId,userCategory: user,noQuestion: noOfQuestions


    );
  }



  //delete room by id
  Future<void> deleteBattleRoom(
      String? documentId, {
        required bool isGroupBattle,
        String? roomCode,
      }) async {
    try {
      // await _battleRoomRemoteDataSource.deleteBattleRoom(
      //   documentId,
      //
      //   roomCode: roomCode,
      // );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearUsersBattleRoom(
      String? documentId, String userId) async {
    try {
      await _battleRoomRemoteDataSource.clearUsers(
        documentId,userId
      );
    } catch (e) {
      rethrow;
    }
  }
  //get battle room
  Future<Map<String, List<DocumentSnapshot>>> getRoomCreatedByUser(
      String userId,
      ) async {
    try {
      final QuerySnapshot multiUserBattleQuerySnapshot =
      await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .where('createdBy', isEqualTo: userId)
          .get();
      final QuerySnapshot battleQuerySnapshot = await _firebaseFirestore
          .collection(battleRoomCollection)
          .where('createdBy', isEqualTo: userId)
          .get();

      return {
        'battle': battleQuerySnapshot.docs,
        'groupBattle': multiUserBattleQuerySnapshot.docs,
      };
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }
//get room by roomCode (multiUserBattleRoom)
  Future<QuerySnapshot> getMultiUserBattleRoom(
      String? roomCode,
      String? type,
      ) async {
    try {
      final QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(

           multiUserBattleRoomCollection,
      )
          .where('roomCode', isEqualTo: roomCode)
          .get();
      return querySnapshot;
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeUnableToFindRoom);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }
  //delete user from multiple user room
  Future<void> updateUserDataInRoom(
      String? documentId,
      Map<String, dynamic> updatedData, {
        required bool isMultiUserRoom,
      }) async {
    try {
      await _firebaseFirestore
          .collection(

             multiUserBattleRoomCollection
      )
          .doc(documentId)
          .update(updatedData);
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }



  //delete user from multi user battle room (this will be call when user left the game)
  Future<void> deleteUserFromMultiUserRoom(
      int userNumber,
      BattleRoom battleRoom,
      ) async {
    try {
      final updatedData = <String, dynamic>{};
      if (userNumber == 1) {
    //     'name': name,
    // 'uid': id,
    // 'profileUrl': profileUrl,
    // 'isSelectCategory':false,
    // 'categoryId': '',
    // 'categoryName': '',
        //move users to one step ahead
        updatedData['user1'] = {
          'name': battleRoom.user2!.name,
          'isSelectCategory': battleRoom.user2!.isSelecetedCategory,
          'categoryId': battleRoom.user2!.categoryId,
          'categoryName': battleRoom.user2!.categoryName,
          'uid': battleRoom.user2!.uid,
          'profileUrl': battleRoom.user2!.profileUrl,
        };
        updatedData['user2'] = {
          'name': battleRoom.user3!.name,
          'isSelectCategory': battleRoom.user3!.isSelecetedCategory,
          'categoryId': battleRoom.user3!.categoryId,
          'categoryName': battleRoom.user3!.categoryName,
          'uid': battleRoom.user3!.uid,
          'profileUrl': battleRoom.user3!.profileUrl,
        };
        updatedData['user3'] = {
          'name': battleRoom.user4!.name,
          'isSelectCategory': battleRoom.user4!.isSelecetedCategory,
          'categoryId': battleRoom.user4!.categoryId,
          'categoryName': battleRoom.user4!.categoryName,
          'uid': battleRoom.user4!.uid,
          'profileUrl': battleRoom.user4!.profileUrl,
        };
        updatedData['user4'] = {
          'name': battleRoom.user5!.name,
          'isSelectCategory': battleRoom.user5!.isSelecetedCategory,
          'categoryId': battleRoom.user5!.categoryId,
          'categoryName': battleRoom.user5!.categoryName,
          'uid': battleRoom.user5!.uid,
          'profileUrl': battleRoom.user5!.profileUrl,
        };
        updatedData['user5'] = {
          'name': battleRoom.user6!.name,
          'isSelectCategory': battleRoom.user6!.isSelecetedCategory,
          'categoryId': battleRoom.user6!.categoryId,
          'categoryName': battleRoom.user6!.categoryName,
          'uid': battleRoom.user6!.uid,
          'profileUrl': battleRoom.user6!.profileUrl,
        };
        updatedData['user6'] = {
          'name': '',
          'isSelectCategory': false,
          'categoryId':'',
          'categoryName': '',
          'uid': '',
          'profileUrl': '',
        };
      } else if (userNumber == 2) {
        updatedData['user2'] = {
          'name': battleRoom.user3!.name,
          'isSelectCategory': battleRoom.user3!.isSelecetedCategory,
          'categoryId': battleRoom.user3!.categoryId,
          'categoryName': battleRoom.user3!.categoryName,
          'uid': battleRoom.user3!.uid,
          'profileUrl': battleRoom.user3!.profileUrl,
        };
        updatedData['user3'] = {
          'name': battleRoom.user4!.name,
          'isSelectCategory': battleRoom.user4!.isSelecetedCategory,
          'categoryId': battleRoom.user4!.categoryId,
          'categoryName': battleRoom.user4!.categoryName,
          'uid': battleRoom.user4!.uid,
          'profileUrl': battleRoom.user4!.profileUrl,
        };
        updatedData['user4'] = {
          'name': battleRoom.user5!.name,
          'isSelectCategory': battleRoom.user5!.isSelecetedCategory,
          'categoryId': battleRoom.user5!.categoryId,
          'categoryName': battleRoom.user5!.categoryName,
          'uid': battleRoom.user5!.uid,
          'profileUrl': battleRoom.user5!.profileUrl,
        };
        updatedData['user5'] = {
          'name': battleRoom.user6!.name,
          'isSelectCategory': battleRoom.user6!.isSelecetedCategory,
          'categoryId': battleRoom.user6!.categoryId,
          'categoryName': battleRoom.user6!.categoryName,
          'uid': battleRoom.user6!.uid,
          'profileUrl': battleRoom.user6!.profileUrl,
        };
        updatedData['user6'] = {
          'name': '',
          'isSelectCategory': false,
          'categoryId':'',
          'categoryName': '',
          'uid': '',
          'profileUrl': '',
        };
      } else if (userNumber == 3) {
        updatedData['user3'] = {
          'name': battleRoom.user4!.name,
          'isSelectCategory': battleRoom.user4!.isSelecetedCategory,
          'categoryId': battleRoom.user4!.categoryId,
          'categoryName': battleRoom.user4!.categoryName,
          'uid': battleRoom.user4!.uid,
          'profileUrl': battleRoom.user4!.profileUrl,
        };
        updatedData['user4'] = {
          'name': battleRoom.user5!.name,
          'isSelectCategory': battleRoom.user5!.isSelecetedCategory,
          'categoryId': battleRoom.user5!.categoryId,
          'categoryName': battleRoom.user5!.categoryName,
          'uid': battleRoom.user5!.uid,
          'profileUrl': battleRoom.user5!.profileUrl,
        };
        updatedData['user5'] = {
          'name': battleRoom.user6!.name,
          'isSelectCategory': battleRoom.user6!.isSelecetedCategory,
          'categoryId': battleRoom.user6!.categoryId,
          'categoryName': battleRoom.user6!.categoryName,
          'uid': battleRoom.user6!.uid,
          'profileUrl': battleRoom.user6!.profileUrl,
        };
        updatedData['user6'] = {
          'name': '',
          'isSelectCategory': false,
          'categoryId':'',
          'categoryName': '',
          'uid': '',
          'profileUrl': '',
        };
      } else if(userNumber == 4){
        updatedData['user4'] = {
          'name': battleRoom.user5!.name,
          'isSelectCategory': battleRoom.user5!.isSelecetedCategory,
          'categoryId': battleRoom.user5!.categoryId,
          'categoryName': battleRoom.user5!.categoryName,
          'uid': battleRoom.user5!.uid,
          'profileUrl': battleRoom.user5!.profileUrl,
        };
        updatedData['user5'] = {
          'name': battleRoom.user6!.name,
          'isSelectCategory': battleRoom.user6!.isSelecetedCategory,
          'categoryId': battleRoom.user6!.categoryId,
          'categoryName': battleRoom.user6!.categoryName,
          'uid': battleRoom.user6!.uid,
          'profileUrl': battleRoom.user6!.profileUrl,
        };
        updatedData['user6'] = {
          'name': '',
          'isSelectCategory': false,
          'categoryId':'',
          'categoryName': '',
          'uid': '',
          'profileUrl': '',
        };
      }else if(userNumber == 5){
        updatedData['user5'] = {
          'name': battleRoom.user6!.name,
          'isSelectCategory': battleRoom.user6!.isSelecetedCategory,
          'categoryId': battleRoom.user6!.categoryId,
          'categoryName': battleRoom.user6!.categoryName,
          'uid': battleRoom.user6!.uid,
          'profileUrl': battleRoom.user6!.profileUrl,
        };
        updatedData['user6'] = {
          'name': '',
          'isSelectCategory': false,
          'categoryId':'',
          'categoryName': '',
          'uid': '',
          'profileUrl': '',
        };
      }else {
        updatedData['user6'] = {
          'name': '',
          'isSelectCategory': false,
          'categoryId':'',
          'categoryName': '',
          'uid': '',
          'profileUrl': '',
        };
      }
      await _battleRoomRemoteDataSource.updateUserDataInRoom(
        battleRoom.roomId,
        updatedData

      );
    } catch (e) {
      log(e.toString(), name: 'deleteUserFromMultiUserRoom');
    }
  }

  Future<void> startMultiUserQuiz(
      String? battleRoomDocumentId, String? user,String? categoryId) async {
    try {
      await _battleRoomRemoteDataSource.updateUserDataInRoom(
        battleRoomDocumentId,
        {'readyToPlay': true,
        '$user.categoryId':categoryId},


      );
      print("readyToPlay");
    } catch (e) {
      rethrow;
    }
  }

  //All the message related code start from here
  Stream<List<Message>> subscribeToMessages({required String roomId}) {
    return _battleRoomRemoteDataSource
        .subscribeToMessages(roomId: roomId)
        .map((event) {
      if (event.docs.isEmpty) {
        return [];
      } else {
        return event.docs.map(Message.fromDocumentSnapshot).toList();
      }
    });
  }

  //to add messgae
  Future<String> addMessage(Message message) async {
    try {
      return await _battleRoomRemoteDataSource.addMessage(message.toJson());
    } catch (e) {
      throw BattleRoomException(errorMessageCode: e.toString());
    }
  }

  //to delete messgae
  Future<void> deleteMessage(Message message) async {
    try {
      await _battleRoomRemoteDataSource.deleteMessage(message.messageId);
    } catch (e) {
      throw BattleRoomException(errorMessageCode: e.toString());
    }
  }
  Future<void> submitAnswerForMultiUserBattleRoom({
    String? userNumber,
    List<String>? submittedAnswer,
    List<int>? times,
    List<String>? points,
    String? battleRoomDocumentId,
    int? correctAnswers,
    List<bool>? answersResult

  }) async {
    try {

      final submitAnswer = <String, dynamic>{};
      if (userNumber == '1') {
        submitAnswer.addAll({
          'user1.answers': submittedAnswer,
          'user1.correctAnswers': correctAnswers,

          'user1.times':times,
          'user1.answersResult':answersResult,
          'user1.points':points,
        });
      } else if (userNumber == '2') {
        submitAnswer.addAll({
          'user2.answers': submittedAnswer,
          'user2.correctAnswers': correctAnswers,
          'user2.times':times,
          'user2.answersResult':answersResult,
          'user2.points':points,
        });
      } else if (userNumber == '3') {
        submitAnswer.addAll({
          'user3.answers': submittedAnswer,
          'user3.correctAnswers': correctAnswers,
          'user3.times':times,
          'user3.answersResult':answersResult,
          'user3.points':points,
        });
      } else if (userNumber == '4'){
        submitAnswer.addAll({
          'user4.answers': submittedAnswer,
          'user4.correctAnswers': correctAnswers,
          'user4.times':times,
          'user4.answersResult':answersResult,
          'user4.points':points,
        });
      }else if (userNumber == '5'){
        submitAnswer.addAll({
          'user5.answers': submittedAnswer,
          'user5.correctAnswers': correctAnswers,
          'user5.times':times,
          'user5.answersResult':answersResult,
          'user5.points':points,
        });
      }else if (userNumber == '6'){
        submitAnswer.addAll({
          'user6.answers': submittedAnswer,
          'user6.correctAnswers': correctAnswers,
          'user6.times':times,
          'user6.answersResult':answersResult,
          'user6.points':points,
        });
      }

      await _battleRoomRemoteDataSource.submitAnswer(
        battleRoomDocumentId: battleRoomDocumentId,
        submitAnswer: submitAnswer,
        forMultiUser: true,
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<void> addQuestions({

    List<Questions>? questions,
    String? battleRoomDocumentId,


  }) async {
    try {

      final submitAnswer = <String, dynamic>{};

        submitAnswer.addAll({
          'questions': questions!.map((v) => v.toJson()).toList(),
          'user1.questionLoaded': true,

          'user1.totalCurrentQuestions': questions!.length,



          'user2.questionLoaded': true,
          'user2.totalCurrentQuestions': questions!.length,
          'user3.questionLoaded': true,
          'user3.totalCurrentQuestions': questions!.length,
          'user4.questionLoaded': true,
          'user4.totalCurrentQuestions': questions!.length,
          'user5.questionLoaded': true,
          'user5.totalCurrentQuestions': questions!.length,
          'user6.questionLoaded': true,
          'user6.totalCurrentQuestions': questions!.length,
          'readyToPlay': true,
        });

      await _battleRoomRemoteDataSource.addQuestions(
        battleRoomDocumentId: battleRoomDocumentId,
        submitAnswer: submitAnswer,
        forMultiUser: true,
      );
    } catch (e) {
      rethrow;
    }
  }
  Future<void> submitQuestionLoadedeRoom({
    String? userNumber,

    int? questionNo,
    int ? noOfRemainingQuestions,
    String? battleRoomDocumentId,

  }) async {
    try {

      final submitAnswer = <String, dynamic>{};
      if (userNumber == '1') {
        submitAnswer.addAll({
          'user1.questionLoaded': true,
          'user1.totalCurrentQuestions': questionNo,

          'readyToPlay': true,
        });
      } else if (userNumber == '2') {
        submitAnswer.addAll({
          'user2.questionLoaded': true,
          'user2.totalCurrentQuestions': questionNo,
          'readyToPlay': true,
        });
      } else if (userNumber == '3') {
        submitAnswer.addAll({
          'user3.questionLoaded': true,
          'user3.totalCurrentQuestions': questionNo,
          'readyToPlay': true,
        });
      } else if (userNumber == '4'){
        submitAnswer.addAll({
          'user4.questionLoaded': true,
          'user4.totalCurrentQuestions': questionNo,
          'readyToPlay': true,
        });
      }else if (userNumber == '5'){
        submitAnswer.addAll({
          'user5.questionLoaded': true,
          'user5.totalCurrentQuestions': questionNo,
          'readyToPlay': true,
        });
      }else if (userNumber == '6'){
        submitAnswer.addAll({
          'user6.questionLoaded': true,
          'user6.totalCurrentQuestions': questionNo,
          'readyToPlay': true,
        });
      }

      await _battleRoomRemoteDataSource.submitQuestionLoaded(
        battleRoomDocumentId: battleRoomDocumentId,
        submitAnswer: submitAnswer,
        forMultiUser: true,
      );
    } catch (e) {
      rethrow;
    }
  }
  //to delete messgae
  Future<void> deleteMessagesByUserId(String roomId, String by) async {
    try {
      //fetch all messages of given roomId
      final messages =
      await _battleRoomRemoteDataSource.getMessagesByUserId(roomId, by);
      //delete all messages
      for (final element in messages) {
        try {
          await _battleRoomRemoteDataSource.deleteMessage(element.id);
        } catch (e) {
          rethrow;
        }
      }
    } catch (e) {
      throw BattleRoomException(errorMessageCode: e.toString());
    }
  }
}