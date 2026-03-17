import 'package:flutter/material.dart';

// 1. Define what a Patient's data looks like
class Patient {
  final String name;
  final String id;
  final String phone;
  final String status;
  final Color statusColor;

  Patient({
    required this.name, 
    required this.id, 
    required this.phone, 
    required this.status,
    this.statusColor = const Color.fromARGB(153, 255, 255, 255),
  });
}

class DoctorScreen extends StatelessWidget {
  DoctorScreen({super.key});

  final List<Patient> patientList = [
    Patient(name: "Patient 1 ", id: "AN250122152609", phone: "9562222794", status: "Completed", statusColor: Colors.green),
    Patient(name: "Harshit Rathore", id: "HA250320120815", phone: "8126691448", status: "Assigned", statusColor: Colors.orange),
    Patient(name: "Tarun sharma", id: "SE250228163652", phone: "1111111111", status: "Accepted", statusColor: Colors.blue),
    Patient(name: "Vivaan Sharma", id: "VK260316104500", phone: "9876222210", status: "Pending", statusColor: Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                
                // --- BLOCK 1: HEADER SECTION ---
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'), 
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Welcome to SmileSync", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Text("Tarun Sharma(Jr. Software Developer)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Row(
                            children: [
                              Icon(Icons.business, size: 14, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("Oral Medicine", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.segment)),
                  ],
                ),

                const SizedBox(height: 30),

                // --- BLOCK 2: MANAGEMENT BAR ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("My patients", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                        IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list_outlined)),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 10),

                // --- BLOCK 3: CALENDAR STRIP ---
                Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.chevron_left_outlined, color: Colors.grey),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 160,vertical: 10),
                          child: Text("March 2025", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                        ),
                        Icon(Icons.chevron_right_rounded, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDateItem("Sun", "23"),
                        _buildDateItem("Mon", "24"),
                        _buildDateItem("Tue", "25"),
                        _buildDateItem("Wed", "26"),
                        _buildDateItem("Thu", "27"),
                        _buildDateItem("Fri", "28", isSelected: true),
                        _buildDateItem("Sat", "29"),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 25),
                 //PATIENT LIST 
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: patientList.length, // Uses the length of your list
                  itemBuilder: (context, index) {
                    // Pull the specific patient for this specific row
                    return _buildPatientCard(patientList[index]);
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 3. Updated Helper Method to accept a Patient object
  Widget _buildPatientCard(Patient patient) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 250, 249, 249),
            child: Icon(Icons.person_2_outlined, color: Color.fromARGB(255, 110, 105, 105)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(patient.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(patient.id, style: const TextStyle(color: Color.fromARGB(153, 245, 245, 245), fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Color.fromARGB(153, 253, 249, 249), size: 14),
                    const SizedBox(width: 4),
                    Text(patient.phone, style: const TextStyle(color: Color.fromARGB(153, 255, 255, 255), fontSize: 11)),
                    const SizedBox(width: 10),
                    Icon(Icons.check_circle, color: patient.statusColor, size: 16),
                    const SizedBox(width: 4),
                    Text(patient.status, style: TextStyle(color: patient.statusColor, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color.fromARGB(31, 255, 255, 255), shape: BoxShape.circle),
            child: const Icon(Icons.medication_liquid_outlined, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem(String day, String date, {bool isSelected = false}) {
    return Column(
      children: [
        Text(day, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isSelected ? const Color.fromARGB(255, 54, 103, 228) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Text(
            date,
            style: TextStyle(
              color: isSelected ? const Color.fromARGB(255, 255, 255, 255) : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}