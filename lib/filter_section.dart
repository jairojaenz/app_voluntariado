import 'package:flutter/material.dart';

class FilterSection extends StatelessWidget {
  final TextEditingController nameActivityController;
  final TextEditingController locationController;
  final TextEditingController dateController;
  final Function(String category) onnameActivityFilter;
  final Function(String location) onLocationFilter;
  final Function(String date) onDateFilter;

  const FilterSection({
    Key? key,
    required this.nameActivityController,
    required this.locationController,
    required this.dateController,
    required this.onnameActivityFilter,
    required this.onLocationFilter,
    required this.onDateFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                controller: nameActivityController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la actividad',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Ingrese el nombre de la actividad',
                  hintStyle: TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.green),
              onPressed: () {
                if (nameActivityController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingrese un nombre de actividad'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }else{
                onnameActivityFilter(nameActivityController.text);
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: locationController,
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
                if (locationController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingrese una ubicación'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }else{
                onLocationFilter(locationController.text);
                }
              },
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: dateController,
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
                    dateController.text = datetime.toIso8601String().split('T').first;
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.green),
              onPressed: () {
                if (dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ingrese una fecha'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }else{
                onDateFilter(dateController.text);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}