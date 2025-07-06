
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// Telegram 登录回调函数类型
typedef TelegramLoginCallback = void Function(Map<String, dynamic> telegramData);

/// Telegram 登录工具类
class TelegramLoginUtil {
  /// Telegram Bot 用户名 - 需要替换为你的实际 bot 用户名
  /// 创建 Bot: https://t.me/BotFather
  static const String botName = 'gmgn_bot'; // 替换为你的实际 bot 用户名
  
  /// 回调域名 - 需要替换为你的实际域名
  /// 开发测试可以使用 localhost 或 ngrok 临时域名
  static const String callbackDomain = 'gmgn.app'; // 替换为你的实际域名
  
  /// 生成 Telegram 登录 URL
  static String generateLoginUrl() {
    final origin = Uri.encodeComponent('https://$callbackDomain');
    return 'https://oauth.telegram.org/auth?bot=$botName&origin=$origin&embed=1&request_access=write';
  }
  
  /// 使用 WebView 进行 Telegram 登录
  static Future<void> loginWithWebView(
    BuildContext context,
    TelegramLoginCallback onLogin,
  ) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TelegramLoginWebView(
          onLogin: onLogin,
        ),
      ),
    );
  }
  
  /// 使用外部浏览器进行 Telegram 登录
  static Future<void> loginWithExternalBrowser(
    BuildContext context,
    TelegramLoginCallback onLogin,
  ) async {
    final loginUrl = generateLoginUrl();
    final uri = Uri.parse(loginUrl);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      
      // 显示提示对话框，告知用户登录后返回应用
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Telegram 登录'),
            content: const Text(
              '请在浏览器中完成 Telegram 登录，然后返回应用。\n\n'
              '注意：当前版本需要手动输入登录信息进行测试。',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('确定'),
              ),
            ],
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('无法打开 Telegram 登录页面')),
        );
      }
    }
  }
  
  /// 验证 Telegram 登录数据格式
  static bool isValidTelegramData(Map<String, dynamic> data) {
    final requiredFields = ['id', 'first_name', 'auth_date', 'hash'];
    return requiredFields.every((field) => data.containsKey(field));
  }
  
  /// 生成测试用的 Telegram 登录数据
  /// 注意：这只是用于开发测试，生产环境应该使用真实的 Telegram 登录
  static Map<String, dynamic> generateTestTelegramData() {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return {
      'id': '123456789',
      'first_name': 'Test',
      'last_name': 'User',
      'username': 'testuser',
      'photo_url': 'https://example.com/photo.jpg',
      'auth_date': now.toString(),
      'hash': 'test_hash_${now}', // 实际应该由 Telegram 生成
    };
  }
  
  /// 显示配置说明对话框
  static void showConfigDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Telegram 登录配置'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('要使用真实的 Telegram 登录，需要：'),
            SizedBox(height: 8),
            Text('1. 创建 Telegram Bot：'),
            Text('   • 访问 https://t.me/BotFather'),
            Text('   • 发送 /newbot 创建新 bot'),
            Text('   • 获取 bot 用户名'),
            SizedBox(height: 8),
            Text('2. 配置回调域名：'),
            Text('   • 开发测试：使用 localhost 或 ngrok'),
            Text('   • 生产环境：使用你的实际域名'),
            SizedBox(height: 8),
            Text('3. 更新配置：'),
            Text('   • 修改 botName 为你的 bot 用户名'),
            Text('   • 修改 callbackDomain 为你的域名'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }
}

/// Telegram 登录 WebView 页面
class TelegramLoginWebView extends StatefulWidget {
  final TelegramLoginCallback onLogin;

  const TelegramLoginWebView({
    required this.onLogin,
    super.key,
  });

  @override
  State<TelegramLoginWebView> createState() => _TelegramLoginWebViewState();
}

class _TelegramLoginWebViewState extends State<TelegramLoginWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _errorMessage = '加载失败: ${error.description}';
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            // 监听回调 URL
            final uri = Uri.parse(request.url);
            if (uri.host == TelegramLoginUtil.callbackDomain && 
                uri.queryParameters.containsKey('id')) {
              // 解析所有参数
              final data = Map<String, dynamic>.from(uri.queryParameters);
              
              // 验证数据格式
              if (TelegramLoginUtil.isValidTelegramData(data)) {
                widget.onLogin(data);
                Navigator.of(context).pop();
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(TelegramLoginUtil.generateLoginUrl()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Telegram 登录'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => TelegramLoginUtil.showConfigDialog(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (_errorMessage != null)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                          _isLoading = true;
                        });
                        _controller.reload();
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
} 