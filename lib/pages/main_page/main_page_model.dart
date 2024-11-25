import '/components/place_card_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'main_page_widget.dart' show MainPageWidget;
import 'package:flutter/material.dart';

class MainPageModel extends FlutterFlowModel<MainPageWidget> {
  ///  Local state fields for this page.

  bool isPresent = true;

  ///  State fields for stateful widgets in this page.

  // Model for placeCard component.
  late PlaceCardModel placeCardModel;

  @override
  void initState(BuildContext context) {
    placeCardModel = createModel(context, () => PlaceCardModel());
  }

  @override
  void dispose() {
    placeCardModel.dispose();
  }
}
