import 'package:flutter/material.dart';

class addReminder extends StatelessWidget {
  const addReminder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Add reminder',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Name of medicine *:',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Dosage (mg):',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
            TextField(
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Additional Notes:',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
            TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Select interval *:',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.left,
            ),
            const intervalSelection(),
          ],
        ),
      ),
    );
  }
}

class intervalSelection extends StatefulWidget {
  const intervalSelection({super.key});

  @override
  State<intervalSelection> createState() => _intervalSelectionState();
}

class _intervalSelectionState extends State<intervalSelection> {
  final _intervals = [1, 2, 4, 6, 8, 12, 24];
  var _selected = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Remind me every:',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        DropdownButton(
            elevation: 8,
            value: _selected == 0 ? null : _selected,
            hint: _selected == 0 ? Text('Select an interval') : null,
            items: _intervals.map((int value) {
              return DropdownMenuItem<int>(
                  value: value, child: Text(value.toString() + '  Hours'));
            }).toList(),
            onChanged: (newVal) {
              setState(() {
                _selected = newVal!;
              });
            })
      ],
    );
  }
}
