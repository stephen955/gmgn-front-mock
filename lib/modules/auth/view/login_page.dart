import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme_context_ext.dart';
import '../utils/telegram_login_util.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_login_button.dart';
import 'package:gmgn_front/router/app_router.dart';
import 'package:gmgn_front/core/theme/app_theme_extensions.dart';
import 'package:gmgn_front/l10n/l10n_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_bloc.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_event.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_state.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../repositories/auth_repository.dart';
import '../models/auth_models.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isFormValid = false;
  bool _obscureText = true; // 密码可见/隐藏开关
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (valid != isFormValid) {
      setState(() {
        isFormValid = valid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.router.replaceAll([const AssetRoute()]);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Material(
        color: Colors.white, // 全屏白色背景
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 24),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 64),
                      Text(
                        l10n.loginTitle,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // —— 输入框表单 ——
                      Form(
                        key: _formKey,
                        onChanged: _onFormChanged,
                        child: Column(
                          children: [
                            // 邮箱
                            AuthTextField(
                              hint: l10n.loginEmailHint,
                              controller: emailController,
                              validator: (v) {
                                if (v == null || v.isEmpty) return l10n.loginEmailRequired;
                                if (!RegExp(r'^[\w\-\.\+]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v)) {
                                  return l10n.loginEmailInvalid;
                                }
                                return null;
                              },
                              fillColor: const Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(8),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFBFC2CC),
                              ),
                              suffixIcon: null,
                            ),
                            const SizedBox(height: 16),
                            // 密码
                            AuthTextField(
                              hint: l10n.loginPasswordHint,
                              controller: passwordController,
                              obscureText: _obscureText,
                              validator: (v) {
                                if (v == null || v.isEmpty) return l10n.loginPasswordRequired;
                                if (v.length < 6) return l10n.loginPasswordTooShort;
                                return null;
                              },
                              fillColor: const Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(6),
                              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                              hintStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFBFC2CC),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText ? Icons.visibility_off : Icons.visibility,
                                  size: 20,
                                  color: const Color(0xFFBFC2CC),
                                ),
                                onPressed: () => setState(() => _obscureText = !_obscureText),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // —— 错误信息显示 ——
                      if (_errorMessage != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border.all(color: Colors.red.shade200),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      // —— 下一步 按钮 ——
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            disabledBackgroundColor: const Color(0xFFF2F3F5),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  '下一步',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF333333),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // —— 忘记密码 & 注册 ——
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () => context.router.push(const ForgotPasswordRoute()),
                            child: const Text(
                              '忘记密码?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFFBFC2CC),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text(
                                '还没有账号?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFBFC2CC),
                                ),
                              ),
                              const SizedBox(width: 2),
                              TextButton(
                                onPressed: ()=> context.router.push(const RegisterRoute()),
                                child: const Text(
                                  '立即注册',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF00C08B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // —— OR 分割线 ——
                      Row(
                        children: const [
                          Expanded(child: Divider(color: Color(0xFFF2F3F5), thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFBFC2CC),
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Color(0xFFF2F3F5), thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // —— Apple 登录 ——
                      SocialLoginButton(
                        icon: Icons.apple,
                        label: '通过 Apple 登录',
                        onPressed: () => _handleAppleLogin(context),
                      ),
                      const SizedBox(height: 16),
                      // —— Telegram 登录 ——
                      SocialLoginButton(
                        icon: Icons.send,
                        label: '连接 Telegram',
                        onPressed: () => _handleTelegramLogin(context),
                      ),
                      const SizedBox(height: 32),
                      // —— 用户信息显示区域 ——
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          final userInfo = userProvider.currentUser;
                          
                          if (userInfo != null) {
                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                border: Border.all(color: Colors.green.shade200),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    '当前用户信息:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('用户ID: ${userInfo.userId}'),
                                  Text('用户名: ${userInfo.username}'),
                                  Text('邮箱: ${userInfo.email}'),
                                  if (userInfo.walletAddress != null)
                                    Text('钱包地址: ${userInfo.walletAddress}'),
                                  if (userInfo.balance != null)
                                    Text('余额: ${userInfo.balance} ${userInfo.balanceSymbol ?? ''}'),
                                ],
                              ),
                            );
                          }
                          
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthLoginRequested(
      emailController.text.trim(),
      passwordController.text,
    ));
  }

  Future<void> _handleAppleLogin(BuildContext context) async {
    context.read<AuthBloc>().add(AuthAppleLoginRequested());
  }

  Future<void> _handleTelegramLogin(BuildContext context) async {
    if (kIsWeb) {
      // Web 端：直接跳转 Telegram 登录页面
      final telegramUrl = 'https://oauth.telegram.org/auth?bot_id=YOUR_BOT_ID&request_access=write';
      if (await canLaunchUrl(Uri.parse(telegramUrl))) {
        await launchUrl(Uri.parse(telegramUrl));
      }
    } else {
      // 移动端：使用 Telegram 登录工具
      await TelegramLoginUtil.loginWithWebView(
        context,
        (telegramData) {
          context.read<AuthBloc>().add(AuthTelegramLoginRequested(telegramPayload: telegramData));
        },
      );
    }
  }
}