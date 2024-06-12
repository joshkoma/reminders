import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:reminders/global_bloc.dart';
import 'package:reminders/models/new_entry.dart';
import 'package:reminders/models/medicine.dart';
import 'package:reminders/screens/medicine_details.dart';

class reminders extends StatelessWidget {
  const reminders({super.key});

  @override
  Widget build(BuildContext context) {
    // final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
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
            TopContainer(),

            Flexible(
              child: BottomContainer(),
            )
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NewEntryPage()));
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
  //to get current saved items

  @override
  Widget build(BuildContext context) {
    //use conditions to check shared preferences and dispaly data
    // final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => MedicineDetails(medicine))));
      },
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        color: Color(0xff888888),
        width: 20,
        height: 20,
        child: Column(
          children: [
            Text(
              medicine.medicineName!,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              medicine.dosage!.toString(),
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              medicine.interval == 1
                  ? 'Every ${medicine.interval} Hour'
                  : 'Every ${medicine.interval} Hours',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }
}

//top container class with medicine count
class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder<List<Medicine>>(
        stream: globalBloc.medicineList$,
        builder: (context, snapshot) {
          return Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  !snapshot.hasData ? '0' : snapshot.data!.length.toString(),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    print(snapshot.data!.length.toString());              
                  },
                  child: Text('Data save test')),
            ],
          );
        });
  }
}

//bottom container
class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder(
        stream: globalBloc.medicineList$,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //if no data saved
            return Container();
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No Medicine'));
          } else {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return MedicineCard(medicine: snapshot.data![index]);
                //
              },
            );
          }
        });
  }
}
