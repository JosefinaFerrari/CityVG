import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';

import '/index.dart';
import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier, [Widget? entryPage]) =>
    GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => appStateNotifier.showSplashImage
          ? Builder(
              builder: (context) => Container(
                color: Colors.transparent,
                child: Center(
                  child: Image.asset(
                    'assets/images/welcome.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          : entryPage ?? WelcomeWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => appStateNotifier.showSplashImage
              ? Builder(
                  builder: (context) => Container(
                    color: Colors.transparent,
                    child: Center(
                      child: Image.asset(
                        'assets/images/welcome.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : entryPage ?? WelcomeWidget(),
        ),
        FFRoute(
          name: 'BudgetPage',
          path: '/budgetPage',
          builder: (context, params) => BudgetPageWidget(),
        ),
        FFRoute(
          name: 'Welcome',
          path: '/welcome',
          builder: (context, params) => WelcomeWidget(),
        ),
        FFRoute(
          name: 'PreferencesPage',
          path: '/preferencesPage',
          builder: (context, params) => PreferencesPageWidget(),
        ),
        FFRoute(
          name: 'start',
          path: '/start',
          builder: (context, params) => StartWidget(),
        ),
        FFRoute(
          name: 'MainPage',
          path: '/mainPage',
          builder: (context, params) => MainPageWidget(),
        ),
        FFRoute(
          name: 'tripDetail',
          path: '/tripDetail',
          builder: (context, params) => TripDetailWidget(
            tripRef: params.getParam(
              'tripRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['itineraries_api'],
            ),
            isPreview: params.getParam(
              'isPreview',
              ParamType.bool,
            ),
          ),
        ),
        FFRoute(
          name: 'ScopePage',
          path: '/scopePage',
          builder: (context, params) => ScopePageWidget(),
        ),
        FFRoute(
          name: 'PeoplePage',
          path: '/peoplePage',
          builder: (context, params) => PeoplePageWidget(),
        ),
        FFRoute(
          name: 'Welcome1Copy',
          path: '/welcome1Copy',
          builder: (context, params) => Welcome1CopyWidget(),
        ),
        FFRoute(
          name: 'daypickerPage',
          path: '/daypickerPage',
          builder: (context, params) => DaypickerPageWidget(),
        ),
        FFRoute(
          name: 'Settings',
          path: '/settings',
          builder: (context, params) => SettingsWidget(),
        ),
        FFRoute(
          name: 'FindPage',
          path: '/findPage',
          builder: (context, params) => FindPageWidget(),
        ),
        FFRoute(
          name: 'LoadPage',
          path: '/loadPage',
          builder: (context, params) => LoadPageWidget(),
        ),
        FFRoute(
          name: 'EditItinerary',
          path: '/editItinerary',
          builder: (context, params) => EditItineraryWidget(),
        ),
        FFRoute(
          name: 'placeDetail',
          path: '/placeDetail',
          builder: (context, params) => PlaceDetailWidget(
            attraction: params.getParam(
              'attraction',
              ParamType.DataStruct,
              isList: false,
              structBuilder: AttractionStruct.fromSerializableMap,
            ),
          ),
        ),
        FFRoute(
          name: 'top3',
          path: '/top3',
          builder: (context, params) => Top3Widget(),
        ),
        FFRoute(
          name: 'summaryPage',
          path: '/summaryPage',
          builder: (context, params) => SummaryPageWidget(),
        ),
        FFRoute(
          name: 'mapDirectionsTest',
          path: '/mapDirectionsTest',
          builder: (context, params) => MapDirectionsTestWidget(),
        ),
        FFRoute(
          name: 'Languages',
          path: '/languages',
          builder: (context, params) => LanguagesWidget(),
        ),
        FFRoute(
          name: 'DarkMode2',
          path: '/darkMode2',
          builder: (context, params) => DarkMode2Widget(),
        ),
        FFRoute(
          name: 'BugReport',
          path: '/bugReport',
          builder: (context, params) => BugReportWidget(),
        ),
        FFRoute(
          name: 'AboutUs',
          path: '/aboutUs',
          builder: (context, params) => AboutUsWidget(),
        ),
        FFRoute(
          name: 'SuggestIdeas',
          path: '/suggestIdeas',
          builder: (context, params) => SuggestIdeasWidget(),
        ),
        FFRoute(
          name: 'LoadApi',
          path: '/loadApi',
          builder: (context, params) => LoadApiWidget(),
        ),
        FFRoute(
          name: 'LoadPreferences',
          path: '/loadPreferences',
          builder: (context, params) => LoadPreferencesWidget(),
        ),
        FFRoute(
          name: 'top10',
          path: '/top10',
          builder: (context, params) => Top10Widget(),
        ),
        FFRoute(
          name: 'Welcome1',
          path: '/welcome1',
          builder: (context, params) => Welcome1Widget(),
        ),
        FFRoute(
          name: 'PeoplePageCopy',
          path: '/peoplePageCopy',
          builder: (context, params) => PeoplePageCopyWidget(),
        ),
        FFRoute(
          name: 'SettingsCopy',
          path: '/settingsCopy',
          builder: (context, params) => SettingsCopyWidget(),
        ),
        FFRoute(
          name: 'SuggestIdeasCopy',
          path: '/suggestIdeasCopy',
          builder: (context, params) => SuggestIdeasCopyWidget(),
        ),
        FFRoute(
          name: 'top10Copy',
          path: '/top10Copy',
          builder: (context, params) => Top10CopyWidget(),
        ),
        FFRoute(
          name: 'placeDetailCopy',
          path: '/placeDetailCopy',
          builder: (context, params) => PlaceDetailCopyWidget(
            attraction: params.getParam(
              'attraction',
              ParamType.DataStruct,
              isList: false,
              structBuilder: AttractionStruct.fromSerializableMap,
            ),
          ),
        ),
        FFRoute(
          name: 'tripDetailCopy',
          path: '/tripDetailCopy',
          builder: (context, params) => TripDetailCopyWidget(
            tripRef: params.getParam(
              'tripRef',
              ParamType.DocumentReference,
              isList: false,
              collectionNamePath: ['itineraries_api'],
            ),
          ),
        ),
        FFRoute(
          name: 'Notifications',
          path: '/notifications',
          builder: (context, params) => NotificationsWidget(),
        ),
        FFRoute(
          name: 'Notifications2',
          path: '/notifications2',
          builder: (context, params) => Notifications2Widget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
    List<String>? collectionNamePath,
    StructBuilder<T>? structBuilder,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
      collectionNamePath: collectionNamePath,
      structBuilder: structBuilder,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(key: state.pageKey, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
