

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:point/api/point_services.dart';
import 'package:point/domain/usecases/categories_usecase.dart';
import 'package:point/domain/usecases/delete_room_usecas.dart';
import 'package:point/domain/usecases/game_details_usecase.dart';
import 'package:point/domain/usecases/game_use_case.dart';
import 'package:point/domain/usecases/join_game_use_case.dart';
import 'package:point/domain/usecases/profile_use_case.dart';
import 'package:point/domain/usecases/questions_usecase.dart';
import 'package:point/domain/usecases/room_usecase.dart';
import 'package:point/domain/usecases/start_game_usecase.dart';
import 'package:point/domain/usecases/sumbit_room_use_case.dart';
import 'package:point/domain/usecases/update_answers_use_case.dart';
import 'package:point/domain/usecases/update_category_usecase.dart';
import 'package:point/domain/usecases/update_questions_use_case.dart';
import 'package:point/domain/usecases/update_users_use_case.dart';
import 'package:point/features/settings/settingsCubit.dart';
import 'package:point/presentation/battle/bloc/QuizCategoryQuestionsCubit.dart';
import 'package:point/presentation/game_categories/bloc/messageCubit.dart';
import 'package:point/presentation/game_categories/bloc/multiUserBattleRoomCubit.dart';
import 'package:point/presentation/game_categories/bloc/questionCubit.dart';
import 'package:point/presentation/game_categories/bloc/quizCategoryCubit.dart';
import 'package:point/presentation/main/UserDetailsCubit.dart';
import 'package:point/presentation/main/game/bloc/game_bloc.dart';
import 'package:point/presentation/main/game/widgets/privateRoom/bloc/private_room_page_blocs.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/answer_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/fire_base_answer_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/game_details_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/quiz_bloc.dart';
import 'package:point/presentation/main/game_bloc/game_view/bloc/timer_bloc.dart';
import 'package:point/presentation/main/game_bloc/result_view/bloc/sumbit_room_bloc.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/game_categories_bloc.dart';
import 'package:point/presentation/main/game_bloc/users_view/bloc/game_users_bloc.dart';

import 'package:point/presentation/main/game_bloc/users_view/bloc/user_profile_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../data/data_source/local_data_source.dart';
import '../data/data_source/remote_data_source.dart';
import '../data/network/app_api.dart';
import '../data/network/dio_factory.dart';
import '../data/network/firebase_services.dart';
import '../data/network/network_info.dart';
import '../data/repository/repository_impl.dart';



import '../domain/repository/repository.dart';
import '../domain/usecases/initialize_questions_use_case.dart';
import '../features/settings/settingsLocalDataSource.dart';
import '../features/settings/settingsRepository.dart';
import '../presentation/battle/bloc/QuizCubit.dart';
import '../presentation/main/game/bloc/game_page_blocs.dart';
import '../presentation/main/game_bloc/users_view/bloc/connection_bloc.dart';
import '../presentation/main/game_bloc/users_view/bloc/game_questions_bloc.dart';
import '../systemConfig/cubits/systemConfigCubit.dart';
import '../systemConfig/system_config_repository.dart';
import 'app_prefrences.dart';
import 'battleRoomRemoteDataSource.dart';
import 'battleRoomRepository.dart';


final instance = GetIt.instance;
Future<void> initAppModule() async {
  // app module, its a module where we put all generic dependencies

  // shared prefs instance
  instance
      .registerLazySingleton<FireStoreServices>(() => FireStoreServices(instance()));

  final sharedPrefs = await SharedPreferences.getInstance();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  instance.registerLazySingleton<FirebaseFirestore>(() => _firebaseFirestore);
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // app prefs instance
  instance
      .registerLazySingleton<BattleRoomRemoteDataSource>(() => BattleRoomRemoteDataSource(instance()));

  instance
      .registerLazySingleton<BattleRoomRepository>(() => BattleRoomRepository(instance(),instance()));
  instance
      .registerLazySingleton<SystemConfigRepository>(() => SystemConfigRepository());
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));
  // network info
  instance.registerLazySingleton<NetworkInfo>(
          () => NetworkInfoImpl(InternetConnectionChecker()));

  // dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();
  //app service client
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // remote data source
  instance.registerLazySingleton<RemoteDataSource>(
          () => RemoteDataSourceImpl(instance<AppServiceClient>()));
  instance.registerLazySingleton<Connectivity>(
          () => Connectivity());

  // local data source
  instance.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl());

  // repository

  instance.registerLazySingleton<Repository>(
          () => RepositoryImpl(instance(), instance(), instance(),instance()));
  instance.registerFactory<RoomUseCase>(() => RoomUseCase(instance()));
  instance.registerFactory<QuizBloc>(() => QuizBloc( timerBloc: instance()));
  instance.registerFactory<FireBaseAnswerBloc>(() => FireBaseAnswerBloc( instance()));
  instance.registerFactory<InitializeQuestionsUseCase>(() => InitializeQuestionsUseCase(instance()));
  instance.registerFactory<UpdateCategoryUsecase>(() => UpdateCategoryUsecase(instance()));
  instance.registerFactory<UpdateAnswersUseCase>(() => UpdateAnswersUseCase(instance()));
  instance.registerFactory<GameBloc>(() => GameBloc(instance()));
  instance.registerFactory<TimerBloc>(() => TimerBloc());
  instance.registerFactory<AnswerBloc>(() => AnswerBloc());
  instance.registerFactory<GameCategoriesBloc>(() => GameCategoriesBloc(instance()));
  instance.registerFactory<GameUseCase>(() => GameUseCase(instance()));
  instance.registerFactory<SumbitRoomUseCase>(() => SumbitRoomUseCase(instance()));
  instance.registerFactory<SumbitRoomBloc>(() => SumbitRoomBloc(instance()));
  instance.registerFactory<JoinGameUseCase>(() => JoinGameUseCase(instance()));
  instance.registerFactory<UpdateQuestionsUseCase>(() => UpdateQuestionsUseCase(instance()));
  instance.registerFactory<DeleteRoomUsecase>(() => DeleteRoomUsecase(instance()));
  instance.registerFactory<UpdateUsersUseCase>(() => UpdateUsersUseCase(instance()));
  instance.registerFactory<GameUsersBloc>(() => GameUsersBloc(instance(),instance(),instance(),instance(),instance(),instance(),instance(),instance(),instance(),instance()));
  instance.registerFactory<ProfileUseCase>(() => ProfileUseCase(instance()));
  instance.registerFactory<UserProfileBloc>(() => UserProfileBloc(instance()));
  instance.registerFactory<StartGameUsecase>(() => StartGameUsecase(instance()));
  instance.registerFactory<GameQuestionsBloc>(() => GameQuestionsBloc(instance()));
  instance.registerFactory<GameDetailsUsecase>(() => GameDetailsUsecase(instance()));
  instance.registerFactory<GameDetailsBloc>(() => GameDetailsBloc(instance(),instance()));
  instance.registerFactory<ConnectivityBloc>(() => ConnectivityBloc(Connectivity()));
  instance.registerFactory<QuestionUseCase>(() => QuestionUseCase(instance()));
  instance.registerFactory<QuizCategoryQuestionCubit>(() => QuizCategoryQuestionCubit(instance()));
  instance.registerFactory<CategoriesUseCase>(() => CategoriesUseCase(instance()));
  instance.registerFactory<GamePageBloc>(() => GamePageBloc(instance()));
  instance.registerFactory<SettingsLocalDataSource>(() => SettingsLocalDataSource());
  instance.registerFactory<SettingsRepository>(() => SettingsRepository(instance()));
  instance.registerFactory<SettingsCubit>(() => SettingsCubit(instance()));
  instance.registerFactory<PrivateRoomBlocs>(() => PrivateRoomBlocs(instance()));
  instance.registerFactory<QuizCategoryCubit>(() => QuizCategoryCubit(instance()));
  instance.registerFactory<SystemConfigCubit>(() => SystemConfigCubit(instance()));
  instance.registerFactory<MessageCubit>(() => MessageCubit(instance()));
  instance.registerFactory<QuizCubit>(() => QuizCubit(instance(),instance()));
  instance.registerFactory<QuestionsCubit>(() => QuestionsCubit(instance(),instance()));
  instance.registerFactory<PointServices>(() => PointServices());

  instance.registerFactory<UserDetailsCubit>(() => UserDetailsCubit(instance()));
  instance.registerFactory<MultiUserBattleRoomCubit>(() => MultiUserBattleRoomCubit(instance(),instance(),instance()));

  // instance.registerFactory<GamePageBloc>(() => GamePageBloc(instance()));
  // instance.registerFactory<GamePageBloc>(() => GamePageBloc(instance()));
}

// initLoginModule() {
//   if (!GetIt.I.isRegistered<RoomUseCase>()) {
//     GetIt.I.allowReassignment = true;
//
//   }
// }

