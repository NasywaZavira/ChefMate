import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'main_shell.dart';

/// Halaman Register ("Join Us!").
/// Alur: Landing page -> Register -> MainShell (beranda).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _authService = AuthService();

  bool _hidePassword = true;
  bool _hideConfirm = true;
  bool _agree = false;
  bool _isLoading = false;

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;
  String? _termsError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_isLoading) return;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    final validEmail = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email);

    final nameError = name.isEmpty ? 'Full name is required.' : null;
    final emailError = email.isEmpty
        ? 'Email is required.'
        : (!validEmail ? 'Invalid email format.' : null);
    final passwordError = password.isEmpty
        ? 'Password is required.'
        : (password.length < 6
              ? 'Password must be at least 6 characters.'
              : null);
    final confirmError = confirm.isEmpty
        ? 'Please confirm your password.'
        : (confirm != password ? 'Passwords do not match.' : null);
    final termsError = _agree
        ? null
        : 'You must agree to the Terms and Conditions.';

    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmError = confirmError;
      _termsError = termsError;
    });

    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmError != null ||
        termsError != null) {
      return;
    }

    setState(() => _isLoading = true);
    try {
      final user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
      );
      appState.updateProfile(
        name: user.displayName?.trim().isNotEmpty == true
            ? user.displayName!.trim()
            : name,
        email: user.email ?? email,
        diet: appState.dietPreference,
        budget: appState.dailyBudget,
        spicy: appState.likesSpicy,
      );
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (mounted) _showSoon(authErrorMessage(error));
    } on StateError catch (error) {
      if (mounted) _showSoon(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSoon(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign up with $provider is not available yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 28),
          child: Column(
            children: [
              const Text(
                'Join Us!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Register to get started!',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.orange,
                ),
              ),
              const SizedBox(height: 34),
              _AuthField(
                hint: 'Full Name',
                controller: _nameController,
                errorText: _nameError,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),
              _AuthField(
                hint: 'Email',
                controller: _emailController,
                errorText: _emailError,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _AuthField(
                hint: 'Password',
                controller: _passwordController,
                errorText: _passwordError,
                obscureText: _hidePassword,
                onToggleObscure: () =>
                    setState(() => _hidePassword = !_hidePassword),
              ),
              const SizedBox(height: 16),
              _AuthField(
                hint: 'Confirm Password',
                controller: _confirmController,
                errorText: _confirmError,
                obscureText: _hideConfirm,
                onToggleObscure: () =>
                    setState(() => _hideConfirm = !_hideConfirm),
              ),
              const SizedBox(height: 18),
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => setState(() {
                    _agree = !_agree;
                    if (_agree) _termsError = null;
                  }),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _agree
                                ? AppColors.orange
                                : AppColors.orangeLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _agree
                              ? const Icon(
                                  Icons.check_rounded,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Agree with ',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.orange,
                          ),
                        ),
                        const Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.orange,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_termsError != null)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, left: 2),
                    child: Text(
                      _termsError!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.red,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: const [
                  Expanded(
                    child: Divider(color: AppColors.orange, thickness: 2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: AppColors.orange, thickness: 2),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SocialButton(
                    onTap: () => _showSoon('Google'),
                    child: const _GoogleMark(),
                  ),
                  _SocialButton(
                    onTap: () => _showSoon('Apple'),
                    child: const Icon(
                      Icons.apple,
                      size: 44,
                      color: Colors.black,
                    ),
                  ),
                  _SocialButton(
                    onTap: () => _showSoon('Facebook'),
                    child: const _FacebookMark(),
                  ),
                  _SocialButton(
                    onTap: () => _showSoon('Instagram'),
                    child: const _InstagramMark(),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.orange,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                    child: const Text(
                      'Login Now',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.orange,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kolom isian berwarna peach dengan tulisan orange (sesuai desain).
class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.hint,
    required this.controller,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.onToggleObscure,
  });

  final String hint;
  final TextEditingController controller;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: color == Colors.transparent
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: AppColors.orange,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: AppColors.orange,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.orangeLight,
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.orange,
        ),
        errorText: errorText,
        errorStyle: const TextStyle(fontSize: 12, color: AppColors.red),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 20,
        ),
        border: border(Colors.transparent, 0),
        enabledBorder: border(Colors.transparent, 0),
        focusedBorder: border(AppColors.orange, 1.5),
        errorBorder: border(AppColors.red, 1.2),
        focusedErrorBorder: border(AppColors.red, 1.5),
        suffixIcon: onToggleObscure == null
            ? null
            : IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.orange,
                ),
              ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(width: 52, height: 52, child: Center(child: child)),
    );
  }
}

// Ikon sosial sederhana dibuat dari widget bawaan Flutter (tanpa file gambar).
// Kalau nanti punya file logo asli, ganti dengan Image.asset('assets/images/logo_google.png', width: 40).

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) => const SweepGradient(
        colors: [
          Color(0xFF4285F4),
          Color(0xFF34A853),
          Color(0xFFFBBC05),
          Color(0xFFEA4335),
          Color(0xFF4285F4),
        ],
      ).createShader(rect),
      child: const Text(
        'G',
        style: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FacebookMark extends StatelessWidget {
  const _FacebookMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
        color: Color(0xFF1877F2),
        shape: BoxShape.circle,
      ),
      child: const Text(
        'f',
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.05,
        ),
      ),
    );
  }
}

class _InstagramMark extends StatelessWidget {
  const _InstagramMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFFFEDA77),
            Color(0xFFF58529),
            Color(0xFFDD2A7B),
            Color(0xFF8134AF),
            Color(0xFF515BD4),
          ],
        ),
      ),
      child: const Icon(
        Icons.camera_alt_outlined,
        size: 24,
        color: Colors.white,
      ),
    );
  }
}
