import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:point/presentation/resources/color_manager.dart';


class ExitGameDialog extends StatelessWidget {
  const ExitGameDialog({super.key, this.onTapYes});

  final VoidCallback? onTapYes;

  @override
  Widget build(BuildContext context) {
    final textStyle =
       TextStyle(
        color: Theme.of(context).colorScheme.onTertiary,
      );


    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      shadowColor: Colors.transparent,
      content: Text(
        context.tr('quizExitLbl')!,
        style: textStyle,
      ),
      actions: [
        CupertinoButton(
          child: Text(
            context.tr('yesBtn')!,
            style: TextStyle(
              color: ColorManager.primary
            ),
          ),
          onPressed: () {
            if (onTapYes != null) {
              onTapYes!();
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          },
        ),
        CupertinoButton(
          onPressed: Navigator.of(context).pop,
          child: Text(
            context.tr('noBtn')!,
            style: TextStyle(
              color: Colors.red,

            ),
          ),
        ),
      ],
    );
  }
}
