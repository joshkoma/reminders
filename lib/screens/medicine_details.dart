import 'package:flutter/material.dart';
import 'package:reminders/models/medicine.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails(this.medicine, {Key? key}) : super(key: key);
  final Medicine? medicine;

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
  @override
  Widget build(BuildContext context) {
    final medicine = widget.medicine;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Medicine Detials',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        
        children: [
          SizedBox(
            height: 16,
          ),
          Text(medicine!.medicineName!), 
          SizedBox(
            height: 16,
          ),
          Text(medicine.dosage == 0 ? 'Not specified' : medicine.dosage.toString()+' mg'),
          SizedBox(
            height: 16,
          ),

          //set condition for text display
          Text(medicine.interval.toString()),
           //set condition for text display
          Text(medicine.startTime![0]+ ':'+medicine.startTime![1]+ 'am'),
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
