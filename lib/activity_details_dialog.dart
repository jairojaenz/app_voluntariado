import 'package:flutter/material.dart';
import 'api_crud/api_service.dart';

class ActivityDetailsDialog extends StatelessWidget {
  final Activity activity;

  const ActivityDetailsDialog({Key? key, required this.activity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      showModalBottomSheet(
        backgroundColor: Colors.green,
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      activity.title,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold,
                      color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.description, color: Colors.blue,size: 30,),
                    const SizedBox(width: 8),
                    Text(activity.description,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.deepOrange),
                    const SizedBox(width: 8),
                    Text(activity.date,style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(activity.hour,style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.cyanAccent),
                    const SizedBox(width: 8),
                    Text(activity.location,style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.category, color: Colors.amberAccent),
                    const SizedBox(width: 8),
                    Text(activity.category,style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.people, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Text(activity.maxParticipants.toString(),style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.deepPurpleAccent),
                    const SizedBox(width: 8),
                    Text(activity.status,style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.timer, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('${activity.duration} Hours',style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,fontWeight: FontWeight.bold,),),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close',style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    )),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
    return Container(); // Return an empty container to satisfy the return type
  }
}
