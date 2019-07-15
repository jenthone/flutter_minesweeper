import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

abstract class GameEvent {}

class GameResetEvent implements GameEvent {}

class GameOverEvent implements GameEvent {}
