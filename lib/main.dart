import 'package:flutter/material.dart';
import 'app.dart';
import 'core/network/network_config.dart';
import 'package:http/http.dart' as http;
import 'package:gmgn_front/modules/auth/services/token_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 配置网络设置
  NetworkConfig.configureCachedNetworkImage();

  final hasValidAuth = await TokenStorageService.hasValidAuth();
  final token = hasValidAuth ? await TokenStorageService.getToken() : null;
  final userId = hasValidAuth ? await TokenStorageService.getUserId() : null;

  runApp(App(initialToken: token, initialUserId: userId));
}

