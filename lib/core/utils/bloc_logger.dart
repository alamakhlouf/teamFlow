

import 'package:bloc/bloc.dart';
import 'package:talker/talker.dart';

class BlocLogger extends BlocObserver {
  final logger = Talker();

  static final BlocLogger globalBlocLogger = BlocLogger._privateConstructor();

  BlocLogger._privateConstructor() ;

  @override
  void onEvent(Bloc bloc, Object? event) {
    logger.info(
        "${bloc.toString()} received a new event : ${event.toString()} ");
    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase bloc) {
    logger.info(
        "${DateTime.now()} | ${bloc.toString()} has been created successfully");
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    logger.info("${bloc.toString()} is closed");
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.error(
        "${bloc.toString()} has faced an error \n"
            "------------- ERROR -------------\n"
            "$error\n"
            "---------- Stack Trace ----------\n"
            "$stackTrace\n"
            "---------------------------------\n");
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    logger.info(
        "${bloc.toString()} updated state from event : ${transition.event}\n"
            "Current State: ${transition.currentState}\n"
            "Next state : ${transition.nextState}");
    super.onTransition(bloc, transition);
  }
}