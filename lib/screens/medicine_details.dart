import 'package:flutter/material.dart';

class MedicineDetails extends StatefulWidget {
  const MedicineDetails({super.key});

  @override
  State<MedicineDetails> createState() => _MedicineDetailsState();
}

class _MedicineDetailsState extends State<MedicineDetails> {
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
        children: [
          SizedBox(
            height: 16,
          ),
          Text('Paracetamol'),
          SizedBox(
            height: 16,
          ),
          Text('200mg'),
          SizedBox(
            height: 16,
          ),
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
            TextButton(onPressed: () {
              //global bloc to delete medicine
            }, child: Text('Delete'))
          ],
        );
      });
}
