import 'package:flutter/material.dart';

import '../constants/dimensions.dart';

class QueryItemContainer extends StatelessWidget {
  const QueryItemContainer({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.cadQueryItemWidth,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(
          Dimensions.containerRadius,
        )),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      padding: const EdgeInsets.all(Dimensions.bodyItemPadding),
      margin: const EdgeInsets.all(Dimensions.bodyItemMargin),
      child: child,
    );
  }
}
