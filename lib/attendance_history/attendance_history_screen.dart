import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance_app/ui/home_screen.dart';
import 'package:attendance_app/attend/attend_screen.dart';
import 'package:attendance_app/absent/absent_screen.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  // -- Variabel Navbar --
  int _currentIndex = 2; // Index 2 karena ini halaman History

  // -- Variabel Logic Asli --
  final CollectionReference dataCollection = 
      FirebaseFirestore.instance.collection('attendance');

  final Color primaryColor = const Color(0xFF2196F3);
  final Color accentColor = const Color(0xFF9C27B0);

  // Date picker function
  Future<void> _selectDateRange(BuildContext context, Function(DateTime?, DateTime?) onDateSelected) async {
    DateTime? startDate;
    DateTime? endDate;

    // Select start date
    final DateTime? pickedStart = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedStart != null) {
      startDate = pickedStart;
      
      // Select end date
      final DateTime? pickedEnd = await showDatePicker(
        context: context,
        initialDate: pickedStart.add(const Duration(days: 1)),
        firstDate: pickedStart,
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
      );

      if (pickedEnd != null) {
        endDate = pickedEnd;
      }
    }

    onDateSelected(startDate, endDate);
  }

  void _showElegantDialog({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 20,
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 15),
              content,
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editData(
    String docId,
    String currentName,
    String currentAddress,
    String currentDescription,
    String currentDatetime,
  ) {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController addressController = TextEditingController(text: currentAddress);
    TextEditingController descriptionController = TextEditingController(text: currentDescription);
    TextEditingController datetimeController = TextEditingController(text: currentDatetime);

    InputDecoration inputDecoration({
      required String labelText,
      required IconData icon,
    }) {
      return InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: primaryColor.withOpacity(0.7), size: 20),
        labelStyle: TextStyle(fontSize: 14, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
      );
    }

    _showElegantDialog(
      context: context,
      title: "Edit Attendance Record",
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: inputDecoration(labelText: "Name", icon: Icons.person),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              decoration: inputDecoration(labelText: "Address", icon: Icons.location_on),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: inputDecoration(labelText: "Description", icon: Icons.description),
            ),
            const SizedBox(height: 12),
            
            // Date Range Picker Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Datetime Range",
                  style: TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.calendar_today, color: primaryColor),
                    title: Text(
                      datetimeController.text.isEmpty ? "Select date range" : datetimeController.text,
                      style: TextStyle(
                        color: datetimeController.text.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_drop_down, color: primaryColor),
                    onTap: () {
                      _selectDateRange(context, (startDate, endDate) {
                        if (startDate != null && endDate != null) {
                          final dateFormat = DateFormat('dd/MM/yyyy');
                          final startFormatted = dateFormat.format(startDate);
                          final endFormatted = dateFormat.format(endDate);
                          datetimeController.text = '$startFormatted - $endFormatted';
                          setState(() {});
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Tap to select start and end dates",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, accentColor],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(width: 12),
                      Text("Updating record for ${nameController.text}..."),
                    ],
                  ),
                  backgroundColor: primaryColor,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              
              try {
                await dataCollection.doc(docId).update({
                  'name': nameController.text,
                  'address': addressController.text,
                  'description': descriptionController.text,
                  'datetime': datetimeController.text,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Text("Record updated successfully!"),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.white),
                        const SizedBox(width: 8),
                        Text("Error: ${e.toString()}"),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _deleteData(String docId) {
    _showElegantDialog(
      context: context,
      title: "Confirm Deletion",
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber, color: Colors.orange, size: 50),
          const SizedBox(height: 10),
          const Text(
            "Are you sure you want to permanently delete this attendance record?",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.redAccent],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await dataCollection.doc(docId).delete();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: const [
                        Icon(Icons.delete, color: Colors.white),
                        const SizedBox(width: 8),
                        Text("Record deleted successfully!"),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.white),
                        const SizedBox(width: 8),
                        Text("Error: ${e.toString()}"),
                      ],
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: color),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'attend':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'leave':
        return Colors.red;
      case 'sick':
        return Colors.blue;
      case 'permission':
        return Colors.purple;
      case 'others':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'sick':
        return '🤒';
      case 'permission':
        return '📝';
      case 'others':
        return '📌';
      case 'attend':
        return '✅';
      case 'late':
        return '⏰';
      case 'leave':
        return '🏠';
      default:
        return '📋';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2196F3),
                Color(0xFF9C27B0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          "Attendance History",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: dataCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "Error loading data",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading attendance records...",
                    style: TextStyle(fontSize: 16, color: primaryColor),
                  ),
                ],
              ),
            );
          }

          var data = snapshot.data!.docs;
          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    "No attendance records found",
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Start by checking in your attendance",
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              var docId = data[index].id;
              var record = data[index].data() as Map<String, dynamic>;
              var name = record['name'] ?? 'N/A';
              var address = record['address'] ?? '-';
              var description = record['description'] ?? 'No Description';
              var datetime = record['datetime'] ?? 'No Timestamp';
              
              String initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
              Random random = Random(name.hashCode);
              Color avatarColor = Colors.primaries[random.nextInt(Colors.primaries.length)];
              Color statusColor = _getStatusColor(description);
              String statusIcon = _getStatusIcon(description);

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: Colors.blue.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar with gradient border
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primaryColor, accentColor],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: avatarColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                initial,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Record Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: statusColor.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          statusIcon,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: statusColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _buildDetailRow(Icons.short_text, description, Colors.grey[600]!),
                              const SizedBox(height: 6),
                              _buildDetailRow(Icons.access_time, datetime, Colors.grey[600]!),
                              if (address != '-') ...[
                                const SizedBox(height: 6),
                                _buildDetailRow(Icons.location_on, address, Colors.grey[600]!),
                              ],
                            ],
                          ),
                        ),

                        // Action Buttons with increased spacing
                        const SizedBox(width: 12),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [primaryColor, accentColor],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                                onPressed: () => _editData(docId, name, address, description, datetime),
                                tooltip: 'Edit Record',
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red, Colors.redAccent],
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                                onPressed: () => _deleteData(docId),
                                tooltip: 'Delete Record',
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      // -- NAVBAR DITAMBAHKAN DI SINI --
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;
          
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AttendScreen()),
              );
              break;
            case 2:
              // Halaman ini (History)
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
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}