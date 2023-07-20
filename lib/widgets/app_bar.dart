import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../config/config.dart';
import '../globals.dart';
import '../route/home/home_route.dart' hide $SettingsRouteExtension;
import '../route/settings/settings_route.dart';

const Key settingsButtonKey = Key('settings_button');

AppBar getAppBar({
  Key? key,
  required BuildContext context,
  Widget? leading,
  Widget? title,
  List<Widget>? actions,
  Color? backgroundColor,
}) {
  if (leading == null) {
    String location = GoRouterState.of(context).matchedLocation;
    switch (location) {
      // Routes which doesn't need leading BackButton
      case HomeRoute.relativePath:
        break;
      default:
        leading = getAppBarBackButton(context: context);
    }
  }

  actions ??= getDefaultAppBarActions(context: context);

  return AppBar(
    key: key,
    leading: leading,
    title: title,
    actions: actions,
    backgroundColor:
        backgroundColor ?? Theme.of(context).colorScheme.inversePrimary,
  );
}

List<Widget> getDefaultAppBarActions({required BuildContext context}) {
  String location = GoRouterState.of(context).matchedLocation;
  return <Widget>[
    if (location != SettingsRoute.path) getSettingsAction(context: context)
  ];
}

Widget getSettingsAction({required BuildContext context}) {
  return IconButton(
    key: settingsButtonKey,
    icon: const Icon(Icons.settings),
    onPressed: () {
      GoRouter.of(context).push(SettingsRoute.path, extra: getRouteExtra());
    },
  );
}
