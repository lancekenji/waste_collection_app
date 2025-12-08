import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class IntroPage {
  final String image;
  final String title;
  final String description;

  IntroPage({
    required this.image,
    required this.title,
    required this.description,
  });
}

class IntroView extends StatefulWidget {
  const IntroView({super.key});

  @override
  State<IntroView> createState() => _IntroViewState();
}

class _IntroViewState extends State<IntroView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<IntroPage> _pages = [
    IntroPage(
      image: 'assets/images/intro_1.png',
      title: 'Your Journey Starts Here',
      description: 'Welcome to the Waste Collection Scheduler & Tracker App!',
    ),
    IntroPage(
      image: 'assets/images/intro_2.png',
      title: 'Easy To Use',
      description:
          'Check your waste collection schedule, get alerts, and report uncollected waste in one app!',
    ),
    IntroPage(
      image: 'assets/images/intro_3.png',
      title: 'Help Keep Our City Clean',
      description:
          'Helping you and the community keep the city clean, organized, and eco-friendly.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _completeIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_completed', true);
    // await prefs.setBool('intro_completed', false); // Testing purpose
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
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
          child: Stack(
            children: [
              Positioned(
                top: -150,
                left: 0,
                right: 0,
                height: 500,
                child: Image.asset(
                  'assets/images/splash.png',
                  fit: BoxFit.contain,
                ),
              ),
              Positioned(
                top: 130,
                left: 0,
                right: 0,
                bottom: 80,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              Positioned(
                bottom: 16,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => _buildDot(index),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          TextButton(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.blue, width: 2),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF004aad),
                              elevation: 0,
                            ),
                            child: const Text('Back'),
                          )
                        else
                          const SizedBox(width: 80),
                        if (_currentPage < _pages.length - 1)
                          ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Colors.blue, width: 2),
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF004aad),
                              elevation: 0,
                            ),
                            child: const Text('Next'),
                          )
                        else
                          ElevatedButton(
                            onPressed: _completeIntro,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF004aad),
                              foregroundColor: Colors.white,
                              elevation: 0,
                            ),
                            child: const Text('Get Started'),
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
    );
  }

  Widget _buildPage(IntroPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 300,
                  maxWidth: 300,
                ),
                child: Image.asset(
                  page.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 100),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004aad),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              page.description,
              style: const TextStyle(fontSize: 15, color: Color(0xFF004aad)),
              textAlign: TextAlign.center,
              maxLines: 4,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? Colors.blue
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
