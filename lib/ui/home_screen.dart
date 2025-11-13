import 'package:attendance_app/absent/absent_screen.dart';
import 'package:attendance_app/attend/attend_screen.dart';
import 'package:attendance_app/attendance_history/attendance_history_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to show "in progress" notification
  void _showInProgressNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.build, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              "Fitur sedang dalam pengerjaan",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 70, bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF2196F3), // Blue
            Color(0xFF9C27B0), // Purple
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFE3F2FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.person_outline,
              color: Color(0xFF2196F3),
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "HR Admin Dashboard",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Manage your attendance efficiently",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallMenuTile({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required double delayFactor,
  }) {
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.1 * delayFactor,
          0.8 + (0.15 * delayFactor),
          curve: Curves.elasticOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: Transform.translate(
            offset: Offset(0, (1 - animation.value) * 30),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          elevation: 10,
          shadowColor: color.withOpacity(0.2),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.1), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          Color.lerp(color, Colors.white, 0.3)!,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 25,
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withOpacity(0.5)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Column(
        children: [
          _buildHeader(),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Row 1: Two buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallMenuTile(
                          title: "Attendance\nCheck-In",
                          icon: Icons.fingerprint,
                          color: const Color(0xFF2196F3),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const AttendScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          delayFactor: 1.0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSmallMenuTile(
                          title: "Permission\nRequest",
                          icon: Icons.assignment_turned_in,
                          color: const Color(0xFF9C27B0),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const AbsentScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          delayFactor: 1.5,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Row 2: Two buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildSmallMenuTile(
                          title: "Attendance\nHistory",
                          icon: Icons.history,
                          color: const Color(0xFF673AB7),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => const AttendanceHistoryScreen(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          delayFactor: 2.0,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSmallMenuTile(
                          title: "Coming\nSoon",
                          icon: Icons.more_horiz,
                          color: const Color(0xFF4CAF50),
                          onTap: _showInProgressNotification,
                          delayFactor: 2.5,
                        ),
                      ),
                    ],
                  ),

                  // Spacer to push content to center
                  const SizedBox(height: 40),

                  // Info Text
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF2196F3).withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(0xFF2196F3),
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Select an option to manage your attendance",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Footer
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2196F3).withOpacity(0.9),
                  const Color(0xFF9C27B0).withOpacity(0.9),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flutter_dash, color: Colors.white70, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Powered by Flutter",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}