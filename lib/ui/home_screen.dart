import 'package:attendance_app/absent/absent_screen.dart';
import 'package:attendance_app/attend/attend_screen.dart';
import 'package:attendance_app/attendance_history/attendance_history_screen.dart';
import 'package:attendance_app/account/account_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String selectedMonth = "December";

  // -- Warna Tema --
  final Color primaryColor = const Color(0xFF2196F3);
  final Color accentColor = const Color(0xFF9C27B0);

  // List Bulan
  final List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  // Sample attendance data
  final Map<String, dynamic> attendanceData = {
    'present': 20,
    'earlyLeave': 3,
    'absent': 2,
    'delay': 4,
  };

  // Sample timeline data
  final List<Map<String, dynamic>> timelineData = [
    {'day': '02', 'weekday': 'Mon', 'status': 'absent', 'date': '2023-12-02'},
    {'day': '03', 'weekday': 'Tue', 'status': 'present', 'date': '2023-12-03'},
    {'day': '04', 'weekday': 'Wed', 'status': 'present', 'date': '2023-12-04'},
    {'day': '05', 'weekday': 'Thu', 'status': 'late', 'date': '2023-12-05'},
    {'day': '06', 'weekday': 'Fri', 'status': 'present', 'date': '2023-12-06'},
    {'day': '07', 'weekday': 'Sat', 'status': 'weekend', 'date': '2023-12-07'},
    {'day': '08', 'weekday': 'Sun', 'status': 'weekend', 'date': '2023-12-08'},
  ];

  // Helper Decoration
  BoxDecoration _getCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  // Helper Menu Card (Coming Soon logic)
  Widget _buildMenuCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    // ... (Logic untuk quick access jika diperlukan nanti)
    return Container(); 
  }

  Widget _buildStatsCard(String title, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _getCardDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(Map<String, dynamic> dayData) {
    IconData icon;
    Color color;

    switch (dayData['status']) {
      case 'present':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'absent':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case 'late':
        icon = Icons.watch_later;
        color = Colors.orange;
        break;
      case 'weekend':
        icon = Icons.weekend;
        color = Colors.grey;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(
          dayData['day'],
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          dayData['weekday'],
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      
      // --- APP BAR ---
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
          ),
        ),
        centerTitle: true,
        title: const Text(
          "Attendance App",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white, size: 28),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // --- MONTH SELECTOR (YANG DIPERBAIKI) ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15), // Sudut membulat
                border: Border.all(color: primaryColor.withOpacity(0.1)), // Border tipis
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Ikon Kalender kecil di kiri
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.calendar_today, color: primaryColor, size: 18),
                  ),
                  const SizedBox(width: 12),
                  
                  // Dropdown
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMonth,
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                        isExpanded: true,
                        dropdownColor: Colors.white, // Warna background popup
                        borderRadius: BorderRadius.circular(15), // Sudut popup membulat
                        style: const TextStyle(
                          fontSize: 16, 
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                          });
                        },
                        items: months.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatsCard(
                  "Present",
                  attendanceData['present'],
                  Colors.green,
                  Icons.check_circle,
                ),
                _buildStatsCard(
                  "Early Leave",
                  attendanceData['earlyLeave'],
                  Colors.orange,
                  Icons.arrow_upward,
                ),
                _buildStatsCard(
                  "Absent",
                  attendanceData['absent'],
                  Colors.red,
                  Icons.cancel,
                ),
                _buildStatsCard(
                  "Delay",
                  attendanceData['delay'],
                  Colors.purple,
                  Icons.watch_later,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Your Timeline Section
            Text(
              "Your Timeline",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 16),

            // Week Navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: _getCardDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 16, color: primaryColor),
                    onPressed: () {},
                  ),
                  const Text(
                    "Week 1",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 16, color: primaryColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Timeline Days
            Container(
              padding: const EdgeInsets.all(16),
              decoration: _getCardDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: timelineData.map((dayData) => _buildTimelineItem(dayData)).toList(),
              ),
            ),
          ],
        ),
      ),

      // --- NAVBAR ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          
          switch (index) {
            case 0:
              // Already on Home
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AttendScreen()),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AttendanceHistoryScreen()),
              );
              break;
            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AbsentScreen()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fingerprint),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Requests',
          ),
        ],
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}