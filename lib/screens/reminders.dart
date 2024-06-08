import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminders/models/add_medicine.dart';
class reminders extends StatelessWidget {
  const reminders({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('Prescription reminder', style: TextStyle(color: Colors.white),),
        ),
        body: Column(
          children: [
            SizedBox(height: 16,),
            Row(
              children: [Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.alarm),
              ),
              Text('Prescription Reminder',
              style: Theme.of(context).textTheme.titleLarge,),
              ]
            ),
            const SizedBox(height: 10,),
            Text('Set a reminder for your medicines',
            textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge,),

              Flexible(
                child: Center(
                  child: Text('No medicine',
                  style: Theme.of(context).textTheme.bodyLarge,),
                ),
              ),
            
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap:() {Navigator.push(context, MaterialPageRoute(builder: (context) => const addReminder()));}, //add entries on  tap
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Icon(Icons.add, size: 60,),
            color: Color(0xff9cc224),
          ),
        ),
      ),
    );
  }
}