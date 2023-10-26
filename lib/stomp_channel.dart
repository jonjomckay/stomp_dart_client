import 'dart:async';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

abstract class StompChannel {
  void add(List<int> data);

  void close();

  StreamSubscription<dynamic> listen(void Function(dynamic event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError});
}

class StompChannelException implements Exception {
  final String? message;

  /// The exception that caused this one, if available.
  final Object? inner;

  StompChannelException([this.message]) : inner = null;

  StompChannelException.from(this.inner) : message = inner.toString();

  @override
  String toString() => message == null
      ? 'StompChannelException'
      : 'StompChannelException: $message';
}


class WebSocketStompChannel extends StompChannel {
  final WebSocketChannel _channel;

  WebSocketStompChannel(this._channel);

  @override
  void add(List<int> data) {
    _channel.sink.add(data);
  }

  @override
  void close() {
    _channel.sink.close();
  }

  @override
  StreamSubscription<dynamic> listen(void Function(dynamic event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _channel.stream.listen(onData, onError: onError, onDone: onDone);
  }
}

class TcpSocketStompChannel extends StompChannel {
  final Socket _socket;

  TcpSocketStompChannel(this._socket);

  @override
  void add(List<int> data) {
    _socket.add(data);
  }

  @override
  void close() {
    _socket.close();
  }

  @override
  StreamSubscription listen(void Function(dynamic event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return _socket.listen(onData, onError: onError, onDone: onDone);
  }
}
