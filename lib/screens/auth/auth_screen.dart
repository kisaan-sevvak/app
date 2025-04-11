import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/theme.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isSignUp = false;
  bool _rememberMe = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isSignUp) {
        await context.read<AuthProvider>().signUp(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _locationController.text,
        );
      } else {
        await context.read<AuthProvider>().signIn(
          _emailController.text,
          _passwordController.text,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await firebase_auth.FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAadhaarLogin() async {
    // TODO: Implement Aadhaar login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Aadhaar login coming soon!'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    // Logo and Title
                    Icon(
                      Icons.agriculture,
                      size: 80,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _isSignUp ? 'Create Account'.tr() : 'Welcome Back'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSignUp
                          ? 'Sign up to get started'.tr()
                          : 'Sign in to continue'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    
                    // Login Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (_isSignUp) ...[
                            CustomTextField(
                              controller: _nameController,
                              labelText: 'Name'.tr(),
                              prefixIcon: Icons.person_outline,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              controller: _locationController,
                              labelText: 'Location'.tr(),
                              prefixIcon: Icons.location_on_outlined,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your location'.tr();
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email'.tr(),
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email'.tr();
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email'.tr();
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            controller: _passwordController,
                            labelText: 'Password'.tr(),
                            prefixIcon: Icons.lock_outline,
                            obscureText: !_isPasswordVisible,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password'.tr();
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters'.tr();
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          
                          // Remember Me & Forgot Password
                          if (!_isSignUp) ...[
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                Text('Remember Me'.tr()),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Implement forgot password
                                  },
                                  child: Text('Forgot Password?'.tr()),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                          ],
                          
                          // Sign In Button
                          CustomButton(
                            text: _isSignUp ? 'Sign Up'.tr() : 'Sign In'.tr(),
                            onPressed: _isLoading ? null : _handleSubmit,
                            isLoading: _isLoading,
                          ),
                          const SizedBox(height: 24),
                          
                          // Or Divider
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text('OR'.tr()),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Social Login Buttons
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _isLoading ? null : _handleGoogleSignIn,
                                  icon: Image.asset(
                                    'assets/icons/google.png',
                                    height: 24,
                                  ),
                                  label: Text('Google'.tr()),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _isLoading ? null : _handleAadhaarLogin,
                                  icon: const Icon(Icons.fingerprint),
                                  label: Text('Aadhaar'.tr()),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          
                          // Switch between Sign In & Sign Up
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _isSignUp
                                    ? 'Already have an account?'.tr()
                                    : 'Don\'t have an account?'.tr(),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _isSignUp = !_isSignUp;
                                  });
                                },
                                child: Text(
                                  _isSignUp ? 'Sign In'.tr() : 'Sign Up'.tr(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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