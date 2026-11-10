import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'main_shell.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.startInSignUp = true});

  final bool startInSignUp;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  late bool _isSignUp = widget.startInSignUp;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final user = _isSignUp
          ? await _authService.signUp(
              name: _nameController.text.trim(),
              email: email,
              password: _passwordController.text,
            )
          : await _authService.signIn(
              email: email,
              password: _passwordController.text,
            );
      final userEmail = user.email ?? email;
      final displayName = user.displayName?.trim();
      appState.updateProfile(
        name: displayName == null || displayName.isEmpty
            ? userEmail.split('@').first
            : displayName,
        email: userEmail,
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
      if (mounted) _showAuthError(authErrorMessage(error));
    } on StateError catch (error) {
      if (mounted) _showAuthError(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAuthError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final title = _isSignUp ? 'Buat akun baru' : 'Selamat datang kembali';

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 112,
                      decoration: BoxDecoration(
                        color: AppColors.orangeLight,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.ramen_dining_rounded,
                        size: 52,
                        color: AppColors.orange,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignUp
                          ? 'Mulai rencanakan menu favoritmu bersama ChefMate.'
                          : 'Masuk untuk melanjutkan rencana masakmu.',
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(color: AppColors.muted),
                    ),
                    const SizedBox(height: 24),
                    _AuthModeSelector(
                      isSignUp: _isSignUp,
                      onChanged: (value) {
                        if (!_isLoading) setState(() => _isSignUp = value);
                      },
                    ),
                    const SizedBox(height: 22),
                    if (_isSignUp) ...[
                      TextFormField(
                        key: const Key('auth-name'),
                        controller: _nameController,
                        enabled: !_isLoading,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Nama pengguna',
                          prefixIcon: Icon(Icons.person_outline_rounded),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Nama pengguna wajib diisi.'
                            : null,
                      ),
                      const SizedBox(height: 14),
                    ],
                    TextFormField(
                      key: const Key('auth-email'),
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty) return 'Email wajib diisi.';
                        if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$')
                            .hasMatch(email)) {
                          return 'Format email tidak valid.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      key: const Key('auth-password'),
                      controller: _passwordController,
                      enabled: !_isLoading,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _continue(),
                      decoration: InputDecoration(
                        labelText: 'Kata sandi',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Tampilkan kata sandi'
                              : 'Sembunyikan kata sandi',
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      validator: (value) {
                        final password = value ?? '';
                        if (password.isEmpty) return 'Kata sandi wajib diisi.';
                        if (_isSignUp && password.length < 6) {
                          return 'Kata sandi minimal 6 karakter.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _continue,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(_isSignUp ? 'Daftar' : 'Masuk'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Akunmu diamankan dengan Firebase Authentication.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthModeSelector extends StatelessWidget {
  const _AuthModeSelector({required this.isSignUp, required this.onChanged});

  final bool isSignUp;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        children: [
          _AuthModeButton(
            label: 'Daftar',
            selected: isSignUp,
            onTap: () => onChanged(true),
          ),
          _AuthModeButton(
            label: 'Masuk',
            selected: !isSignUp,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }
}

class _AuthModeButton extends StatelessWidget {
  const _AuthModeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          backgroundColor: selected ? AppColors.orange : Colors.transparent,
          foregroundColor: selected ? Colors.white : AppColors.muted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
