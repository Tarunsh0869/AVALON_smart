import 'dart:async';
import 'package:flutter/material.dart';
import 'doctor_screen.dart';

// Ensure the class name is Homepage to match your navigation call
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  late Timer _timer;

  final List<String> bannerImages = [
    'assets/images/img1.jfif',
    'assets/images/img2.jfif',
    'assets/images/img3.jfif',
  ];
  final List<Map<String, dynamic>> actionItems = [
    {'icon': Icons.groups, 'label': 'Explore Clubs'},
    {'icon': Icons.calendar_view_month_sharp, 'label': 'Events'},
    {'icon': Icons.people_outline, 'label': 'My Clubs'},
    {'icon': Icons.smart_toy, 'label': 'Forums'},
    {'icon': Icons.notifications_none, 'label': 'Notices'},
    {'icon': Icons.chat_bubble_outline, 'label': 'Chats'},
    {'icon': Icons.volunteer_activism, 'label': 'Donation'},
    {'icon': Icons.public, 'label': 'Socials'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Shopping'},
    {'icon': Icons.collections_outlined, 'label': 'Gallery'},
    {'icon': Icons.receipt_long, 'label': 'My Orders'},
    {'icon': Icons.settings, 'label': 'Referred Doc'},  
   
  
  
  ];
  @override
  void initState() {
    super.initState();
    _startAutoSlider();
  }

  void _startAutoSlider() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < bannerImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        ); // animateToPage ends
      }
    }); // Timer ends
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ), // CircleAvatar ends
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tarun sharma', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('student', 
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ), // Column ends
            ), // Expanded ends
          ],
        ), // Title Row ends
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.segment, color: Colors.black, size: 28)),
          const SizedBox(width: 8),
        ],
      ), // AppBar ends
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: bannerImages.length,
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(bannerImages[index]),
                          fit: BoxFit.cover,
                        ), // DecorationImage ends
                      ), // BoxDecoration ends
                    ), // Container ends
                  ); // Padding ends
                },
              ), // PageView ends
            ), // SizedBox ends
            
            const Padding(padding: EdgeInsets.only(left:20.0, top: 40.0, bottom: 20.0),
            child: Text('Quick Actions',
            textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)
              ),
            ), // Padding
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 4, 
                childAspectRatio: 0.65, // Accommodates text labels
              ), // SliverGridDelegate ends
             itemCount: actionItems.length,
              itemBuilder: (context, index) {
                return _QuickActionItem(
                  icon: actionItems[index]['icon'],
                  label: actionItems[index]['label'],
                  onTap: () {
                    if (actionItems[index]['label'] == 'Referred Doc') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  DoctorScreen()),
                      );
                    }
                  },
                ); // _QuickActionItem ends
              }, // itemBuilder ends
            ), // GridView ends
     
          ],
        ),
      ),
    ); // Scaffold ends
  }
}    
class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // <--- This must be connected here
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D2D),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}