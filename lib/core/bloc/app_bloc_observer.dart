import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/helpers/app_logger.dart';

/// Global BLoC observer for debugging
class AppBlocObserver extends BlocObserver {
  final _logger = AppLogger('BlocObserver');

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _logger.debug('Created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _logger.info('Event: ${bloc.runtimeType} | $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    _logger.debug(
      'Change: ${bloc.runtimeType} | ${change.currentState} → ${change.nextState}',
    );
  }

  // @override
  // void onTransition(Bloc bloc, Transition transition) {
  //   super.onTransition(bloc, transition);
  //   _logger.info(
  //     'Transition: ${bloc.runtimeType} | ${transition.currentState} → ${transition.nextState}',
  //   );
  // }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _logger.error('Error in ${bloc.runtimeType}', error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _logger.debug('Closed: ${bloc.runtimeType}');
  }
}
