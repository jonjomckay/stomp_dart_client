import 'dart:async';
import 'dart:html';

import 'package:stomp_dart_client/stomp_channel.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:web_socket_channel/html.dart';

Future<StompChannel> connect(StompConfig config) {
  if (config.useTcpSocket) {
    return Future.error(StompChannelException(
        'Connecting to a TCP socket is not supported when using HTML'));
  }

  final completer = Completer<StompChannel>();
  final webSocket = WebSocket(config.connectUrl)
    ..binaryType = BinaryType.list.value;
  webSocket.onOpen.first.then((value) {
    completer.complete(WebSocketStompChannel(HtmlWebSocketChannel(webSocket)));
  });
  webSocket.onError.first.then((err) {
    completer.completeError(StompChannelException.from(err));
  });

  if (config.connectionTimeout.inMilliseconds > 0) {
    return completer.future.timeout(config.connectionTimeout);
  }

  return completer.future;
}
