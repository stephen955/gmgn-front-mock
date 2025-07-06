import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/theme/app_theme_context_ext.dart';
import 'widgets/auth_text_field.dart';
import 'package:gmgn_front/router/app_router.dart';
import 'package:gmgn_front/core/theme/app_theme_extensions.dart';
import 'package:gmgn_front/l10n/l10n_extension.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_bloc.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_event.dart';
import 'package:gmgn_front/modules/auth/bloc/auth_state.dart';

@RoutePage()
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isFormValid = false;

  @override
  void dispose() {
    emailController.dispose();
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
        if (state is AuthInitial) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.forgotPasswordSuccess), backgroundColor: Colors.green),
          );
          Navigator.of(context).pop();
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 64),
                      Center(
                        child: Text(
                          l10n.forgotPasswordTitle,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      Form(
                        key: _formKey,
                        onChanged: _onFormChanged,
                        child: Column(
                          children: [
                            AuthTextField(
                              hint: l10n.forgotPasswordEmailHint,
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.forgotPasswordEmailRequired;
                                }
                                if (!RegExp(r'^[\w\-\.\+]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value)) {
                                  return l10n.forgotPasswordEmailInvalid;
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
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: (!isFormValid)
                              ? null
                              : () => _handleForgotPassword(context),
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

  void _handleForgotPassword(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(AuthForgotPasswordRequested(emailController.text.trim()));
  }
}
