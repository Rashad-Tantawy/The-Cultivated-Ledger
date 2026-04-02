import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/primary_button.dart';

/// Sign-up / Create Account screen.
///
/// Design reference: stitch_v1/sign_up/
///
/// Layout:
///  • Glassmorphism app bar with logo + "Already have an account? Sign In" link
///  • "Create your account" heading + subtitle
///  • Role selector (Investor / Farmer) — radio cards with primary border on active
///  • Full Name, Email Address, Secure Password inputs
///  • "Create Account" gradient primary CTA
///  • Terms & Privacy note
///  • Trust badges row (Bank-Grade Security, FCA Compliant)
///  • Footer copyright

enum _UserRole { investor, farmer }

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _UserRole _selectedRole = _UserRole.investor;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
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
      appBar: GlassAppBar(
        trailing: GestureDetector(
          onTap: () {
            // TODO: navigate to login
          },
          child: Text(
            'Already have an account? Sign In',
            style: AppTextStyles.labelMd.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 96), // below glass appbar

                // ── Heading ───────────────────────────────────────────
                Text(
                  'Create your account',
                  style: AppTextStyles.headlineLg.copyWith(
                    fontSize: 28,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose your role to begin your cultivation journey.',
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Role selector ─────────────────────────────────────
                Text(
                  'CHOOSE YOUR PATH',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.secondary,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _RoleCard(
                        role: _UserRole.investor,
                        icon: Icons.analytics_outlined,
                        title: 'Investor',
                        subtitle: 'Capitalize on crop yields',
                        isSelected: _selectedRole == _UserRole.investor,
                        onTap: () =>
                            setState(() => _selectedRole = _UserRole.investor),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RoleCard(
                        role: _UserRole.farmer,
                        icon: Icons.agriculture_outlined,
                        title: 'Farmer',
                        subtitle: 'List assets & track growth',
                        isSelected: _selectedRole == _UserRole.farmer,
                        onTap: () =>
                            setState(() => _selectedRole = _UserRole.farmer),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Input fields ──────────────────────────────────────
                AuthTextField(
                  label: 'Full Name',
                  hint: 'E.g. Arthur Greenfield',
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Name is required';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AuthTextField(
                  label: 'Email Address',
                  hint: 'arthur@ledger.com',
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
                AuthTextField(
                  label: 'Secure Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleCreateAccount(),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 8) return 'Minimum 8 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // ── Primary CTA ───────────────────────────────────────
                PrimaryButton(
                  label: 'Create Account',
                  onPressed: _handleCreateAccount,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 16),

                // Terms
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTextStyles.bodyMd.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontSize: 11,
                        height: 1.6,
                      ),
                      children: [
                        const TextSpan(text: 'By signing up, you agree to our '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Terms of Service',
                              style: AppTextStyles.bodyMd.copyWith(
                                fontSize: 11,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: ' and '),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Privacy Policy',
                              style: AppTextStyles.bodyMd.copyWith(
                                fontSize: 11,
                                color: AppColors.secondary,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Trust badges ──────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 18, horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TrustBadge(
                        icon: Icons.lock_outline_rounded,
                        label: 'Bank-Grade\nSecurity',
                      ),
                      SizedBox(width: 40),
                      _TrustBadge(
                        icon: Icons.verified_user_outlined,
                        label: 'FCA\nCompliant',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Footer
                Center(
                  child: Text(
                    '© 2024 THE CULTIVATED LEDGER. ALL RIGHTS RESERVED.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.labelXs.copyWith(
                      color: AppColors.outline.withValues(alpha: 0.6),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Role card ─────────────────────────────────────────────────────────────────

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final _UserRole role;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.surfaceContainerLowest
              : AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.secondary,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: AppTextStyles.headlineSm.copyWith(
                fontSize: 15,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Trust badge ───────────────────────────────────────────────────────────────

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.60,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.onSurface),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: AppTextStyles.labelXs.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
