import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reminders/global_bloc.dart';
import 'package:reminders/models/add_medicine.dart';
import 'package:reminders/models/medicine.dart';
import 'package:reminders/screens/medicine_details.dart';

class reminders extends StatelessWidget {
  const reminders({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
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

            //return medicine count from sharedpreferences
            StreamBuilder<List<Medicine>>(
                stream: globalBloc.medicineList,
                builder: ((context, snapshot) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  );
                })),

            Flexible(
                child: MedicineCard(
              //should input value of snapshot which does not seem to be
              medicine: Medicine(),
            ))

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
  const MedicineCard({Key? key, required this.medicine}) : super(key: key);
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder(
        stream: globalBloc.medicineList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //if no data saved
            return Container();
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MedicineDetails()));
                  },
                  child: Text('No Medicine')),
            );
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MedicineDetails()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    width: 20,
                    height: 20,
                    child: Column(
                      children: [
                        Text(
                          medicine.medicineName!,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          medicine.dosage!.toString(),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          medicine.interval.toString(),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}
