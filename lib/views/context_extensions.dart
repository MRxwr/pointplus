import 'package:flutter/material.dart';
import 'package:point/app/di.dart';

import '../presentation/game_categories/bloc/multiUserBattleRoomCubit.dart';
import '../presentation/game_categories/bloc/quizCategoryCubit.dart';

extension ContextExtensions on BuildContext {
  MultiUserBattleRoomCubit get multiUserBattleRoomCubit => instance<MultiUserBattleRoomCubit>();
  QuizCategoryCubit get quizCategoryCubit => instance<QuizCategoryCubit>();
}