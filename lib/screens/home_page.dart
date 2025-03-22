// hacen falta los imports de appointment_card.dart y doctor_card.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medicita/models/auth_model.dart';
import 'package:medicita/utils/config.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  List<dynamic> favList = [];

  List<Map<String, dynamic>> medCat = [
    {
      "icon": FontAwesomeIcons.userDoctor,
      "category": "General",
    },
    {
      "icon": FontAwesomeIcons.heartPulse,
      "category": "Cardiology",
    },
    {
      "icon": FontAwesomeIcons.lungs,
      "category": "Respirations",
    },
    {
      "icon": FontAwesomeIcons.hand,
      "category": "Dermatology",
    },
    {
      "icon": FontAwesomeIcons.personPregnant,
      "category": "Gynecology",
    },
    {
      "icon": FontAwesomeIcons.teeth,
      "category": "Dental",
    },
  ];

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    return Scaffold(
      body: user.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Header con el nombre del usuario y la imagen
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            user['name'] ?? 'User',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/profile1.jpg'),
                          ),
                        ],
                      ),
                      Config.spaceMedium,

                      // Categorías médicas
                      const Text(
                        'Category',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      SizedBox(
                        height: Config.heightSize * 0.05,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children:
                              List<Widget>.generate(medCat.length, (index) {
                            return Card(
                              margin: const EdgeInsets.only(right: 20),
                              color: Config.primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Row(
                                  children: <Widget>[
                                    FaIcon(
                                      medCat[index]['icon'],
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      medCat[index]['category'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      Config.spaceSmall,

                      // Sección de cita médica
                      const Text(
                        'Appointment Today',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,

                      // Widget temporal en lugar de AppointmentCard
                      doctor.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Config.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                "Doctor: ${doctor['name'] ?? 'N/A'}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'No Appointment Today',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                      Config.spaceSmall,

                      // Sección de Top Doctors
                      const Text(
                        'Top Doctors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,

                      // Widget temporal en lugar de DoctorCard
                      Column(
                        children: List.generate(
                          user['doctor']?.length ?? 0,
                          (index) {
                            final doc = user['doctor'][index];
                            return ListTile(
                              title: Text(doc['name'] ?? 'Doctor'),
                              subtitle: Text(doc['specialty'] ?? 'Specialty'),
                              trailing: Icon(
                                favList.contains(doc['doc_id'])
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favList.contains(doc['doc_id'])
                                    ? Colors.red
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}