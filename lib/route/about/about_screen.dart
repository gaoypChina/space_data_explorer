// ignore_for_file: directives_ordering

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hrk_logging/hrk_logging.dart';
import 'package:url_launcher/link.dart';

import '../../analytics/analytics.dart';
import '../../config/config.dart';
import '../../constants/assets.dart';
import '../../constants/constants.dart';
import '../../constants/dimensions.dart';
import '../../constants/labels.dart';
import '../../globals.dart';
import '../../helper/helper.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/image_widget.dart';
import '../../widgets/link_wrap.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({
    super.key,
    required this.title,
    required this.l10n,
  });

  final String title;
  final AppLocalizations l10n;
  // ignore: unused_field
  final _logger = Logger('$appNamePascalCase.AboutScreen');
  static const String keyPrefix = 'about_screen_';
  static const Key scaffoldKey = Key('${keyPrefix}scaffold_key');
  static const Key listViewKey = Key('${keyPrefix}list_view_key');
  static const Key licenseButtonKey = Key('${keyPrefix}license_button_key');
  static const Key linktreeUriKey = Key('${keyPrefix}linktree_key');
  static const Key sourceUriKey = Key('${keyPrefix}source_key');
  static const Key googlePlayStoreBadgeKey =
      Key('${keyPrefix}google_play_store_badge_key');
  static const Key appleAppStoreBadgeKey =
      Key('${keyPrefix}apple_app_store_badge_key');
  static const Key webAppUriKey = Key('${keyPrefix}web_app_key');

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: getAppBar(
          context: context,
          title: Tooltip(
            message: title,
            child: Text(title),
          ),
        ),
        body: _getBody(context: context),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }

  Widget _getBody({required BuildContext context}) {
    final scrollableContents = _getScrollableContents(context: context);
    return ListView.separated(
      key: listViewKey,
      itemCount: scrollableContents.length,
      itemBuilder: (context, index) {
        return scrollableContents[index];
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: Dimensions.bodyItemSpacer);
      },
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 16,
      ),
    );
  }

  List<Widget> _getScrollableContents({required BuildContext context}) {
    return [
      _getAppIcon(),
      _getAppText(context: context),
      _getVersion(context: context),
      _getAuthor(context: context),
      _getLinktreeText(context: context),
      _getMadeWithLoveText(context: context),
      getLabelLinkInkWellWrap(
        context: context,
        text: l10n.source,
        uri: Constants.sourceRepoUrl,
        inkWellKey: sourceUriKey,
      ),
      _getMobileStoreBadges(context: context),
      if (!kIsWeb) _getWebApp(context: context),
      _getLicenseButton(context: context),
    ];
  }

  Widget _getAppIcon() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/app-icons/app-icon.png',
          width: 96,
          height: 96,
        ),
      ),
    );
  }

  Widget _getAppText({required BuildContext context}) {
    return Center(
      child: Text(
        l10n.spaceDataExplorer,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _getVersion({required BuildContext context}) {
    final String completeVersion = getCompleteVersion();
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '${l10n.version}: ',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          completeVersion,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getAuthor({required BuildContext context}) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '${l10n.author}: ',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.authorNameAka,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _getLinktreeText({required BuildContext context}) {
    return Center(
      child: Link(
        uri: Constants.linktreeUrl,
        target: LinkTarget.blank,
        builder: (context, followLink) {
          return InkWell(
            key: linktreeUriKey,
            onTap: () {
              Analytics.logSelectExternalUrl(uri: Constants.linktreeUrl);
              followLink!();
            },
            child: Text(
              Constants.linktreeUrl.toString(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.blue,
                  ),
            ),
          );
        },
      ),
    );
  }

  Widget _getMadeWithLoveText({required BuildContext context}) {
    return Center(
      child: Text(
        'Made with 💙 using Flutter',
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _getGooglePlayStoreBadge({required BuildContext context}) {
    return Link(
      uri: Constants.googlePlayStoreUrl,
      target: LinkTarget.blank,
      builder: (context, followLink) {
        return InkWell(
          key: googlePlayStoreBadgeKey,
          onTap: () {
            Analytics.logSelectExternalUrl(uri: Constants.googlePlayStoreUrl);
            followLink!();
          },
          child: getImageWidget(
            assetName: AppAssets.googlePlayStoreBadge,
            semanticLabel: Labels.googlePlayStoreBadge,
            height: 72,
          ),
        );
      },
    );
  }

  Widget _getAppleAppStoreBadge({required BuildContext context}) {
    return Link(
      uri: Constants.appleAppStoreUrl,
      target: LinkTarget.blank,
      builder: (context, followLink) {
        return InkWell(
          key: appleAppStoreBadgeKey,
          onTap: () {
            Analytics.logSelectExternalUrl(uri: Constants.appleAppStoreUrl);
            followLink!();
          },
          child: getImageWidget(
            // assetName: Theme.of(context).brightness == Brightness.dark
            //     ? AppAssets.appleAppStoreBlackBadge
            //     : AppAssets.appleAppStoreWhiteBadge,
            assetName: AppAssets.appleAppStoreBlackBadge,
            semanticLabel: Labels.appleAppStoreBadge,
            height: 48,
          ),
        );
      },
    );
  }

  Wrap _getMobileStoreBadges({required BuildContext context}) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (kIsWeb || defaultTargetPlatform != TargetPlatform.android)
          _getGooglePlayStoreBadge(context: context),
        if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS)
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: _getAppleAppStoreBadge(context: context),
          ),
      ],
    );
  }

  Widget _getWebApp({required BuildContext context}) {
    final Uri url = webAppUrl;
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          '${l10n.webApp}: ',
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        InkWell(
          key: webAppUriKey,
          onTap: () {
            Analytics.logSelectExternalUrl(uri: url);
            copyToClipboard(
              context: context,
              text: url.toString(),
            );
          },
          child: Text(
            url.toString(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
          ),
        ),
      ],
    );
  }

  Widget _getLicenseButton({required BuildContext context}) {
    return Center(
      child: FilledButton(
        key: licenseButtonKey,
        child: Text(
          MaterialLocalizations.of(context).viewLicensesButtonLabel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          FirebaseAnalytics.instance.logScreenView(
            screenName: Labels.licenses,
            screenClass: 'LicensePage',
          );
          // context.go(
          //   LicenseRoute.path,
          //   extra: getRouteExtraMap(),
          // );
          showLicensePage(
            context: context,
            applicationName: l10n.spaceDataExplorer,
            applicationVersion: getCompleteVersion(),
            useRootNavigator: true,
          );
        },
      ),
    );
  }
}
