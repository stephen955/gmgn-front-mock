import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final String url;
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  bool _manuallyClosed = false;

  WebSocketClient(this.url);

  void connect() {
    _manuallyClosed = false;
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen(
      _onData,
      onDone: _onDone,
      onError: _onError,
    );
  }

  void _onData(dynamic data) {
    // 处理消息
  }

  void _onDone() {
    if (!_manuallyClosed) {
      _reconnect();
    }
  }

  void _onError(error) {
    if (!_manuallyClosed) {
      _reconnect();
    }
  }

  void _reconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), connect);
  }

  void send(dynamic data) {
    _channel?.sink.add(data);
  }

  void close() {
    _manuallyClosed = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
  }
} 