import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reminders/models/add_medicine.dart';
import 'package:reminders/screens/medicine_details.dart';

class reminders extends StatelessWidget {
  const reminders({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text(
            'Prescription reminder',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.alarm),
              ),
              Text(
                'Prescription Reminder',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Set a reminder for your medicines',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Flexible(child: MedicineCard())

            /*Flexible(
                child: Center(
                  child: Text('No medicine',
                  style: Theme.of(context).textTheme.bodyLarge,),
                ),
              ),*/
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const addReminder()));
          }, //add entries on  tap
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Icon(
              Icons.add,
              size: 60,
            ),
            color: Color(0xff9cc224),
          ),
        ),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  const MedicineCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: 2,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MedicineDetails()));
          },
          child: Container(
            padding: EdgeInsets.all(12),
            width: 20,
            height: 20,
            child: Column(
              children: [
                Text(
                  'Panadol',
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '200mg',
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Every 6 hours',
                  overflow: TextOverflow.ellipsis,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
