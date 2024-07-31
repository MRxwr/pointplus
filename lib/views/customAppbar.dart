import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../presentation/resources/color_manager.dart';
import '../presentation/resources/ui_utils.dart';
import 'customBackButton.dart';
import 'fonts.dart';


class QAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QAppBar({
    required this.title,
    super.key,
    this.roundedAppBar = true,
    this.removeSnackBars = true,
    this.bottom,
    this.bottomHeight = 52,
    this.usePrimaryColor = false,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.onTapBackButton,
    this.elevation,

  });

  final Widget title;

  final double? elevation;
  final TabBar? bottom;
  final bool automaticallyImplyLeading;
  final VoidCallback? onTapBackButton;
  final List<Widget>? actions;
  final bool roundedAppBar;
  final double bottomHeight;
  final bool removeSnackBars;
  final bool usePrimaryColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(

      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: roundedAppBar
            ? colorScheme.background
            : Theme.of(context).scaffoldBackgroundColor,
      ),
      scrolledUnderElevation: roundedAppBar ? elevation : 0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      elevation: elevation ?? (roundedAppBar ? 2 : 0),
      centerTitle: true,
      shadowColor: colorScheme.background.withOpacity(0.4),
      foregroundColor: usePrimaryColor
          ? Theme.of(context).primaryColor
          : colorScheme.onTertiary,
      backgroundColor: roundedAppBar
          ?     ColorManager.primary
          :     ColorManager.primary,
      surfaceTintColor: roundedAppBar
          ? colorScheme.background
          : Theme.of(context).scaffoldBackgroundColor,

      leading: automaticallyImplyLeading
          ? QBackButton(
              onTap: onTapBackButton,
              removeSnackBars: removeSnackBars,
              color: usePrimaryColor ? Theme.of(context).primaryColor : null,
            )
          : const SizedBox(),
      titleTextStyle:
         TextStyle(
          color: usePrimaryColor
              ? Theme.of(context).primaryColor
              : colorScheme.onTertiary,
          fontWeight: FontWeights.bold,
          fontSize: 18,
        ),

      title: title,
      actions: actions,
      bottom: bottom != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(bottomHeight),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal:
                      MediaQuery.of(context).size.width * UiUtils.hzMarginPct,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: colorScheme.onTertiary.withOpacity(0.08),
                ),
                child: bottom,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => bottom == null
      ? const Size.fromHeight(kToolbarHeight)
      : Size.fromHeight(kToolbarHeight + bottomHeight);
}
