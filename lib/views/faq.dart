import 'package:flutter/material.dart';
import 'about.dart';
import 'report.dart';
import 'profile.dart';

class FAQView extends StatefulWidget {
  const FAQView({super.key});

  @override
  State<FAQView> createState() => _FAQViewState();
}

class _FAQViewState extends State<FAQView> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarBackground = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
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
          'Frequently Asked Questions (FAQ)',
          style: TextStyle(
            color: _showAppBarBackground ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            icon: '💡',
                            title: 'General Questions',
                            questions: [
                              FAQItem(
                                question: '1. What is Tagaytay Loop?',
                                answer:
                                    'Tagaytay Loop is a mobile app that helps Tagaytay residents stay informed about waste collection schedules, track garbage trucks, and report uncollected waste easily.',
                              ),
                              FAQItem(
                                question: '2. Who can use the app?',
                                answer:
                                    'All residents of Tagaytay City and local government staff involved in waste management can use it.',
                              ),
                              FAQItem(
                                question: '3. Is the app free to use?',
                                answer:
                                    'Yes. Tagaytay Loop is free and accessible to all Tagaytay residents.',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSection(
                            icon: '🗓️',
                            title: 'Schedule & Collection',
                            questions: [
                              FAQItem(
                                question:
                                    '4. How can I check my collection schedule?',
                                answer:
                                    'Go to the "Calendar" tab to view your barangay\'s waste collection schedule, color-coded by waste type.',
                              ),
                              FAQItem(
                                question: '5. What if the schedule changes?',
                                answer:
                                    'You\'ll receive a push notification or alert message if there are changes or delays in your area\'s collection.',
                              ),
                              FAQItem(
                                question:
                                    '6. What types of waste are included in the schedule?',
                                answer:
                                    'The app shows collection schedules for biodegradable, recyclable, residual, and special waste.',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSection(
                            icon: '🚨',
                            title: 'Reporting Waste',
                            questions: [
                              FAQItem(
                                question:
                                    '7. How do I report uncollected waste?',
                                answer:
                                    'Tap "Report", upload a photo or take a photo, and the app will automatically tag your location before submitting it to the LGU.',
                              ),
                              FAQItem(
                                question: '8. Can I track my report\'s status?',
                                answer:
                                    'Yes. You\'ll be notified when your report is received, processed, or resolved by the LGU.',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSection(
                            icon: '♻️',
                            title: 'Waste Education',
                            questions: [
                              FAQItem(
                                question: '9. What is the "Waste Guide"?',
                                answer:
                                    'The Waste Guide provides tips and educational materials about proper Segregation and eco-friendly waste practices.',
                              ),
                              FAQItem(
                                question:
                                    '10. Why is waste segregation important?',
                                answer:
                                    'Segregating waste helps reduce pollution, improves recycling, and supports a healthier, clean and green environment.',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSection(
                            icon: '🔔',
                            title: 'Notifications & Privacy',
                            questions: [
                              FAQItem(
                                question:
                                    '11. What kind of notifications will I receive?',
                                answer:
                                    'You\'ll get alerts for upcoming collection days, schedule changes, and updates from your barangay or the LGU.',
                              ),
                              FAQItem(
                                question: '12. Is my personal data safe?',
                                answer:
                                    'Yes. Tagaytay Loop values your privacy — all data is secured and used only for improving waste management services.',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildSection(
                            icon: '✅',
                            title: 'Community Impact',
                            questions: [
                              FAQItem(
                                question:
                                    '13. How does this app help Tagaytay City?',
                                answer:
                                    'It helps reduce missed collections, improves communication between residents and LGU, and promotes a cleaner, greener Tagaytay.',
                              ),
                              FAQItem(
                                question:
                                    '14. How can I help keep Tagaytay clean?',
                                answer:
                                    'Follow your collection schedule, segregate waste properly, and report any uncollected garbage promptly.',
                              ),
                            ],
                          ),
                        ],
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
          currentIndex: 3,
          onTap: (index) {
            if (index == 3) return;
            if (index == 0) {
              Navigator.pop(context);
              return;
            } else if (index == 1) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileView()),
              );
            } else if (index == 2) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutView()),
              );
            } else if (index == 4) {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportView()),
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

  Widget _buildSection({
    required String icon,
    required String title,
    required List<FAQItem> questions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...questions.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.question,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.answer,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
