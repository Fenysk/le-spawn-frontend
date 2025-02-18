import 'dart:async';

typedef DebouncedFunction = void Function();

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  void run(DebouncedFunction action) {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
