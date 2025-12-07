import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
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
      setState(() => _showAppBarBackground = true);
    } else if (_scrollController.offset <= 10 && _showAppBarBackground) {
      setState(() => _showAppBarBackground = false);
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: _showAppBarBackground ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About Us',
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
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + kToolbarHeight,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Waste Collection Scheduler & Tracker App',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'The Waste Collection Scheduler & Tracker is a mobile and web-based application designed to help Local Government Units (LGUs) enhance the efficiency of waste management operations. It allows residents to easily view collection schedules, receive real-time notifications, and track garbage trucks within their area. On the LGU side, the system helps administrators manage collection schedules, monitor truck activity, and handle citizen reports seamlessly.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'By combining scheduling, tracking, and reporting features in one platform, the system promotes better communication between the LGU and the community, ensuring timely collection and improved waste segregation practices.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Meet the Team',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 340,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 320,
                    viewportFraction: 0.7,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    scrollPhysics: const BouncingScrollPhysics(),
                  ),
                  items: [
                    _buildTeamCard(
                      name: 'Lance Kenji Parce',
                      position: 'Leader | Developer',
                      image: null, // placeholder Icon
                    ),
                    _buildTeamCard(
                      name: 'Jon Lyndon Mojica',
                      position: 'Project Manager',
                      image: null, // placeholder Icon
                    ),
                    _buildTeamCard(
                      name: 'Angela Badilla',
                      position: 'UI/UX Designer',
                      image: null, // placeholder Icon
                    ),
                    _buildTeamCard(
                      name: 'Kristine Joy Camay',
                      position: 'UI/UX Designer',
                      image: null, // placeholder Icon
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCard({
    required String name,
    required String position,
    String? image, // optional image
  }) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: image != null
                  ? Image.asset(image, fit: BoxFit.cover)
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF64B5F6), Color(0xFF81C784)],
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              position,
              style: const TextStyle(fontSize: 14, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
