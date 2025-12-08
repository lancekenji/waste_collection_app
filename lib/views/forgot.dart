import 'package:flutter/material.dart';
import 'login.dart';
import '../controllers/forgot_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _userController = TextEditingController();
  final ForgotController _controller = ForgotController();
  bool _loading = false;

  void _handleForgotPassword() async {
    if (_userController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFF004aad)),
      ),
    );

    setState(() => _loading = true);
    
    final result = await _controller.requestPasswordReset(
      _userController.text.trim(),
    );
    
    setState(() => _loading = false);

    if (mounted) {
      Navigator.pop(context);
    }

    if (result['success'] == true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Password reset link sent'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginView()),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to send reset link'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -150,
              left: 0,
              right: 0,
              height: 500,
              child: const Icon(
                Icons.lock,
                size: 100,
                color: Color(0xFF004aad),
              ),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      Text(
                        "Forgot Password?",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004aad),
                        ),
                      ),
                      Text(
                        "No worries, we\'ll send you reset instructions",
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF004aad),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 32.0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004aad),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _userController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Email or Phone',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                ),
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            _loading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _handleForgotPassword,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: const Color(
                                          0xFF004aad,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Send Reset Password Link',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                    await Future.delayed(
                                      const Duration(milliseconds: 500),
                                    );
                                    if (mounted) {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginView(),
                                        ),
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Go back to login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
