import 'package:flutter/material.dart';
import 'api_crud/api_service.dart';
import 'activity_details_dialog.dart';
import 'select_users_dialog.dart';
import 'package:collection/collection.dart';

class AdminView extends StatefulWidget {
  final bool isAdmin;
  final Map<String, dynamic> user;
  const AdminView({super.key, required this.isAdmin, required this.user});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late Future<List<Activity>> futureActivities;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  int activityCount = 0;
  @override
  void initState() {
    super.initState();
    _refreshActivities();
  }

  void _refreshActivities({String? category, String? location, String? date}) {
    setState(() {
      if (category != null && category.isNotEmpty) {
        futureActivities = ApiServiceAdmin().fetchActivitiesByCategory(category);
      } else if (location != null && location.isNotEmpty) {
        futureActivities = ApiServiceAdmin().fetchActivitiesByLocation(location);
      } else if (date != null && date.isNotEmpty) {
        futureActivities = ApiServiceAdmin().fetchActivitiesByDate(date);
      } else {
        futureActivities = ApiServiceAdmin().fetchActivities();
      }

      futureActivities.then((activities) {
        setState(() {
          activityCount = activities.length;
        });
      });
    });
  }
  void _showEditActivityDialog({Activity? activity}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final formKey = GlobalKey<FormState>();
        late String title = activity?.title ?? '';
        late String description = activity?.description ?? '';
        late String location = activity?.location ?? '';
        late String category = activity?.category ?? '';
        late int maxParticipants = activity?.maxParticipants ?? 0;
        late String status = activity?.status ?? 'Pendiente';
        late int duration = activity?.duration ?? 0;
        List<String> selectedUserNames = activity?.participants ?? [];
        late Future<List<User>> futureUsers = ApiServiceAdmin().fetchUsers();

        _dateController.text =
            activity?.date ?? DateTime.now().toIso8601String().split('T').first;
        _hourController.text =
            activity?.hour ?? TimeOfDay.now().format(context);

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: title,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        title = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: description,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        description = value!;
                      },
                    ),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(
                        hintText: 'Fecha',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      readOnly: true,
                      onTap: () async {
                        final datetime = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (datetime != null) {
                          setState(() {
                            _dateController.text =
                                datetime.toIso8601String().split('T').first;
                          });
                        }
                      },
                    ),
                    TextFormField(
                      controller: _hourController,
                      decoration: const InputDecoration(
                        hintText: 'Hora',
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                      style: const TextStyle(color: Colors.white),
                      readOnly: true,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            _hourController.text = time.format(context);
                          });
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: location,
                      decoration: const InputDecoration(
                        labelText: 'Ubicación',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        location = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: category,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onSaved: (value) {
                        category = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: maxParticipants.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Maximo de Participantes',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        maxParticipants = int.parse(value!);
                      },
                    ),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.blue,
                      value: status,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      items: ['Pendiente', 'Realizada'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          status = newValue!;
                        });
                      },
                      onSaved: (value) {
                        status = value!;
                      },
                    ),
                    TextFormField(
                      initialValue: duration.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Duración (Horas)',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        duration = int.parse(value!);
                      },
                    ),
                    FutureBuilder<List<User>>(
                      future: futureUsers,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('No users found');
                        } else {
                          return TextField(
                            readOnly: true,
                            onTap: () async {
                              final selectedNames =
                                  await showDialog<List<String>>(
                                context: context,
                                builder: (context) => SelectUsersDialog(
                                  users: snapshot.data!,
                                  selectedUserNames: selectedUserNames,
                                ),
                              );
                              if (selectedNames != null) {
                                setState(() {
                                  selectedUserNames = selectedNames;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Participantes',
                              labelStyle: const TextStyle(color: Colors.white),
                              hintText: selectedUserNames.isEmpty
                                  ? 'Participantes ${snapshot.data!.length}'
                                  : selectedUserNames.join(', '),
                              hintStyle: const TextStyle(color: Colors.white70),
                            ),
                            style: const TextStyle(color: Colors.white),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            _refreshActivities();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.red)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              if (title.isEmpty ||
                                  description.isEmpty ||
                                  _dateController.text.isEmpty ||
                                  _hourController.text.isEmpty ||
                                  location.isEmpty ||
                                  category.isEmpty ||
                                  maxParticipants <= 0 ||
                                  status.isEmpty ||
                                  duration <= 0) {
                                // Show a dialog to inform the user to fill all fields
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text('Formulario incompleto'),
                                      content: const Text(
                                          'Por favor, rellene todos los campos.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                // Store initial values
                                final initialTitle = activity?.title ?? '';
                                final initialDescription =
                                    activity?.description ?? '';
                                final initialDate = activity?.date ?? '';
                                final initialHour = activity?.hour ?? '';
                                final initialLocation =
                                    activity?.location ?? '';
                                final initialCategory =
                                    activity?.category ?? '';
                                final initialMaxParticipants =
                                    activity?.maxParticipants ?? 0;
                                final initialStatus =
                                    activity?.status ?? 'Pendiente';
                                final initialDuration = activity?.duration ?? 0;
                                final initialParticipants =
                                    activity?.participants ?? [];

                                // Check if there are changes
                                final hasChanges = title != initialTitle ||
                                    description != initialDescription ||
                                    _dateController.text != initialDate ||
                                    _hourController.text != initialHour ||
                                    location != initialLocation ||
                                    category != initialCategory ||
                                    maxParticipants != initialMaxParticipants ||
                                    status != initialStatus ||
                                    duration != initialDuration ||
                                    !const ListEquality().equals(
                                        selectedUserNames, initialParticipants);

                                if (hasChanges) {
                                  // Show confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Confirmar cambios'),
                                        content: const Text(
                                            '¿Está seguro de que desea guardar los cambios?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _saveActivity(
                                                  activity,
                                                  title,
                                                  description,
                                                  _dateController.text,
                                                  _hourController.text,
                                                  location,
                                                  category,
                                                  maxParticipants,
                                                  selectedUserNames,
                                                  status,
                                                  duration);
                                            },
                                            child: const Text('Guardar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // No changes, just save
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('No hay cambios'),
                                        content: const Text(
                                            'No se han realizado cambios. ¿Desea guardar de todas formas?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              _saveActivity(
                                                  activity,
                                                  title,
                                                  description,
                                                  _dateController.text,
                                                  _hourController.text,
                                                  location,
                                                  category,
                                                  maxParticipants,
                                                  selectedUserNames,
                                                  status,
                                                  duration);
                                            },
                                            child: const Text('Guardar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  //_saveActivity(activity, title, description, _dateController.text, _hourController.text, location, category, maxParticipants, selectedUserNames, status, duration);
                                }
                              }
                            }
                          },
                          child: const Text('Guardar',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _saveActivity(
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
      int duration) {
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
    if (activity == null) {
      ApiServiceAdmin().createActivity(updatedActivity);
    } else {
      ApiServiceAdmin().updateActivity(updatedActivity);
    }
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(activity == null ? 'Activity created' : 'Activity updated'),
        backgroundColor: Colors.green,
      ),
    );
    _refreshActivities();
  }

  void _showCreateActivityDialog() {
    _showEditActivityDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Administración',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenido',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Administrador: ${widget.user['name']} ${widget.user['last_name']}',
                        style: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.account_circle,
                          size: 50,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          if(widget.isAdmin){
                            Navigator.pushNamed(context, '/user');
                          }else{
                            Navigator.pushNamed(context, '/profile');
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 20),
                  _buildFilterSection(),
                ],
              ),
            Container(
              padding: const EdgeInsets.all(20),
              child:  Column(
                children: [
                  Text(
                    'Lista de Actividades ($activityCount)',
                    style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Activity>>(
                  future: futureActivities,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Column(
                        children: [
                          CircularProgressIndicator(
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Colors.green,
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.redAccent),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No activities found');
                    } else {
                      return RefreshIndicator(
                          onRefresh: () async {
                            _refreshActivities();
                          },
                          child: ListView.builder(
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
                                      style: const TextStyle(
                                          color: Colors.white70),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
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
                                          icon: const Icon(Icons.edit),
                                          onPressed: () {
                                            _showEditActivityDialog(
                                                activity: activity);
                                          },
                                        ),
                                        IconButton(
                                          color: Colors.redAccent,
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Confirmar eliminación'),
                                                  content: const Text(
                                                      '¿Está seguro de que desea eliminar esta actividad?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                          'Cancelar'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        ApiServiceAdmin()
                                                            .deleteActivity(
                                                            activity.id);
                                                        _refreshActivities();
                                                        ScaffoldMessenger.of(
                                                            context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Activity deleted'),
                                                            backgroundColor:
                                                            Colors.green,
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Eliminar'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            _refreshActivities();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _showCreateActivityDialog();
        },
        tooltip: 'Add',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      children: [
        const Text(
          'Filtrar actividades',
          style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Ingrese la categoria',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.green),
              onPressed: () {
                if (_categoryController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingrese una categoría'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  _refreshActivities(category: _categoryController.text);
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Ingrese la ubicación',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.green),
              onPressed: () {
                if (_locationController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingrese una ubicación'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  _refreshActivities(location: _locationController.text);
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Ingrese la fecha',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
                readOnly: true,
                onTap: () async {
                  final datetime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (datetime != null) {
                    setState(() {
                      _dateController.text =
                          datetime.toIso8601String().split('T').first;
                    });
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.green),
              onPressed: () {
                if (_dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, ingrese una fecha'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  _refreshActivities(date: _dateController.text);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
