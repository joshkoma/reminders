import 'package:flutter/material.dart';
import 'package:reminders/models/medicine.dart';

class MedicineDetails extends StatefulWidget {
  MedicineDetails({super.key, this.medicine});
  final Medicine? medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  // get medicine => null; //getter created not in original code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Medicine Detials',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        //problematic code
        children: [
          // SizedBox(
          //   height: 16,
          // ),
          // Text(medicine.medicineName), //getter manually created
          // SizedBox(
          //   height: 16,
          // ),
          // Text(medicine.dosage == 0 ? 'Not specified' : medicine.dosage),
          // SizedBox(
          //   height: 16,
          // ),

          //set condition for text display
          Text('Every 8 hours, 3 times a day'),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                openAlertBox(context);
              },
              child: Text('Delete'))
        ],
      ),
    );
  }
}

openAlertBox(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete reminder'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  //global bloc to delete medicine
                },
                child: Text('Delete'))
          ],
        );
      });
}
