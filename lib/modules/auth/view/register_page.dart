import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
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

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  @override
  void dispose() {
    emailCtrl.dispose();
    usernameCtrl.dispose();
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
        // 这里假设注册成功后 AuthState 变为 AuthInitial 或自定义 AuthRegisterSuccess
        if (state is AuthInitial) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.registerSuccess), backgroundColor: context.success),
          );
          context.router.push(const LoginRoute());
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Material(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 24),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(height: 64),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.registerTitle,
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
                            // 用户名
                            AuthTextField(
                              hint: l10n.registerUsernameHint,
                              controller: usernameCtrl,
                              validator: (v) {
                                if (v == null || v.isEmpty) return l10n.registerUsernameRequired;
                                if (v.length < 3) return l10n.registerUsernameTooShort;
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
                            // 邮箱
                            AuthTextField(
                              hint: l10n.registerEmailHint,
                              controller: emailCtrl,
                              validator: (v) {
                                if (v == null || v.isEmpty) return l10n.registerEmailRequired;
                                if (!RegExp(r'^[\w\-\.\+]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(v)) {
                                  return l10n.registerEmailInvalid;
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
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // —— 下一步 按钮 ——
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: (!isFormValid)
                              ? null
                              : () => _handleRegister(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            disabledBackgroundColor: const Color(0xFFF2F3F5),
                            disabledForegroundColor: const Color(0xFFBFC2CC),
                          ),
                          child: const Text(
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
                      // —— 已有账号登录 ——
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '已有账号?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFBFC2CC),
                            ),
                          ),
                          const SizedBox(width: 2),
                          TextButton(
                            onPressed: () => context.router.push(const LoginRoute()),
                            child: const Text(
                              '立即登录',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF00C08B),
                              ),
                            ),
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

  void _handleRegister(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthRegisterRequested(
      usernameCtrl.text.trim(),
      emailCtrl.text.trim(),
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