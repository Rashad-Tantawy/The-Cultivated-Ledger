import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/primary_button.dart';

/// Login / Sign-in screen.
///
/// Design reference: stitch_v1/login/
///
/// Layout:
///  • Glassmorphism top app bar with logo
///  • Scrollable form area:
///     - "Secure your harvest." display headline
///     - Body subtext
///     - Email + Password inputs (password has Forgot Password link)
///     - "Sign In to Ledger" gradient primary CTA
///     - Divider with "Institutional Access" label
///     - Google + Apple social buttons
///     - "Register an Account" link
///  • Footer copyright text
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // TODO: call auth use-case via Riverpod
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        trailing: null, // no trailing on login
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Add space below the glass app bar (64px height)
              const SizedBox(height: 80),

              // ── Form card ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),

                      // Headline
                      Text(
                        'Secure your\nharvest.',
                        style: AppTextStyles.displayLg.copyWith(
                          fontSize: 40,
                          color: AppColors.onBackground,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Subtext
                      Text(
                        'Access your agricultural portfolio and manage high-yield land investments with precision.',
                        style: AppTextStyles.bodyLg.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Email field
                      AuthTextField(
                        label: 'Email Address',
                        hint: 'farmer@ledger.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Email is required';
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password field header (label + forgot password link)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'PASSWORD',
                            style: AppTextStyles.labelSm.copyWith(
                              color: AppColors.secondary,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: navigate to forgot password
                            },
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.labelMd.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleSignIn(),
                        style: AppTextStyles.bodyMd
                            .copyWith(color: AppColors.onBackground),
                        decoration: const InputDecoration(
                          hintText: '••••••••',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password is required';
                          if (v.length < 6) return 'Min. 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 28),

                      // Primary CTA
                      PrimaryButton(
                        label: 'Sign In to Ledger',
                        onPressed: _handleSignIn,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: 32),

                      // Divider — "Institutional Access"
                      const _DividerWithLabel(label: 'Institutional Access'),
                      const SizedBox(height: 24),

                      // Social buttons
                      Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SocialButton(
                              icon: Icons.apple_rounded,
                              label: 'Apple',
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 36),

                      // Register link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: AppTextStyles.bodyMd.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                            children: [
                              const TextSpan(text: 'New to the Ledger? '),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    // TODO: navigate to sign up
                                  },
                                  child: Text(
                                    'Register an Account',
                                    style: AppTextStyles.bodyMd.copyWith(
                                      color: AppColors.secondary,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.outlineVariant,
                                      decorationThickness: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Footer
                      Center(
                        child: Text(
                          '© 2024 THE CULTIVATED LEDGER • SECURE FINANCIAL OPERATIONS • AGRICULTURAL INTEGRITY',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.labelXs.copyWith(
                            color: AppColors.onSurfaceVariant.withValues(alpha: 0.40),
                            letterSpacing: 0.5,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
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
}

// ── Divider with centre label ────────────────────────────────────────────────

class _DividerWithLabel extends StatelessWidget {
  const _DividerWithLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: AppColors.surfaceContainerHighest,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            label.toUpperCase(),
            style: AppTextStyles.labelXs.copyWith(
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              letterSpacing: 1.5,
            ),
          ),
        ),
        const Expanded(
          child: Divider(
            color: AppColors.surfaceContainerHighest,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

// ── Social button ─────────────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onSurface, size: 22),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLg.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
