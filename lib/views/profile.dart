import 'package:flutter/material.dart';
import 'homepage.dart';
import 'about.dart';
import 'faq.dart';
import 'report.dart';
import '../utils/session.dart';
import '../models/user_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _retypePasswordController = TextEditingController();

  bool _showAppBarBackground = false;
  bool _obscurePassword = true;
  bool _obscureRetypePassword = true;
  bool _isEditing = false;
  bool _isLoading = true;

  String _fullName = '';
  String _barangay = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadUserData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset > 10 && !_showAppBarBackground) {
      setState(() {
        _showAppBarBackground = true;
      });
    } else if (_scrollController.offset <= 10 && _showAppBarBackground) {
      setState(() {
        _showAppBarBackground = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    final user = await getUser();
    if (user != null) {
      setState(() {
        _fullName = user.userName;
        _barangay = user.userBarangay;
        _emailController.text = user.userEmail;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return null;
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
    if (_passwordController.text.isEmpty) {
      return null;
    }
    if (value == null || value.isEmpty) {
      return 'Please retype your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF64B5F6)),
        ),
      );

      final currentUser = await getUser();
      if (currentUser != null) {
        final updatedUser = User(
          userId: currentUser.userId,
          userName: currentUser.userName,
          userEmail: _emailController.text.trim(),
          userBarangay: currentUser.userBarangay,
          token: currentUser.token,
        );
        
        await saveUser(updatedUser);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {
          _isEditing = false;
          _passwordController.clear();
          _retypePasswordController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _showAppBarBackground
            ? const Color(0xFF64B5F6)
            : Colors.transparent,
        elevation: _showAppBarBackground ? 4 : 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: _showAppBarBackground ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
                      if (!_isEditing && !_isLoading)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: _showAppBarBackground ? Colors.white : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF64B5F6)),
            )
          : Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                SizedBox(height: kToolbarHeight),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF64B5F6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Color(0xFF0D47A1),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Full Name',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: _fullName,
                              readOnly: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Barangay',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              initialValue: _barangay,
                              readOnly: true,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              readOnly: !_isEditing,
                              validator: _validateEmail,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: _isEditing
                                      ? const Color(0xFF0D47A1)
                                      : Colors.grey,
                                ),
                                filled: true,
                                fillColor:
                                    _isEditing ? Colors.white : Colors.grey[300],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: _isEditing
                                      ? const BorderSide(
                                          color: Color(0xFF0D47A1),
                                        )
                                      : BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: _isEditing
                                      ? const BorderSide(
                                          color: Color(0xFF0D47A1),
                                        )
                                      : BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF0D47A1),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                            if (_isEditing) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'New Password (Optional)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                validator: _validatePassword,
                                decoration: InputDecoration(
                                  hintText: 'Leave blank to keep current password',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color(0xFF0D47A1),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
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
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Retype New Password',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _retypePasswordController,
                                obscureText: _obscureRetypePassword,
                                validator: _validateRetypePassword,
                                decoration: InputDecoration(
                                  hintText: 'Retype your new password',
                                  hintStyle: const TextStyle(fontSize: 12),
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color(0xFF0D47A1),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureRetypePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color(0xFF0D47A1),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureRetypePassword =
                                            !_obscureRetypePassword;
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
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final user = await getUser();
                                        setState(() {
                                          _isEditing = false;
                                          if (user != null) {
                                            _emailController.text = user.userEmail;
                                          }
                                          _passwordController.clear();
                                          _retypePasswordController.clear();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey[300],
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: _handleSave,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0D47A1),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Save Changes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            if (index == 1) return;
            if (index == 0) {
              Navigator.pop(context);
              return;
            } else if (index == 2) {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const AboutView(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            } else if (index == 3) {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const FAQView(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            } else if (index == 4) {
              Navigator.pop(context);
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const ReportView(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 300),
                ),
              );
            } else if (index == 5) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF0D47A1),
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About Us'),
            BottomNavigationBarItem(icon: Icon(Icons.help), label: 'FAQs'),
            BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Logout'),
          ],
        ),
      ),
    );
  }
}
