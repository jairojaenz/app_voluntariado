import 'package:app_voluntariado/api.dart';
import 'package:app_voluntariado/api_crud/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'activity_details_dialog.dart';
import 'filter_section.dart';

class SearchScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const SearchScreen({super.key, required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _nameActivityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late Future<List<Activity>> activities;

  @override
  void initState() {
    super.initState();
    _refreshActivities();
  }

  void _refreshActivities(
      {String? NameActivity, String? location, String? date}) {
    setState(() {
      if (NameActivity != null) {
        activities = ApiServiceAdmin().getActivitiesByName(NameActivity);
      } else if (location != null) {
        activities = ApiServiceAdmin().fetchActivitiesByLocation(location);
      } else if (date != null) {
        activities = ApiServiceAdmin().fetchActivitiesByDate(date);
      } else {
        activities = ApiServiceAdmin().fetchActivities();
      }
    });
  }


  void _signUpForActivity(
    Activity? activity,
    String title,
    String description,
    String date,
    String hour,
    String location,
    String category,
    int maxParticipants,
    List<String> participants,
    String status,
    int duration) async {
  String userName = widget.user['name'] ?? 'Unnamed';

  if (!participants.contains(userName)) {
    participants.add(userName);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ya estás inscrito en esta actividad'),
      ),
    );
    return;
  }

  Activity updatedActivity = Activity(
    id: activity?.id ?? '',
    title: title,
    description: description,
    date: date,
    hour: hour,
    location: location,
    category: category,
    maxParticipants: maxParticipants,
    participants: participants,
    status: status,
    duration: duration,
  );
  if (activity?.status == 'Pendiente') {
    ApiServiceAdmin().updateActivity(updatedActivity);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Te has inscrito en la actividad! ${activity?.title}'),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('La actividad ya no está disponible'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Actividades'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilterSection(
              nameActivityController: _nameActivityController,
              locationController: _locationController,
              dateController: _dateController,
              onnameActivityFilter: (NameActivity) {
                _refreshActivities(NameActivity: NameActivity);
              },
              onLocationFilter: (location) {
                _refreshActivities(location: location);
              },
              onDateFilter: (date) {
                _refreshActivities(date: date);
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Activity>>(
                future: activities,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Column(
                      children: [
                        const Text(
                            'Debe haber un error en la conexión o formato incorrecto'),
                        ElevatedButton(
                            onPressed: () => _refreshActivities(),
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue)),
                            child: const Text(
                              'Recargar',
                              style: TextStyle(color: Colors.white),
                            )),
                      ],
                    ));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No activities found.'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final activity = snapshot.data![index];
                        final isPending = activity.status == 'Pendiente';
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isPending
                                    ? [Colors.red, Colors.yellow]
                                    : [Colors.blue, Colors.green],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: ListTile(
                              hoverColor: Colors.green,
                              title: Text(
                                activity.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              subtitle: Text(
                                activity.description,
                                style: const TextStyle(color: Colors.white70),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.visibility),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ActivityDetailsDialog(
                                                activity: activity),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    icon: const Icon(Icons.check),
                                    onPressed: () {
                                      _signUpForActivity(
                                        activity,
                                        activity.title,
                                        activity.description,
                                        activity.date,
                                        activity.hour,
                                        activity.location,
                                        activity.category,
                                        activity.maxParticipants,
                                        activity.participants,
                                        activity.status,
                                        activity.duration,
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'usuario inscrito en la actividad: ${activity.title}'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
