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

  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required Color color,
    required Widget targetScreen,
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
            offset: Offset(0, (1 - animation.value) * 50), // Remove rotation, keep vertical animation only
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Added horizontal margin
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          elevation: 15,
          shadowColor: color.withOpacity(0.3),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => targetScreen,
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                ),
              );
            },
            borderRadius: BorderRadius.circular(25),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: color.withOpacity(0.1), width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80, // Slightly larger for better visual
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          Color.lerp(color, Colors.white, 0.3)!,
                        ],
                        begin: Alignment.topCenter, // Changed to top center for consistent gradient
                        end: Alignment.bottomCenter,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 36, // Slightly larger icon
                    ),
                  ),
                  const SizedBox(height: 20), // Increased spacing
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18, // Slightly larger font
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 12), // Added spacing
                  Container(
                    width: 40, // Wider line
                    height: 4,
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
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 20), // Added vertical padding
              children: [
                const SizedBox(height: 10), // Added top spacing
                
                _buildMenuTile(
                  title: "Attendance Check-In",
                  icon: Icons.fingerprint,
                  color: const Color(0xFF2196F3),
                  targetScreen: const AttendScreen(),
                  delayFactor: 1.0,
                ),
                
                const SizedBox(height: 15), // Added spacing between tiles
                
                _buildMenuTile(
                  title: "Permission Request",
                  icon: Icons.assignment_turned_in,
                  color: const Color(0xFF9C27B0),
                  targetScreen: const AbsentScreen(),
                  delayFactor: 2.0,
                ),
                
                const SizedBox(height: 15), // Added spacing between tiles
                
                _buildMenuTile(
                  title: "Attendance History",
                  icon: Icons.history,
                  color: const Color(0xFF673AB7),
                  targetScreen: const AttendanceHistoryScreen(),
                  delayFactor: 3.0,
                ),
                
                const SizedBox(height: 10), // Added bottom spacing
              ],
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