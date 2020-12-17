import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service/room/room_service.dart';
import 'counter_event.dart';
import 'counter_state.dart';

/// Cubit to hold main count.
class CounterBloc extends Bloc<CounterEvent, CounterState> {
  final RoomService _roomService;

  Timer _timer;

  /// Cubit to hold main count.
  CounterBloc({@required RoomService roomService})
      : _roomService = roomService,
        super(const LoadingCounterState()) {
    _roomService.valueStream.listen((value) {
      add(ReceivedChangeCounterEvent(value));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event is ReceivedChangeCounterEvent) {
      yield* _mapReceivedChangeToState(event);
    }
    if (event is ModifyCounterEvent) {
      yield* _mapModifyToState(event);
    }
    if (event is SetCounterEvent) {
      yield* _mapSetToState(event);
    }
    if (event is DebounceEndedEvent) {
      yield* _mapDebounceEndedToState(event);
    }
  }

  Stream<CounterState> _mapReceivedChangeToState(
      ReceivedChangeCounterEvent event) async* {
    if (state is DebouncedCounterState) {
      yield DebouncedCounterState(
          (state as DebouncedCounterState).value, event.value);
    } else {
      yield LiveCounterState(event.value);
    }
  }

  Stream<CounterState> _mapModifyToState(ModifyCounterEvent event) async* {
    if (state is! LiveCounterState) {
      return;
    } else {
      final currentState = (state as LiveCounterState).live;
      final newState = currentState
          .asMap()
          .map((key, value) {
            if (key == event.index) {
              return MapEntry(
                key,
                (value + event.change < 0) ? 0 : value + event.change,
              );
            } else {
              return MapEntry(key, value);
            }
          })
          .values
          .toList();
      yield DebouncedCounterState(newState, newState);
      _resetDebounceTimer();
      _roomService.modifyValue(event.index, event.change);
    }
  }

  Stream<CounterState> _mapSetToState(SetCounterEvent event) async* {
    _roomService.setValue(event.index, event.value);
  }

  Stream<CounterState> _mapDebounceEndedToState(
      DebounceEndedEvent event) async* {
    yield LiveCounterState(event.value);
  }

  void _resetDebounceTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: 200), _debounceDelayEnded);
  }

  void _debounceDelayEnded() {
    if (state is LiveCounterState) {
      add(DebounceEndedEvent((state as LiveCounterState).live));
    }
  }
}
