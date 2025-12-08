import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login.dart';
import '../controllers/signup_controller.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();
  final SignupController _controller = SignupController();

  bool _obscurePassword = true;
  bool _obscureRetypePassword = true;
  bool _agreedToTerms = false;
  bool _isLoading = false;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;
  String? _selectedBarangay;

  final List<String> _barangays = [
    'Asisan',
    'Bagong Tubig',
    'Calabuso',
    'Dapdap East',
    'Dapdap West',
    'Francisco',
    'Guinhawa North',
    'Guinhawa South',
    'Iruhin East',
    'Iruhin South',
    'Iruhin West',
    'Kaybagal Central',
    'Kaybagal North',
    'Kaybagal South (Poblacion)',
    'Mag-Asawang Ilat',
    'Maharlika East',
    'Maharlika West',
    'Maitim 2nd Central',
    'Maitim 2nd East',
    'Maitim 2nd West',
    'Mendez Crossing East',
    'Mendez Crossing West',
    'Neogan',
    'Patutong Malaki North',
    'Patutong Malaki South',
    'Sambong',
    'San Jose',
    'Silang Junction North',
    'Silang Junction South',
    'Sungay East',
    'Sungay West',
    'Tolentino East',
    'Tolentino West',
    'Zambal',
  ];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength(String password) {
    double strength = 0.0;
    String strengthText = '';
    Color strengthColor = Colors.grey;

    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthText = '';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    if (password.length >= 8) strength += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;

    if (strength <= 0.25) {
      strengthText = 'Weak';
      strengthColor = Colors.red;
    } else if (strength <= 0.5) {
      strengthText = 'Fair';
      strengthColor = Colors.orange;
    } else if (strength <= 0.75) {
      strengthText = 'Good';
      strengthColor = Colors.yellow[700]!;
    } else {
      strengthText = 'Strong';
      strengthColor = Colors.green;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }

  String? _validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Full name should only contain letters';
    }
    return null;
  }

  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or phone number is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');

    if (!emailRegex.hasMatch(value) &&
        !phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Enter a valid email or phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain a special character';
    }
    return null;
  }

  String? _validateRetypePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please retype your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateBarangay(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your barangay';
    }
    return null;
  }

  void _showTermsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Terms & Privacy',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Terms of Service (ToS)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Last Updated: December 2025',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome to the Waste Collection Scheduler & Tracker App ("the App"). By using this App, you agree to comply with and be bound by these Terms of Service. Please read them carefully before using the App.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '1. Acceptance of Terms',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'By accessing or using the App, you agree to be bound by these Terms. If you do not agree, please discontinue using the App.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '2. Description of Service',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'The App provides features including:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• Viewing waste collection schedules\n• Receiving notifications and reminders\n• Reporting uncollected waste\n• Viewing related announcements or alerts\n• Additional features may be introduced over time',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '3. User Responsibilities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('You agree to:', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• Provide accurate information when creating an account\n• Use the App only for lawful purposes\n• Avoid any misuse such as spamming, hacking, or unauthorized access',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '4. Account Security',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You are responsible for keeping your login details confidential. Any actions performed using your account will be treated as your responsibility.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '5. App Updates & Changes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We may modify, update, or discontinue parts of the App at any time without prior notice.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '6. Limitation of Liability',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We are not responsible for:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• Loss of data\n• Missed waste collection due to incorrect schedules or notifications\n• Damages caused by misuse of the App\n\nUse the App at your own risk.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '7. Termination',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We may suspend or terminate user accounts that violate these Terms.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '8. Contact Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'For concerns, issues, or questions, please contact the App administrator.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    const Divider(thickness: 2),
                    const SizedBox(height: 20),
                    const Text(
                      '🔐 Privacy Policy',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Last Updated: December 2025',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This Privacy Policy explains how your information is collected, used, and protected by the Waste Collection Scheduler & Tracker App ("the App").',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '1. Information We Collect',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1.1. Personal Information (provided by the user)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• Name (optional depending on design)\n• Email or phone number (for login or verification)\n• Password (stored securely & never shared)',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1.2. Automatically Collected Data',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• Device type\n• App usage logs\n• IP address (for security, optional)\n• Notification preferences',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '1.3. Location Data (optional)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        'If enabled, the App may access approximate location for:\n• Providing relevant collection schedules\n• Improving reporting accuracy\n\nThis is optional and user-controlled.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '2. How We Use Your Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We use the collected data to:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• Allow you to log in securely\n• Display accurate collection schedules\n• Send reminders & alerts\n• Improve user experience\n• Handle waste reports\n• Ensure system security\n\nWe do NOT sell or share your information with third parties.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '3. Data Storage & Security',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We take appropriate measures to protect your data against:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• Unauthorized access\n• Modification\n• Loss or misuse\n\nPasswords are encrypted and cannot be viewed by staff or third parties.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '4. Sharing of Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We may share limited data only when necessary:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• With local waste management authorities (for submitted waste reports)\n• When required by law\n\nWe will never sell, rent, or trade your information.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '5. User Rights',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You have the right to:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        '• Access your data\n• Update your information\n• Request data deletion\n• Withdraw permissions (ex: location access)',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '6. Children\'s Privacy',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This App is not intended for children under 13. We do not knowingly collect personal data from minors.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '7. Policy Updates',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'We may update this Privacy Policy. Changes will be reflected by updating the "Last Updated" date.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '8. Contact Us',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'If you have questions about this Privacy Policy, send a message to the App administrator.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSignUp() async {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Privacy'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await _controller.signup(
      email: _emailPhoneController.text.trim(),
      password: _passwordController.text,
      name: _fullNameController.text.trim(),
      barangay: _selectedBarangay!,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (result['success'] == true) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: Text(result['message'] ?? 'Account created successfully'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                  );
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Signup failed'),
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Let's",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "Create",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Your",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Account",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Image.asset(
                              'assets/images/signup.png',
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.recycling,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _fullNameController,
                      validator: _validateFullName,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color(0xFF0D47A1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailPhoneController,
                      validator: _validateEmailOrPhone,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Color(0xFF0D47A1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      validator: _validatePassword,
                      obscureText: _obscurePassword,
                      onChanged: _calculatePasswordStrength,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF0D47A1),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF0D47A1),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    if (_passwordController.text.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: _passwordStrength,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      _passwordStrengthColor,
                                    ),
                                    minHeight: 4,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _passwordStrengthText,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _passwordStrengthColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _retypePasswordController,
                      validator: _validateRetypePassword,
                      obscureText: _obscureRetypePassword,
                      decoration: InputDecoration(
                        hintText: 'Retype Password',
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Color(0xFF0D47A1),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureRetypePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: const Color(0xFF0D47A1),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureRetypePassword = !_obscureRetypePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedBarangay,
                      validator: _validateBarangay,
                      decoration: InputDecoration(
                        hintText: 'Select Barangay',
                        prefixIcon: const Icon(
                          Icons.location_on,
                          color: Color(0xFF0D47A1),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0D47A1),
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 2,
                          ),
                        ),
                      ),
                      items: _barangays.map((String barangay) {
                        return DropdownMenuItem<String>(
                          value: barangay,
                          child: Text(barangay),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedBarangay = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF0D47A1),
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms & Privacy',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0D47A1),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _showTermsModal,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        children: [
                          const TextSpan(text: 'Have an account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D47A1),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                );
                                await Future.delayed(
                                  const Duration(milliseconds: 500),
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginView(),
                                    ),
                                  );
                                }
                              },
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
        ),
      ),
    );
  }
}
