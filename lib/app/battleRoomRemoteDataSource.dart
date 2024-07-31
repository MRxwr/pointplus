import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:point/domain/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/point_services.dart';
import '../domain/profile_model.dart';
import '../presentation/game_categories/models/questionCategory.dart';
import 'battleRoomException.dart';
import 'constant.dart';
import 'error_message_keys.dart';

class BattleRoomRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore;
  BattleRoomRemoteDataSource(this._firebaseFirestore);
  //While starting app
  static Future<void> deleteBattleRoomCreatedByUser(
      String currentUserId,
      ) async {
    await FirebaseFirestore.instance
        .collection(battleRoomCollection)
        .get()
        .then((value) => null);
  }

  //subscribe to battle room
  Stream<DocumentSnapshot> subscribeToBattleRoom(
      String? battleRoomDocumentId) {

      return _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(battleRoomDocumentId)
          .snapshots();


  }
  Future<void> addQuestions({
    required Map<String, dynamic> submitAnswer,
    required bool forMultiUser,
    String? battleRoomDocumentId,
})async{
    try {



      await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(battleRoomDocumentId)
          .update(submitAnswer);

    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(
        errorMessageCode: errorCodeUnableToSubmitAnswer,
      );
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }


  }
  //submit answer
  Future<void> submitAnswer({
    required Map<String, dynamic> submitAnswer,
    required bool forMultiUser,
    String? battleRoomDocumentId,
  }) async {
    try {
      submitAnswer['isSelectNewCategory']= false;


        await _firebaseFirestore
            .collection(multiUserBattleRoomCollection)
            .doc(battleRoomDocumentId)
            .update(submitAnswer);

    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(
        errorMessageCode: errorCodeUnableToSubmitAnswer,
      );
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }
  Future<void> submitQuestionLoaded({
    required Map<String, dynamic> submitAnswer,
    required bool forMultiUser,
    String? battleRoomDocumentId,
  }) async {
    try {


      await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(battleRoomDocumentId)
          .update(submitAnswer);

    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(
        errorMessageCode: errorCodeUnableToSubmitAnswer,
      );
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  Future<void> startGameFun(String? battleRoomDocumentId,)async{
    Map<String,dynamic> map = {};
    map['readyToPlay']= true;
    await _firebaseFirestore
        .collection(multiUserBattleRoomCollection)
        .doc(battleRoomDocumentId)
        .update(map);

  }



  Future<DocumentSnapshot> createMultiUserBattleRoom({

    String? roomCode,


  }) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String id = sharedPreferences.getString("id")??"";
      Map<String,dynamic> map = {};
      map['id']= id;
      PointServices pointServices = PointServices();
      ProfileModel? profileModel = await pointServices.profile(map);
      String name = profileModel!.data!.user![0].username!;
      String profileUrl = '$TAG_LOGO_URL${profileModel!.data!.user![0].favoTeam!.logo.toString()}';

      final DocumentReference documentReference = await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .add({
        'createdBy': id,
        'totalQuestion':12,
        'roomCode': roomCode,
        'readyToPlay': false,
        'currentCategoryId':"",
        "questionLoaded":false,


        'user1': {
          'name': name,
          'uid': id,

          'profileUrl': profileUrl,
          'isSelectCategory':false,
          'categoryId': '',
          'categoryName': '',
          'totalQuestionsPerUser':0,
          'questionCategory':[],
          'questionLoaded':false,
          'totalCurrentQuestions':0






        },
        'user2': {
          'name': '',
          'uid': '',
          'profileUrl': '',
          'isSelectCategory':false,
          'categoryId': '',
          'categoryName': '',
          'totalQuestionsPerUser':0,
          'questionCategory':[],
          'questionLoaded':false,
          'totalCurrentQuestions':0
        },
        'user3': {
          'name': '',
          'uid': '',
          'profileUrl': '',
          'isSelectCategory':false,
          'categoryId': '',
          'categoryName': '',
          'totalQuestionsPerUser':0,
          'questionCategory':[],
          'questionLoaded':false,
          'totalCurrentQuestions':0
        },
        'user4': {
          'name': '',
          'uid': '',
          'profileUrl': '',
          'isSelectCategory':false,
          'categoryId': '',
          'categoryName': '',
          'totalQuestionsPerUser':0,
          'questionCategory':[],
          'questionLoaded':false,
          'totalCurrentQuestions':0
        },
        'user5': {
          'name': '',
          'uid': '',
          'profileUrl': '',
          'isSelectCategory':false,
          'categoryId': '',
          'categoryName': '',
          'totalQuestionsPerUser':0,
          'questionCategory':[],
          'questionLoaded':false,
          'totalCurrentQuestions':0
        },   'user6': {
          'name': '',
          'uid': '',
          'profileUrl': '',
          'isSelectCategory':false,
          'categoryId': '',
          'categoryName': '',
          'totalQuestionsPerUser':0,
          'questionCategory':[],
          'questionLoaded':false,
          'totalCurrentQuestions':0
        },
        'createdAt': Timestamp.now(),
      });
      return documentReference.get();
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeUnableToCreateRoom);
    } on BattleRoomException catch (e) {
      throw BattleRoomException(errorMessageCode: e.toString());
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

//delete battle room
  Future<void> deleteBattleRoom(
      String? documentId, {

        String? roomCode,
      }) async {
    try {


        await _firebaseFirestore
            .collection(multiUserBattleRoomCollection)
            .doc(documentId)
            .delete();


    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }
  Future<void> clearUsers(
      String? documentId,String userId) async {
    try {

      final DocumentReference documentReference = (await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(documentId)
          .get())
          .reference;

      final documentSnapshot = await documentReference.get();

      print(documentSnapshot.data().toString());

      List<String> users = [];
      final user1Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user1'] as Map<String, dynamic>;
      final user2Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user2'] as Map<String, dynamic>;
      final user3Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user3'] as Map<String, dynamic>;
      final user4Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user4'] as Map<String, dynamic>;
      final user5Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user5'] as Map<String, dynamic>;
      final user6Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user6'] as Map<String, dynamic>;
      String userName ="";


      if (user1Details['uid']== userId.toString() ) {


        userName = 'user1';




      }else if (user2Details['uid']== userId.toString() ) {


        userName = 'user2';



      }else if (user3Details['uid']== userId.toString() ) {


        userName = 'user3';



      }else if (user4Details['uid']== userId.toString() ) {


        userName = 'user4';


      }else if (user5Details['uid']== userId.toString() ) {


        userName = 'user5';



      }else if (user6Details['uid']== userId.toString() ) {


        userName = 'user6';



      }

      Map<String,dynamic> map ={};
      map['currentCategoryId'] = "";






      await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(documentId)
          .update(map);


    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }
  Future<bool> joinBattleRoom({


    String? battleRoomDocumentId,
  }) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String id = sharedPreferences.getString("id")??"";
      Map<String,dynamic> map = {};
      map['id']= id;
      PointServices pointServices = PointServices();
      ProfileModel? profileModel = await pointServices.profile(map);
      String name = profileModel!.data!.user![0].username!;
      String profileUrl = '$TAG_LOGO_URL${profileModel!.data!.user![0].favoTeam!.logo.toString()}';

      final DocumentReference documentReference = (await _firebaseFirestore
          .collection(battleRoomCollection)
          .doc(battleRoomDocumentId)
          .get())
          .reference;

      return FirebaseFirestore.instance.runTransaction((transaction) async {
        //get latest document
        final documentSnapshot = await documentReference.get();
        final user2Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user2'] as Map<String, dynamic>;

        if (user2Details['uid'].toString().isEmpty) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user2.name': name,
            'user2.uid': id,
            'user2.profileUrl': profileUrl,
          });
          return false;
        }
        //user 3

        final user3Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user3'] as Map<String, dynamic>;

        if (user3Details['uid'].toString().isEmpty) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user3.name': name,
            'user3.uid': id,
            'user3.profileUrl': profileUrl,
          });
          return false;
        }
        //user 4
        final user4Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user4'] as Map<String, dynamic>;

        if (user4Details['uid'].toString().isEmpty) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user4.name': name,
            'user4.uid': id,
            'user4.profileUrl': profileUrl,
          });
          return false;
        }
        //user 5
        final user5Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user5'] as Map<String, dynamic>;

        if (user5Details['uid'].toString().isEmpty) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user5.name': name,
            'user5.uid': id,
            'user5.profileUrl': profileUrl,
          });
          return false;
        }
        //user 6

        final user6Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user6'] as Map<String, dynamic>;

        if (user6Details['uid'].toString().isEmpty) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user6.name': name,
            'user6.uid': id,
            'user6.profileUrl': profileUrl,
          });
          return false;
        }
        return true; //search for other room
      });
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeUnableToJoinRoom);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }


Future<void> whichUserSelectBattleCategory({


  String? battleRoomDocumentId,

})async{
  try {

    final DocumentReference documentReference = (await _firebaseFirestore
        .collection(multiUserBattleRoomCollection)
        .doc(battleRoomDocumentId)
        .get())
        .reference;


    final documentSnapshot = await documentReference.get();

    print(documentSnapshot.data().toString());

    List<String> users = [];
    final user1Details = Map<String, dynamic>.from(
      documentSnapshot.data()! as Map<String, dynamic>,
    )['user1'] as Map<String, dynamic>;
    final user2Details = Map<String, dynamic>.from(
      documentSnapshot.data()! as Map<String, dynamic>,
    )['user2'] as Map<String, dynamic>;
    final user3Details = Map<String, dynamic>.from(
      documentSnapshot.data()! as Map<String, dynamic>,
    )['user3'] as Map<String, dynamic>;
    final user4Details = Map<String, dynamic>.from(
      documentSnapshot.data()! as Map<String, dynamic>,
    )['user4'] as Map<String, dynamic>;
    final user5Details = Map<String, dynamic>.from(
      documentSnapshot.data()! as Map<String, dynamic>,
    )['user5'] as Map<String, dynamic>;
    final user6Details = Map<String, dynamic>.from(
      documentSnapshot.data()! as Map<String, dynamic>,
    )['user6'] as Map<String, dynamic>;
    if (user1Details['uid'].toString().isNotEmpty) {
      if(user1Details['categoryId'].toString().isEmpty) {
        users.add('user1');
       }


    }
    if (user2Details['uid'].toString().isNotEmpty) {
       if(user2Details['categoryId'].toString().isEmpty) {
        users.add('user2');
       }


    }
    if (user3Details['uid'].toString().isNotEmpty) {
       if(user3Details['categoryId'].toString().isEmpty) {
        users.add('user3');
       }

    }
    if (user4Details['uid'].toString().isNotEmpty) {
       if(user4Details['categoryId'].toString().isEmpty) {
        users.add('user4');
       }


    }
    if (user5Details['uid'].toString().isNotEmpty) {
       if(user5Details['categoryId'].toString().isEmpty) {
        users.add('user5');
       }

    }
    if (user6Details['uid'].toString().isNotEmpty) {
      if(user6Details['categoryId'].toString().isEmpty) {
        users.add('user6');
       }


    }
    final _random = Random();
    Map<String,dynamic> map ={};
    if(users.isEmpty){
      map['currentCategoryId']='';
      map['currentUser']= user1Details['uid'];
      map['user1.isSelectCategory'] = true;
      map['user2.isSelectCategory'] = false;
      map['user3.isSelectCategory'] = false;
      map['user4.isSelectCategory'] = false;
      map['user5.isSelectCategory'] = false;
      map['user6.isSelectCategory'] = false;
      map['user1.categoryId'] = "";
      map['user2.categoryId'] = "";
      map['user3.categoryId'] = "";
      map['user4.categoryId'] = "";
      map['user5.categoryId'] = "";
      map['user6.categoryId'] = "";
      map['readyToPlay'] = false;
      map['user1.questionLoaded'] = false;
      map['user2.questionLoaded'] = false;
      map['user3.questionLoaded'] = false;
      map['user4.questionLoaded'] = false;
      map['user5.questionLoaded'] = false;
      map['user6.questionLoaded'] = false;
      print("clearMap ---> ${map}");




    }else {
      int randomIndex = _random.nextInt(users.length);
      String user = users[randomIndex];

      String uid = "";
      if (user == 'user1') {
        uid = user1Details['uid'];
      } else if (user == 'user2') {
        uid = user2Details['uid'];
      }
      else if (user == 'user3') {
        uid = user3Details['uid'];
      }
      else if (user == 'user4') {
        uid = user4Details['uid'];
      }
      else if (user == 'user5') {
        uid = user5Details['uid'];
      }
      else if (user == 'user6') {
        uid = user6Details['uid'];
      }

      print("user is ${user}");
      map['currentCategoryId']='';
      map['currentUser']=uid;
      map['$user.isSelectCategory']=true;
      map['readyToPlay']=false;
      map['user1.questionLoaded'] = false;
      map['user2.questionLoaded'] = false;
      map['user3.questionLoaded'] = false;
      map['user4.questionLoaded'] = false;
      map['user5.questionLoaded'] = false;
      map['user6.questionLoaded'] = false;
      print("Map ---> ${map}");
    }
    return    await _firebaseFirestore
        .collection(

      multiUserBattleRoomCollection,
    )
        .doc(battleRoomDocumentId)
        .update(map);

  } on SocketException catch (_) {
    throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
  } on PlatformException catch (_) {
    throw BattleRoomException(errorMessageCode: errorCodeUnableToJoinRoom);
  } catch (_) {
    throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
  }

}

  Future<void> insertNoOfQuestions({


    String? battleRoomDocumentId,
    String? userCategory,
    String? categoryId,
    required int noQuestion

  })async{
    try {

      final DocumentReference documentReference = (await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(battleRoomDocumentId)
          .get())
          .reference;

      final documentSnapshot = await documentReference.get();

      print(documentSnapshot.data().toString());

      List<String> users = [];
      final user1Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user1'] as Map<String, dynamic>;
      final user2Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user2'] as Map<String, dynamic>;
      final user3Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user3'] as Map<String, dynamic>;
      final user4Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user4'] as Map<String, dynamic>;
      final user5Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user5'] as Map<String, dynamic>;
      final user6Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user6'] as Map<String, dynamic>;
      if (user1Details['uid'].toString().isNotEmpty) {

        users.add('user1');



      }
      if (user2Details['uid'].toString().isNotEmpty) {

        users.add('user2');



      }
      if (user3Details['uid'].toString().isNotEmpty) {

        users.add('user3');


      }
      if (user4Details['uid'].toString().isNotEmpty) {

        users.add('user4');



      }
      if (user5Details['uid'].toString().isNotEmpty) {

        users.add('user5');


      }
      if (user6Details['uid'].toString().isNotEmpty) {

        users.add('user6');



      }
      final _random = Random();


      int noOfUsers = users.length;
      print("noOfusers ---> ${users.length}");
      int noOfQuestions = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['totalQuestion'] as int;
      print('noOfQuestions --> $noOfQuestions');

      int noOfQuestionPerUser = noOfQuestions~/noOfUsers;
      int remainig  = noOfQuestions%noOfUsers;

      var randamUser = users[_random.nextInt(users.length)];
      int randamUserQuestion = noOfQuestionPerUser+remainig;
      Map<String,dynamic> map ={};
      for(int i=0;i<users.length;i++){
        if(i == users.length-1){
          map['${users[i]}.totalQuestionsPerUser'] = noOfQuestionPerUser+remainig;
          // map['${users[i]}.categoryId'] = categoryId;
          map['${users[i]}.questionLoaded'] = false;
          // map['${users[i]}.totalCurrentQuestions']= noQuestion;
          if(noQuestion == 0|| (randamUserQuestion-noQuestion == 0)) {
            map['questionLoaded'] = true;
          }else{
            map['questionLoaded'] = false;
          }

          map['readyToPlay']= false;
          map['currentCategoryId'] = categoryId;


        }else {
          map['${users[i]}.questionLoaded'] = false;
          // map['${users[i]}.categoryId'] = categoryId;
          map['${users[i]}.totalQuestionsPerUser'] = noOfQuestionPerUser;
          map['currentCategoryId'] = categoryId;
          // map['${users[i]}.categoryId'] = categoryId;
        }

      }
      final currentUserId = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['currentUser'] as String;


      for(int i =0;i<users.length;i++){
        final userDetails = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['${users[i]}'] as Map<String, dynamic>;
        if(userDetails['uid'] == currentUserId){
          map['${users[i]}.categoryId'] = categoryId;
          break;
        }
      }
      map['isSelectNewCategory'] = true;





  return    await _firebaseFirestore
          .collection(

        multiUserBattleRoomCollection,
      )
          .doc(battleRoomDocumentId)
          .update(map);
      // return _firebaseFirestore.runTransaction((transaction) async {
      //
      //   //get latest document
      //   final documentSnapshot = await documentReference.get();
      //
      //   print(documentSnapshot.data().toString());
      //
      //   List<String> users = [];
      //   final user1Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user1'] as Map<String, dynamic>;
      //   final user2Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user2'] as Map<String, dynamic>;
      //   final user3Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user3'] as Map<String, dynamic>;
      //   final user4Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user4'] as Map<String, dynamic>;
      //   final user5Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user5'] as Map<String, dynamic>;
      //   final user6Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user6'] as Map<String, dynamic>;
      //   if (user1Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user1');
      //
      //
      //
      //   }
      //   if (user2Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user2');
      //
      //
      //
      //   }
      //   if (user3Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user3');
      //
      //
      //   }
      //   if (user4Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user4');
      //
      //
      //
      //   }
      //   if (user5Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user5');
      //
      //
      //   }
      //   if (user6Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user6');
      //
      //
      //
      //   }
      //   final _random = Random();
      //
      //
      //   int noOfUsers = users.length;
      //   print("noOfusers ---> ${users.length}");
      //   int noOfQuestions = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['totalQuestion'] as int;
      //   print('noOfQuestions --> $noOfQuestions');
      //
      //   int noOfQuestionPerUser = noOfQuestions~/noOfUsers;
      //   int remainig  = noOfQuestions%noOfUsers;
      //
      //   var randamUser = users[_random.nextInt(users.length)];
      //   int randamUserQuestion = noOfQuestionPerUser+remainig;
      //   Map<String,dynamic> map ={};
      //   for(int i=0;i<users.length;i++){
      //     if(i == users.length-1){
      //       map['${users[i]}.totalQuestionsPerUser'] = randamUserQuestion;
      //       map['${users[i]}.categoryId'] = categoryId;
      //       map['readyToPlay']= true;
      //
      //
      //     }else {
      //       map['${users[i]}.totalQuestionsPerUser'] = noOfQuestionPerUser;
      //       // map['${users[i]}.categoryId'] = categoryId;
      //     }
      //
      //   }
      //
      //       transaction.update(documentReference,  map);
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //   // final userSelectedDetails = Map<String, dynamic>.from(
      //   //   documentSnapshot.data()! as Map<String, dynamic>,
      //   // )[user] as Map<String, dynamic>;
      //   //
      //   //   //
      //   //   //join as user2
      //   //   transaction.update(documentReference, {
      //   //     '$user.isSelectCategory': true,
      //   //     'readyToPlay':true
      //   //
      //   //   });
      //
      //
      //
      //
      // });
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeUnableToJoinRoom);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }

  }

  Future<void> updateNoOfQuestions({


    String? battleRoomDocumentId,
    String? userCategory,
    String? categoryId,
    String? userId,
    required int questionsNo

  })async{
    try {

      final DocumentReference documentReference = (await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(battleRoomDocumentId)
          .get())
          .reference;

      final documentSnapshot = await documentReference.get();

      print(documentSnapshot.data().toString());

      List<String> users = [];
      final user1Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user1'] as Map<String, dynamic>;
      final user2Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user2'] as Map<String, dynamic>;
      final user3Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user3'] as Map<String, dynamic>;
      final user4Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user4'] as Map<String, dynamic>;
      final user5Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user5'] as Map<String, dynamic>;
      final user6Details = Map<String, dynamic>.from(
        documentSnapshot.data()! as Map<String, dynamic>,
      )['user6'] as Map<String, dynamic>;
      String userName ="";
      int noOfQuestions=0 ;
      if (user1Details['uid']== userId.toString() ) {


        userName = 'user1';
        noOfQuestions =user1Details['totalQuestionsPerUser'];




      }else if (user2Details['uid']== userId.toString() ) {


        userName = 'user2';
        noOfQuestions =user2Details['totalQuestionsPerUser'];



      }else if (user3Details['uid']== userId.toString() ) {


        userName = 'user3';

        noOfQuestions =user3Details['totalQuestionsPerUser'];

      }else if (user4Details['uid']== userId.toString() ) {


        userName = 'user4';
        noOfQuestions =user4Details['totalQuestionsPerUser'];


      }else if (user5Details['uid']== userId.toString() ) {


        userName = 'user5';

        noOfQuestions =user5Details['totalQuestionsPerUser'];

      }else if (user6Details['uid']== userId.toString() ) {


        userName = 'user6';

        noOfQuestions =user6Details['totalQuestionsPerUser'];

      }
      int remaingQuestions = noOfQuestions-questionsNo;
      Map<String,dynamic> map ={};
      map['${userName}.totalQuestionsPerUser'] = remaingQuestions;










      return    await _firebaseFirestore
          .collection(

        multiUserBattleRoomCollection,
      )
          .doc(battleRoomDocumentId)
          .update(map);
      // return _firebaseFirestore.runTransaction((transaction) async {
      //
      //   //get latest document
      //   final documentSnapshot = await documentReference.get();
      //
      //   print(documentSnapshot.data().toString());
      //
      //   List<String> users = [];
      //   final user1Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user1'] as Map<String, dynamic>;
      //   final user2Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user2'] as Map<String, dynamic>;
      //   final user3Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user3'] as Map<String, dynamic>;
      //   final user4Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user4'] as Map<String, dynamic>;
      //   final user5Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user5'] as Map<String, dynamic>;
      //   final user6Details = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['user6'] as Map<String, dynamic>;
      //   if (user1Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user1');
      //
      //
      //
      //   }
      //   if (user2Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user2');
      //
      //
      //
      //   }
      //   if (user3Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user3');
      //
      //
      //   }
      //   if (user4Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user4');
      //
      //
      //
      //   }
      //   if (user5Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user5');
      //
      //
      //   }
      //   if (user6Details['uid'].toString().isNotEmpty) {
      //
      //       users.add('user6');
      //
      //
      //
      //   }
      //   final _random = Random();
      //
      //
      //   int noOfUsers = users.length;
      //   print("noOfusers ---> ${users.length}");
      //   int noOfQuestions = Map<String, dynamic>.from(
      //     documentSnapshot.data()! as Map<String, dynamic>,
      //   )['totalQuestion'] as int;
      //   print('noOfQuestions --> $noOfQuestions');
      //
      //   int noOfQuestionPerUser = noOfQuestions~/noOfUsers;
      //   int remainig  = noOfQuestions%noOfUsers;
      //
      //   var randamUser = users[_random.nextInt(users.length)];
      //   int randamUserQuestion = noOfQuestionPerUser+remainig;
      //   Map<String,dynamic> map ={};
      //   for(int i=0;i<users.length;i++){
      //     if(i == users.length-1){
      //       map['${users[i]}.totalQuestionsPerUser'] = randamUserQuestion;
      //       map['${users[i]}.categoryId'] = categoryId;
      //       map['readyToPlay']= true;
      //
      //
      //     }else {
      //       map['${users[i]}.totalQuestionsPerUser'] = noOfQuestionPerUser;
      //       // map['${users[i]}.categoryId'] = categoryId;
      //     }
      //
      //   }
      //
      //       transaction.update(documentReference,  map);
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //   // final userSelectedDetails = Map<String, dynamic>.from(
      //   //   documentSnapshot.data()! as Map<String, dynamic>,
      //   // )[user] as Map<String, dynamic>;
      //   //
      //   //   //
      //   //   //join as user2
      //   //   transaction.update(documentReference, {
      //   //     '$user.isSelectCategory': true,
      //   //     'readyToPlay':true
      //   //
      //   //   });
      //
      //
      //
      //
      // });
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeUnableToJoinRoom);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }

  }




  Future<void> questionsLoaded(String battleRoomDocumentId,
    String? userId,int noOfQuestions


  )async{
    try {

      final DocumentReference documentReference = (await _firebaseFirestore
          .collection(multiUserBattleRoomCollection)
          .doc(battleRoomDocumentId)
          .get())
          .reference;
//
//       final documentSnapshot = await documentReference.get();
//
//       print(documentSnapshot.data().toString());
//
//       List<String> users = [];
//       final user1Details = Map<String, dynamic>.from(
//         documentSnapshot.data()! as Map<String, dynamic>,
//       )['user1'] as Map<String, dynamic>;
//       final user2Details = Map<String, dynamic>.from(
//         documentSnapshot.data()! as Map<String, dynamic>,
//       )['user2'] as Map<String, dynamic>;
//       final user3Details = Map<String, dynamic>.from(
//         documentSnapshot.data()! as Map<String, dynamic>,
//       )['user3'] as Map<String, dynamic>;
//       final user4Details = Map<String, dynamic>.from(
//         documentSnapshot.data()! as Map<String, dynamic>,
//       )['user4'] as Map<String, dynamic>;
//       final user5Details = Map<String, dynamic>.from(
//         documentSnapshot.data()! as Map<String, dynamic>,
//       )['user5'] as Map<String, dynamic>;
//       final user6Details = Map<String, dynamic>.from(
//         documentSnapshot.data()! as Map<String, dynamic>,
//       )['user6'] as Map<String, dynamic>;
//       String userName ="";
//       if (user1Details['uid']== userId.toString() ) {
//
//
//         userName = 'user1';
//
//
//
//       }else if (user2Details['uid']== userId.toString() ) {
//
//
//         userName = 'user2';
//
//
//
//       }else if (user3Details['uid']== userId.toString() ) {
//
//
//         userName = 'user3';
//
//
//
//       }else if (user4Details['uid']== userId.toString() ) {
//
//
//         userName = 'user4';
//
//
//
//       }else if (user5Details['uid']== userId.toString() ) {
//
//
//         userName = 'user5';
//
//
//
//       }else if (user6Details['uid']== userId.toString() ) {
//
//
//         userName = 'user6';
//
//
//
//       }
//
//
//       Map<String,dynamic> map ={};
//       map['$userName.questionLoaded']=true;
//       map['questionLoaded']= true;
//       map['readyToPlay']= true;
//
// retun _firebaseFirestore.runTransaction

      // return    await _firebaseFirestore
      //     .collection(
      //
      //   multiUserBattleRoomCollection,
      // )
      //     .doc(battleRoomDocumentId)
      //     .update(map);

      return _firebaseFirestore.runTransaction((transaction) async {

        //get latest document
        final documentSnapshot = await documentReference.get();

        print(documentSnapshot.data().toString());

        List<String> users = [];
        final user1Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user1'] as Map<String, dynamic>;
        final user2Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user2'] as Map<String, dynamic>;
        final user3Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user3'] as Map<String, dynamic>;
        final user4Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user4'] as Map<String, dynamic>;
        final user5Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user5'] as Map<String, dynamic>;
        final user6Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user6'] as Map<String, dynamic>;
        String userName ="";
        if (user1Details['uid']== userId.toString() ) {


          userName = 'user1';



        }else if (user2Details['uid']== userId.toString() ) {


          userName = 'user2';



        }else if (user3Details['uid']== userId.toString() ) {


          userName = 'user3';



        }else if (user4Details['uid']== userId.toString() ) {


          userName = 'user4';



        }else if (user5Details['uid']== userId.toString() ) {


          userName = 'user5';



        }else if (user6Details['uid']== userId.toString() ) {


          userName = 'user6';



        }


        Map<String,dynamic> map ={};
        map['$userName.questionLoaded']=true;
        map['$userName.totalCurrentQuestions']= noOfQuestions;
        // map['questionLoaded']= true;
        map['readyToPlay']= true;

            transaction.update(documentReference,  map);
















      });
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeUnableToJoinRoom);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }

  }





  Future<bool> selectBattleCategoryRoom({


    String? battleRoomDocumentId,
    CategoryDataModel? categoryDataModel
  }) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String id = sharedPreferences.getString("id")??"";

      final DocumentReference documentReference = (await _firebaseFirestore
          .collection(battleRoomCollection)
          .doc(battleRoomDocumentId)
          .get())
          .reference;

      return FirebaseFirestore.instance.runTransaction((transaction) async {
        //get latest document
        final documentSnapshot = await documentReference.get();

        final user1Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user1'] as Map<String, dynamic>;

        if (user1Details['uid'].toString() == id) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user1.isSelectCategory': true,
            'user1.categoryId': categoryDataModel!.id,
            'user1.categoryName': categoryDataModel.arTitle,
          });
          return false;
        }
        final user2Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user2'] as Map<String, dynamic>;

        if (user2Details['uid'].toString() == id) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user2.isSelectCategory': true,
            'user2.categoryId': categoryDataModel!.id,
            'user2.categoryName': categoryDataModel.arTitle,
          });
          return false;
        }
        //user 3

        final user3Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user3'] as Map<String, dynamic>;

        if (user3Details['uid'].toString()== id) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user3.isSelectCategory': true,
            'user3.categoryId': categoryDataModel!.id,
            'user3.categoryName': categoryDataModel.arTitle,
          });
          return false;
        }
        //user 4
        final user4Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user4'] as Map<String, dynamic>;

        if (user4Details['uid'].toString()== id) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user4.isSelectCategory': true,
            'user4.categoryId': categoryDataModel!.id,
            'user4.categoryName': categoryDataModel.arTitle,
          });
          return false;
        }
        //user 5
        final user5Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user5'] as Map<String, dynamic>;

        if (user5Details['uid'].toString() == id) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user5.isSelectCategory': true,
            'user5.categoryId': categoryDataModel!.id,
            'user5.categoryName': categoryDataModel.arTitle,
          });
          return false;
        }
        //user 6

        final user6Details = Map<String, dynamic>.from(
          documentSnapshot.data()! as Map<String, dynamic>,
        )['user6'] as Map<String, dynamic>;

        if (user6Details['uid'].toString()== id) {
          //
          //join as user2
          transaction.update(documentReference, {
            'user6.isSelectCategory': true,
            'user6.categoryId': categoryDataModel!.id,
            'user6.categoryName': categoryDataModel.arTitle,
          });
          return false;
        }
        return true; //search for other room
      });
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeUnableToJoinRoom);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }
  Future<QuerySnapshot> getMultiUserBattleRoom(
      String? roomCode,

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

  Stream<QuerySnapshot> subscribeToMessages({required String roomId}) {
    return _firebaseFirestore
        .collection(messagesCollection)
        .where('roomId', isEqualTo: roomId)
        .orderBy(
      'timestamp',
      descending: true,
    )
        .snapshots();
  }

  //add message
  Future<String> addMessage(Map<String, dynamic> data) async {
    try {
      final DocumentReference documentReference =
      await _firebaseFirestore.collection(messagesCollection).add(data);

      return documentReference.id;
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  //delete message
  Future<void> deleteMessage(String messageId) async {
    try {
      await _firebaseFirestore
          .collection(messagesCollection)
          .doc(messageId)
          .delete();
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }

  //to get all messages by it's roomId
  Future<List<DocumentSnapshot>> getMessagesByUserId(
      String roomId,
      String by,
      ) async {
    try {
      final QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(messagesCollection)
          .where('roomId', isEqualTo: roomId)
          .where('by', isEqualTo: by)
          .get();
      return querySnapshot.docs;
    } on SocketException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeNoInternet);
    } on PlatformException catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    } catch (_) {
      throw BattleRoomException(errorMessageCode: errorCodeDefaultMessage);
    }
  }
  //delete user from multiple user room
  Future<void> updateUserDataInRoom(
      String? documentId,
      Map<String, dynamic> updatedData) async {
    try {
      await _firebaseFirestore
          .collection(

             multiUserBattleRoomCollection,
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





}