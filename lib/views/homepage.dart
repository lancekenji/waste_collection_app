import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'about.dart';
import 'faq.dart';
import 'report.dart';
import 'profile.dart';
import '../services/api_service.dart';
import '../utils/session.dart';
import '../models/user_model.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageView> {
  int _selectedBottomIndex = 0;
  int _selectedTabIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  final ApiService _apiService = ApiService();
  
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<ScheduleEvent>> _events = {};
  List<Announcement> _announcements = [];
  bool _isLoadingSchedules = true;
  bool _isLoadingAnnouncements = true;

  @override
  void initState() {
    super.initState();
    _loadScheduleData();
    _loadAnnouncements();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadScheduleData() async {
    final token = await getToken();
    final userId = await getUserId();

    if (token == null || userId == null) {
      setState(() => _isLoadingSchedules = false);
      return;
    }

    final result = await _apiService.getSchedules(token, userId);

    if (result['success'] == true) {
      final schedules = result['schedules'] as List<Schedule>;
      final Map<DateTime, List<ScheduleEvent>> events = {};

      for (var schedule in schedules) {
        final date = DateTime.parse(schedule.scheduleDate);
        final dateKey = DateTime(date.year, date.month, date.day);
        
        final event = ScheduleEvent(
          time: schedule.scheduleTime,
          wasteTypes: schedule.wasteTypes,
        );

        if (events[dateKey] == null) {
          events[dateKey] = [event];
        } else {
          events[dateKey]!.add(event);
        }
      }

      setState(() {
        _events = events;
        _isLoadingSchedules = false;
      });
    } else {
      setState(() => _isLoadingSchedules = false);
    }
  }

  Future<void> _loadAnnouncements() async {
    final token = await getToken();

    if (token == null) {
      setState(() => _isLoadingAnnouncements = false);
      return;
    }

    final result = await _apiService.getAnnouncements(token);

    if (result['success'] == true) {
      setState(() {
        _announcements = result['announcements'] as List<Announcement>;
        _isLoadingAnnouncements = false;
      });
    } else {
      setState(() => _isLoadingAnnouncements = false);
    }
  }

  List<ScheduleEvent> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _showScheduleDetails(DateTime day, List<ScheduleEvent> events) {
    if (events.isEmpty) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0D47A1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.event, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ${DateFormat('MMMM d, yyyy').format(day)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0D47A1),
                        ),
                      ),
                      Text(
                        'Time: ${events.first.time}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: events.first.wasteTypes.map((type) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF64B5F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              type,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Rule & Reminders',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildReminderItem('✓', 'Segregation Guidelines:', Colors.green),
            _buildSubItem('• Bins must be 5 ft from obstacles (cars, poles).'),
            _buildSubItem('• Place bins at the street, not sidewalks.'),
            const SizedBox(height: 8),
            _buildReminderItem('⊗', 'Prohibited items:', Colors.red),
            _buildSubItem('• No construction debris in general waste.'),
            _buildSubItem('• No hazardous or organic bins.'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderItem(String icon, String text, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            icon,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 4),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }

  void _handleBottomNavigation(int index) {
    if (index == 0) {
      return;
    }

    setState(() {
      _selectedBottomIndex = index;
    });

    switch (index) {
      case 1:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ProfileView(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
            transitionDuration: const Duration(milliseconds: 300),
          ),
        ).then((_) => setState(() => _selectedBottomIndex = 0));
        break;
      case 2:
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
        ).then((_) => setState(() => _selectedBottomIndex = 0));
        break;
      case 3:
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
        ).then((_) => setState(() => _selectedBottomIndex = 0));
        break;
      case 4:
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
        ).then((_) => setState(() => _selectedBottomIndex = 0));
        break;
      case 5:
        _showLogoutDialog();
        break;
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _selectedBottomIndex = 0);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Image.asset(
                          'assets/images/homepage_header.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 95,
                        left: 30,
                        right: 30,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0x79ffffff),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('h:mm a').format(DateTime.now()),
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                  Text(
                                    DateFormat(
                                      'EEE, MMMM d',
                                    ).format(DateTime.now()),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.today,
                                color: Color(0xFF64B5F6),
                                size: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: _isLoadingAnnouncements
                      ? const SizedBox(
                          height: 180,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF0D47A1),
                            ),
                          ),
                        )
                      : _announcements.isEmpty
                          ? Container(
                              height: 180,
                              margin: const EdgeInsets.symmetric(horizontal: 30),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  'No announcements available',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            )
                          : CarouselSlider.builder(
                              options: CarouselOptions(
                                height: 180,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                enlargeCenterPage: true,
                                viewportFraction: 0.85,
                              ),
                              itemCount: _announcements.length,
                              itemBuilder: (context, index, realIndex) {
                                final announcement = _announcements[index];
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: announcement.announcementPhoto != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.network(
                                            'http://your-domain.com${announcement.announcementPhoto}',
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return const Center(
                                                child: Icon(
                                                  Icons.image,
                                                  size: 48,
                                                  color: Colors.grey,
                                                ),
                                              );
                                            },
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return const Center(
                                                child: CircularProgressIndicator(
                                                  color: Color(0xFF0D47A1),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : const Center(
                                          child: Icon(
                                            Icons.image,
                                            size: 48,
                                            color: Colors.grey,
                                          ),
                                        ),
                                );
                              },
                            ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Image.asset(
                    'assets/images/homepage_segregate.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedTabIndex = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedTabIndex == 0
                                      ? const Color(0xFF0D47A1)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Guides',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTabIndex == 0
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedTabIndex = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedTabIndex == 1
                                      ? const Color(0xFF0D47A1)
                                      : Colors.transparent,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Calendar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedTabIndex == 1
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedTabIndex == 0) _buildGuidesTab(),
                      if (_selectedTabIndex == 1) _buildCalendarTab(),
                    ],
                  ),
                ),
                const SizedBox(height: 80),
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
          currentIndex: _selectedBottomIndex,
          onTap: _handleBottomNavigation,
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

  Widget _buildGuidesTab() {
    final steps = [
      {'title': 'Step 1:', 'subtitle': 'Sort waste by type'},
      {'title': 'Step 2:', 'subtitle': 'Label each waste bin'},
      {'title': 'Step 3:', 'subtitle': 'Process organic waste'},
      {'title': 'Step 4:', 'subtitle': 'Collect & recycle\nnon-organic waste'},
      {
        'title': 'Step 5:',
        'subtitle': 'Implement the 3R\n(Reduce, Reuse, Recycle)',
      },
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Practice Proper Waste Management',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
        ),
        CarouselSlider.builder(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 180,
            enableInfiniteScroll: false,
            enlargeCenterPage: false,
            viewportFraction: 0.33,
            padEnds: false,
          ),
          itemCount: steps.length,
          itemBuilder: (context, index, realIndex) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/step_${index + 1}.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    steps[index]['title']!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    steps[index]['subtitle']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildCalendarTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pick-up Schedule',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 12),
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getEventsForDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              final events = _getEventsForDay(selectedDay);
              if (events.isNotEmpty) {
                _showScheduleDetails(selectedDay, events);
              }
            },
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: Color(0xFF64B5F6),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF0D47A1),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              markersMaxCount: 1,
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(color: Colors.red),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(fontSize: 12),
              weekendStyle: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleEvent {
  final String time;
  final List<String> wasteTypes;

  ScheduleEvent({required this.time, required this.wasteTypes});
}
