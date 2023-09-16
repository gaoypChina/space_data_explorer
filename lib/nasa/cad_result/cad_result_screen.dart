import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hrk_logging/hrk_logging.dart';
import 'package:hrk_nasa_apis/hrk_nasa_apis.dart';
import 'package:intl/intl.dart';

import '../../../widgets/app_bar.dart';
import '../../constants/dimensions.dart';
import '../../constants/theme.dart';
import '../../extension/distance.dart';
import '../../extension/velocity.dart';
import '../../globals.dart';
import '../../helper/helper.dart';
import '../../route/settings/bloc/settings_bloc.dart';
import '../../route/settings/bloc/settings_state.dart';
import '../../route/settings/date_format_pattern.dart';
import '../../route/settings/time_format_pattern.dart';
import '../../widgets/directionality_widget.dart';
import 'bloc/cad_result_bloc.dart';
import 'bloc/cad_result_state.dart';
import 'cad_result_route.dart';

class CadResultScreen extends StatelessWidget {
  CadResultScreen({
    super.key,
    required this.l10n,
    required this.routeExtraMap,
    required this.zeroDigit,
  });

  final AppLocalizations l10n;
  final JsonMap routeExtraMap;
  final String zeroDigit;
  // ignore: unused_field
  final _logger = Logger('$appNamePascalCase.CadResultScreen');
  static const String keyPrefix = 'cad_result_screen_';
  static const Key customScrollViewKey = Key('${keyPrefix}scroll_view_key');
  static const Key resultGridKey = Key('${keyPrefix}result_grid_key');
  @visibleForTesting
  static CadResultBloc? cadResultBloc;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CadResultBloc>(
      create: (_) {
        if (flutterTest && cadResultBloc != null) {
          return cadResultBloc!;
        } else {
          return CadResultBloc(
            sbdbCadBody: routeExtraMap['$SbdbCadBody'],
          );
        }
      },
      child: getDirectionality(
        child: Scaffold(
          backgroundColor: AppTheme.pageBackgroundColor,
          body: _getBody(context: context),
        ),
      ),
    );
  }

  Widget _getBody({required BuildContext context}) {
    return CustomScrollView(
      key: customScrollViewKey,
      controller: ScrollController(),
      slivers: [
        getSliverAppBar(
          context: context,
          title: const Text(CadResultRoute.displayName),
          floating: true,
          snap: true,
        ),
        ..._getSliverBody(context: context)
      ],
    );
  }

  List<Widget> _getSliverBody({required BuildContext context}) {
    return [
      const SliverPadding(
        padding: EdgeInsets.only(
          bottom: Dimensions.pagePaddingVertical,
        ),
      ),
      _getGrid(context: context),
      const SliverPadding(
        padding: EdgeInsets.only(
          bottom: Dimensions.pagePaddingVertical,
        ),
      )
    ];
  }

  Widget _getGrid({required BuildContext context}) {
    final gridParameters = getSliverMasonryGridParameters(
      context: context,
      itemExtent: Dimensions.cadQueryItemExtent,
      pagePaddingHorizontal: Dimensions.pagePaddingHorizontal,
    );
    return BlocSelector<CadResultBloc, CadResultState, SbdbCadBody>(
      selector: (state) => state.sbdbCadBody,
      builder: (context, sbdbCadBody) {
        return SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: gridParameters.$1,
          ),
          sliver: SliverMasonryGrid.count(
            key: resultGridKey,
            crossAxisCount: gridParameters.$2,
            childCount: sbdbCadBody.count,
            itemBuilder: (context, index) {
              return getItemWidget(
                context: context,
                sbdbCadBody: sbdbCadBody,
                data: sbdbCadBody.data![index],
              );
            },
          ),
        );
      },
    );
  }

  Widget getItemWidget({
    required BuildContext context,
    required SbdbCadBody sbdbCadBody,
    required SbdbCadData data,
  }) {
    return getItemContainer(
      context: context,
      child: getItemBody(
        context: context,
        sbdbCadBody: sbdbCadBody,
        data: data,
      ),
    );
  }

  Widget getItemContainer({
    required BuildContext context,
    required Widget child,
  }) {
    return Container(
      width: Dimensions.cadQueryItemWidth,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppTheme.queryContainerBorderColor,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(
          Dimensions.cadQueryItemRadius,
        )),
        color: AppTheme.queryContainerColor,
      ),
      padding: const EdgeInsets.all(Dimensions.cadQueryItemPadding),
      margin: const EdgeInsets.all(Dimensions.cadQueryItemMargin),
      child: child,
    );
  }

  Widget getItemBody({
    required BuildContext context,
    required SbdbCadBody sbdbCadBody,
    required SbdbCadData data,
  }) {
    final fields = List<String>.from(sbdbCadBody.rawBody!['fields']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        getItemDetail(
          label: 'Designation:',
          displayValue: data.des,
        ),
        if (fields.contains('fullname'))
          getItemDetail(
            label: 'Fullname:',
            displayValue: data.fullname.toString().trim(),
          ),
        getItemDetail(
          label: 'Orbit ID:',
          displayValue: data.orbitId,
        ),
        getItemDetail(
          label: 'Julian Date:',
          displayValue: '${data.jd} TDB',
        ),
        BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (previous, current) {
            return previous.dateFormatPattern != current.dateFormatPattern ||
                previous.timeFormatPattern != current.timeFormatPattern;
          },
          builder: (context, settingsState) {
            return getItemDetail(
              label: 'Date/Time:',
              displayValue: formatCloseApproachDateTime(
                context: context,
                cd: data.cd,
                dateFormatPattern: settingsState.dateFormatPattern,
                timeFormatPattern: settingsState.timeFormatPattern,
              ),
            );
          },
        ),
        getItemDetail(
          label: 'Time Sigma:',
          displayValue: data.tSigmaF,
        ),
        if (data.body != null)
          getItemDetail(
            label: 'Close-Approach Body:',
            displayValue: data.body!,
          ),
        BlocSelector<SettingsBloc, SettingsState, DistanceUnit>(
          selector: (state) {
            return state.distanceUnit;
          },
          builder: (context, distanceUnit) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getItemDetail(
                  label: 'Distance:',
                  displayValue: data.dist
                      .convert(
                        to: distanceUnit,
                      )
                      .toLocalizedString(l10n),
                ),
                getItemDetail(
                  label: 'Distance Min:',
                  displayValue: data.distMin
                      .convert(
                        to: distanceUnit,
                      )
                      .toLocalizedString(l10n),
                ),
                getItemDetail(
                  label: 'Distance Max:',
                  displayValue: data.distMax
                      .convert(
                        to: distanceUnit,
                      )
                      .toLocalizedString(l10n),
                ),
              ],
            );
          },
        ),
        BlocSelector<SettingsBloc, SettingsState, VelocityUnit>(
          selector: (state) {
            return state.velocityUnit;
          },
          builder: (context, velocityUnit) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                getItemDetail(
                  label: 'Velocity Rel:',
                  displayValue: data.vRel
                      .convert(to: velocityUnit)
                      .toLocalizedString(l10n),
                ),
                getItemDetail(
                  label: 'Velocity Inf:',
                  displayValue: data.vInf != null
                      ? data.vInf!
                          .convert(to: velocityUnit)
                          .toLocalizedString(l10n)
                      : 'null',
                ),
              ],
            );
          },
        ),
        getItemDetail(
          label: 'Absolute Magnitude:',
          displayValue: data.h != null ? '${data.h} H' : 'null',
        ),
        if (fields.contains('diameter'))
          getItemDetail(
            label: 'Diameter:',
            displayValue: data.diameter.toString(),
          ),
        if (fields.contains('diameter_sigma'))
          getItemDetail(
            label: 'Diameter Sigma:',
            displayValue: data.diameterSigma.toString(),
          ),
      ],
    );
  }

  String formatCloseApproachDateTime({
    required BuildContext context,
    required DateTime cd,
    required DateFormatPattern dateFormatPattern,
    required TimeFormatPattern timeFormatPattern,
  }) {
    final locale = Localizations.localeOf(context).toString();
    final dateFormat = DateFormat(dateFormatPattern.pattern, locale);
    final dateTimeStringBuffer = StringBuffer(dateFormat.format(cd));
    dateTimeStringBuffer.write(' ');
    final timeFormat = DateFormat(timeFormatPattern.pattern, locale);
    dateTimeStringBuffer.write(timeFormat.format(cd));
    dateTimeStringBuffer.write(' TDB');
    return dateTimeStringBuffer.toString();
  }

  Widget getItemDetail({
    required String label,
    required String displayValue,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final style = Theme.of(context).textTheme.bodyMedium;
        final labelWidth = getTextPainterLaidout(
          context: context,
          text: label,
          style: style,
        ).width;
        displayValue = displayValue.localizeDigits(toZeroDigit: zeroDigit);
        final displayValueWidth = getTextPainterLaidout(
          context: context,
          text: displayValue,
          style: style,
        ).width;
        final constrainWidth = constraints.constrainWidth();
        // _logger.debug('constraints = $constraints');
        // _logger.debug('constrainWidth() = $constrainWidth');
        // _logger.debug('labelWidth = $labelWidth');
        // _logger.debug('displayValueWidth = $displayValueWidth');
        if (constrainWidth >=
            labelWidth + displayValueWidth + Dimensions.cadResultItemSpacing) {
          // _logger.debug('Will fit');
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: Dimensions.cadResultItemSpacing,
            children: [
              Text(
                label,
                style: style,
              ),
              Text(
                displayValue,
                style: style,
              ),
            ],
          );
        } else {
          // _logger.debug('Will not fit');
          return Column(
            children: [
              SizedBox(
                width: constrainWidth,
                child: Text(
                  label,
                  style: style,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                width: constrainWidth,
                child: Text(
                  displayValue,
                  style: style,
                  textAlign: TextAlign.end,
                ),
              )
            ],
          );
        }
      },
    );
  }
}
