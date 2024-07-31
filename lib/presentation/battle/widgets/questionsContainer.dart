import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tex/flutter_tex.dart';

import '../../../app/constant.dart';
import '../../../app/di.dart';
import '../../../features/settings/settingsCubit.dart';
import '../../../views/ui_utils.dart';
import '../../game_categories/models/questionCategory.dart';
import '../../main/UserDetailsCubit.dart';
import '../models/answerOption.dart';
import 'circularProgressContainer.dart';

import 'latex_answer_options_list.dart';
import 'optionContainer.dart';


class QuestionsContainer extends StatefulWidget {
  const QuestionsContainer({
    required this.submitAnswer,

    required this.guessTheWordQuestionContainerKeys,
    required this.hasSubmittedAnswerForCurrentQuestion,
    required this.currentQuestionIndex,

    required this.questionAnimationController,
    required this.questionContentAnimationController,
    required this.questionContentAnimation,
    required this.questionScaleDownAnimation,
    required this.questionScaleUpAnimation,
    required this.questionSlideAnimation,
    required this.questions,

    required this.timerAnimationController,
    super.key,
    this.showGuessTheWordHint,
    this.audioQuestionContainerKeys,
    this.showAnswerCorrectness,
    this.level,
    this.topPadding,
  });

  final List<GlobalKey> guessTheWordQuestionContainerKeys;

  final List<GlobalKey>? audioQuestionContainerKeys;

  final bool Function() hasSubmittedAnswerForCurrentQuestion;
  final int currentQuestionIndex;
  final void Function(String) submitAnswer;
  final AnimationController questionContentAnimationController;
  final AnimationController questionAnimationController;
  final Animation<double> questionSlideAnimation;
  final Animation<double> questionScaleUpAnimation;
  final Animation<double> questionScaleDownAnimation;
  final Animation<double> questionContentAnimation;
  final List<Questions> questions;

  final double? topPadding;
  final String? level;

  final bool? showAnswerCorrectness;
  final AnimationController timerAnimationController;
  final bool? showGuessTheWordHint;

  @override
  State<QuestionsContainer> createState() => _QuestionsContainerState();
}

class _QuestionsContainerState extends State<QuestionsContainer> {
  List<AnswerOption> filteredOptions = [];
  List<int> audiencePollPercentages = [];

  late double textSize;

  late final bool _isLatex = true;

  @override
  void initState() {
    textSize =
        20;

    super.initState();
  }

  //to get question length
  int getQuestionsLength() {

      return widget.questions.length;

  }

  Widget _buildOptions(Questions question, BoxConstraints constraints) {
    final correctAnswerId = question.correctAnswer!.answerId!.toString();



    ///
    if (_isLatex) {
      return LatexAnswerOptions(
        hasSubmittedAnswerForCurrentQuestion:
        widget.hasSubmittedAnswerForCurrentQuestion,
        submitAnswer: widget.submitAnswer,
        constraints: constraints,
        submittedAnswerId: question.submittedAnswerId!,
        correctAnswerId: correctAnswerId!,
        showAudiencePoll: false,
        showAnswerCorrectness: widget.showAnswerCorrectness!,
        audiencePollPercentages: audiencePollPercentages,
        answerOptions: question.answerOptions!,
      );
    } else {
      return Column(
        children: question.answerOptions!.map((option) {
          return OptionContainer(

            submittedAnswerId: question.submittedAnswerId!,
            showAnswerCorrectness: widget.showAnswerCorrectness!,
            showAudiencePoll: false,
            hasSubmittedAnswerForCurrentQuestion:
            widget.hasSubmittedAnswerForCurrentQuestion,
            constraints: constraints,
            answerOption: option,
            correctOptionId: correctAnswerId!,
            submitAnswer: widget.submitAnswer,

          );
        }).toList(),
      );
    }
  }



  Widget _buildCurrentQuestionIndex() {
    final onTertiary = Theme.of(context).colorScheme.onTertiary;
    return Align(
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '${widget.currentQuestionIndex + 1}',
              style: TextStyle(
                color: onTertiary.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            TextSpan(
              text: ' / ${widget.questions.length}',
              style: TextStyle(color: onTertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionText({
    required String questionText,

  }) {
    return _isLatex
        ? TeXView(

      child: TeXViewDocument(questionText),
      style: TeXViewStyle(
        contentColor: Theme.of(context).colorScheme.onTertiary,
        // backgroundColor: Theme.of(context).backgroundColor,
        sizeUnit: TeXViewSizeUnit.pixels,
        textAlign: TeXViewTextAlign.center,
        fontStyle: TeXViewFontStyle(fontSize: textSize.toInt() + 5),
      ),
    )
        : Text(
      questionText,
      textAlign: TextAlign.center,
      style:
       TextStyle(
          height: 1.125,
          color: Theme.of(context).colorScheme.onTertiary,
          fontSize: textSize,
        ),

    );
  }

  Widget _buildQuestionContainer(
      double scale,
      int index,
      bool showContent,
      BuildContext context,
      ) {
    final child = LayoutBuilder(
      builder: (context, constraints) {



          final question = widget.questions[index];

          final hasImage =
              question.image != null && question.image!.isNotEmpty;

          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),

                    _buildCurrentQuestionIndex(),
                    const SizedBox(),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  child: _buildQuestionText(
                    questionText: question.question!,

                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * (hasImage ? .0175 : .02),
                ),
                if (hasImage)
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: constraints.maxHeight *
                        0.25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InteractiveViewer(
                      boundaryMargin: const EdgeInsets.all(20),
                      child: CachedNetworkImage(
                        placeholder: (_, __) => const Center(
                          child: CircularProgressContainer(),
                        ),
                        imageUrl: TAG_GAME_URL+question.image!,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit:
                                    BoxFit.contain

                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        },
                        errorWidget: (_, i, e) {
                          return Center(
                            child: Icon(
                              Icons.error,
                              color: Theme.of(context).primaryColor,
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                SizedBox(height: constraints.maxHeight * .015),
                _buildOptions(question, constraints),
                const SizedBox(height: 5),
              ],
            ),
          );

      },
    );

    return Container(
      transform: Matrix4.identity()..scale(scale),
      transformAlignment: Alignment.center,
      // padding: const EdgeInsets.symmetric(horizontal: 15.0),
      width: MediaQuery.of(context).size.width *
          UiUtils.questionContainerWidthPercentage,
      height: MediaQuery.of(context).size.height *
          (UiUtils.questionContainerHeightPercentage -
              0.045 * 1.0),
      child: showContent
          ? SlideTransition(
        position: widget.questionContentAnimation.drive(
          Tween<Offset>(
            begin: const Offset(0.5, 0),
            end: Offset.zero,
          ),
        ),
        child: FadeTransition(
          opacity: widget.questionContentAnimation,
          child: child,
        ),
      )
          : const SizedBox(),
    );
  }

  Widget _buildQuestion(int questionIndex, BuildContext context) {
    //
    //if current question index is same as question index means
    //it is current question and will be on top
    //so we need to add animation that slide and fade this question
    if (widget.currentQuestionIndex == questionIndex) {
      return FadeTransition(
        opacity: widget.questionSlideAnimation.drive(
          Tween<double>(begin: 1, end: 0),
        ),
        child: SlideTransition(
          position: widget.questionSlideAnimation.drive(
            Tween<Offset>(begin: Offset.zero, end: const Offset(-1.5, 0)),
          ),
          child: _buildQuestionContainer(1, questionIndex, true, context),
        ),
      );
    }
    //if the question is second or after current question
    //so we need to animation that scale this question
    //initial scale of this question is 0.95

    else if (questionIndex > widget.currentQuestionIndex &&
        (questionIndex == widget.currentQuestionIndex + 1)) {
      return AnimatedBuilder(
        animation: widget.questionAnimationController,
        builder: (context, child) {
          final scale = 0.95 +
              widget.questionScaleUpAnimation.value -
              widget.questionScaleDownAnimation.value;
          return _buildQuestionContainer(scale, questionIndex, false, context);
        },
      );
    }
    //to build question except top 2

    else if (questionIndex > widget.currentQuestionIndex) {
      return _buildQuestionContainer(1, questionIndex, false, context);
    }
    //if the question is already animated that show empty container
    return const SizedBox();
  }

  //to build questions
  List<Widget> _buildQuestions(BuildContext context) {
    final children = <Widget>[];

    //loop terminate condition will be questions.length instead of 4
    for (var i = 0; i < getQuestionsLength(); i++) {
      //add question
      children.add(_buildQuestion(i, context));
    }
    //need to reverse the list in order to display 1st question in top

    return children.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    //Font Size change Lister to change questions font size
    return BlocListener<SettingsCubit, SettingsState>(
      bloc: context.read<SettingsCubit>(),
      listener: (context, state) {
        if (state.settingsModel!.playAreaFontSize != textSize) {
          setState(() {
            textSize =
                context.read<SettingsCubit>().getSettings().playAreaFontSize;
          });
        }
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: _buildQuestions(context),
      ),
    );
  }
}
