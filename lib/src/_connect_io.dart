import 'dart:async';
import 'dart:io';

import 'package:stomp_dart_client/stomp_channel.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:web_socket_channel/io.dart';

Future<StompChannel> connect(StompConfig config) async {
  try {
    if (config.useTcpSocket) {
      var uri = Uri.parse(config.connectUrl);

      var tcpSocket = await Socket.connect(uri.host, uri.port,
          timeout: config.connectionTimeout.inMilliseconds > 0 ? config.connectionTimeout : null);

      return TcpSocketStompChannel(tcpSocket);
    } else {
      var webSocket = WebSocket.connect(
        config.connectUrl,
        headers: config.webSocketConnectHeaders,
      );
      if (config.connectionTimeout.inMilliseconds > 0) {
        webSocket = webSocket.timeout(config.connectionTimeout);
      }
      return WebSocketStompChannel(IOWebSocketChannel(await webSocket));
    }
  } on SocketException catch (err) {
    throw StompChannelException.from(err);
  }
}
