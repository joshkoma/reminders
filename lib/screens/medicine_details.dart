import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminders/global_bloc.dart';
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
    final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
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
          Text(medicine.dosage == 0
              ? 'Not specified'
              : medicine.dosage.toString() + ' mg'),
          SizedBox(
            height: 16,
          ),

          Text(medicine.interval.toString()),
          //set condition for text display
          Text('${medicine.startTime![0]}${medicine.startTime![1]} :'
                  '${medicine.startTime![2]}${medicine.startTime![3]}' +
              ' am'),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                openAlertBox(context, _globalBloc, medicine);
              },
              child: Text('Delete'))
        ],
      ),
    );
  }
}

openAlertBox(BuildContext context, GlobalBloc _globalBloc, Medicine? medicine) {
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
                  _globalBloc.removeMedicine(medicine!);
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Text('Delete'))
          ],
        );
      });
}
