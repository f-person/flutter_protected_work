library flutter_protected_work;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProtectedWork extends StatefulWidget {
  /// If not [enabled], the [url] is not being checked.
  final bool enabled;

  /// This will be checked for [blockResponse]
  final String url;

  /// If a GET request to the [url] returns [blockResponse],
  /// the [child] will be replaced with [blockMessage].
  final String blockResponse;

  /// The message that will be displayed instead of the [child].
  final String blockMessage;

  /// The [url] will be queried every [checkInterval]
  final Duration checkInterval;

  /// The protected widget.
  ///
  /// It is common to give the root application widget.
  final Widget child;

  const ProtectedWork({
    @required this.url,
    @required this.blockResponse,
    @required this.child,
    @required this.blockMessage,
    this.checkInterval = const Duration(minutes: 1),
    this.enabled = true,
    Key key,
  })  : assert(url != null &&
            blockResponse != null &&
            child != null &&
            blockMessage != null &&
            checkInterval != null &&
            enabled != null),
        super(key: key);

  @override
  _ProtectedWorkState createState() => _ProtectedWorkState();
}

class _ProtectedWorkState extends State<ProtectedWork> {
  bool _shouldProtect = false;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    if (!_shouldProtect) return widget.child;

    return Scaffold(body: Center(child: Text(widget.blockMessage)));
  }

  @override
  void didUpdateWidget(ProtectedWork oldWidget) {
    super.didUpdateWidget(oldWidget);

    // enabled did not change, no need to check the timer
    if (widget.enabled == oldWidget.enabled) return;

    // unprotect the widget
    if (!widget.enabled && _shouldProtect) _shouldProtect = false;

    if (!widget.enabled && (_timer?.isActive ?? false)) {
      _timer.cancel();
    } else if (widget.enabled && !(_timer?.isActive ?? false)) {
      _initializeTimer();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.enabled) _initializeTimer();
  }

  Future<void> _check() async {
    try {
      final response = await http.get(widget.url);
      if (response.body != null &&
          response.body.trim() == widget.blockResponse) {
        _shouldProtect = true;

        if (!mounted) return;
        setState(() {});
      } else if (_shouldProtect) {
        _shouldProtect = false;

        if (!mounted) return;
        setState(() {});
      }
    } catch (e) {
      // Do nothing, empty catch block for spamming the debug log.
    }
  }

  void _initializeTimer() {
    _timer = Timer.periodic(widget.checkInterval, (_) => _check());
  }
}
