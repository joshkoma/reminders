import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:reminders/global_bloc.dart';
import 'package:reminders/models/convert_time.dart';
import 'package:reminders/models/errors.dart';
import 'package:reminders/models/medicine.dart';
import 'package:reminders/models/new_entry_bloc.dart';
import 'package:reminders/screens/reminders.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  late TextEditingController nameController;
  late TextEditingController dosageController;
  //initialize instance of plugin
  late FlutterLocalNotificationsPlugin _notifications;
  late NewEntryBloc _newEntryBloc;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dosageController.dispose();
    _newEntryBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    _newEntryBloc = NewEntryBloc();
    nameController = TextEditingController();
    dosageController = TextEditingController();
    _notifications = FlutterLocalNotificationsPlugin();
    _newEntryBloc = NewEntryBloc();
    _scaffoldKey = GlobalKey<ScaffoldState>();
    initializeNotifications();
    //initialize timezone
    tz.initializeTimeZones();
    initializeErrorListen(_newEntryBloc);
  }

  @override
  Widget build(BuildContext context) {
    final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text(
          'Add reminder',
          style: TextStyle(color: Colors.white),
        ),
      ),
      //ensure the body is wrapped in provider
      body: Provider<NewEntryBloc>.value(
        value: _newEntryBloc,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: testNotification,
                    child: Text('Test notification')),

                ElevatedButton(
                    onPressed: periodicNotificationTest,
                    child: Text('Periodic notification')),
                ElevatedButton(
                    onPressed: cancelTest,
                    child: Text('Cancel All notifications')),

                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Name of medicine *:',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left,
                ),
                TextFormField(
                  controller: nameController,
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
                  controller: dosageController,
                  keyboardType: TextInputType.number,
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
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Starting time*',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.left,
                ),
                const SelectTime(),
                //select medicine on press
                ElevatedButton(
                    onPressed: () {
                      //add medcine
                      String? medicineName;
                      int? dosage;
                      //-----error controller check-----------//
                      if (nameController.text == '') {
                        _newEntryBloc.submitError(EntryError.nameNull);
                        print('Error: Namenull'); //delete from production
                        return;
                      }
                      if (nameController.text != '') {
                        medicineName = nameController.text;
                      }

                      if (dosageController.text == '') {
                        dosage = 0;
                      }

                      if (dosageController.text != '') {
                        dosage = int.parse(dosageController.text);
                      }

                      for (var medicine in globalBloc.medicineList$!.value) {
                        if (medicineName == medicine.medicineName) {
                          _newEntryBloc.submitError(EntryError.nameDuplicate);
                          print(
                              'Error: NameDuplicate'); //delete from production
                          return;
                        }
                      }

                      if (_newEntryBloc.selectedInterval$!.value == 0) {
                        _newEntryBloc.submitError(EntryError.interval);
                        print('Error: No interval'); //delete from production
                        return;
                      }

                      if (_newEntryBloc.selectedTimeOfDay$!.value == 'None') {
                        _newEntryBloc.submitError(EntryError.startTime);
                        print(
                            'Error: Start time not selected'); //delete from production
                        return;
                      }

                      int interval = _newEntryBloc.selectedInterval$!.value;
                      String startTime =
                          _newEntryBloc.selectedTimeOfDay$!.value;
                      print('start time: ' +
                          startTime); //print statement to view start time ==> obtained correctly

                      List<int> intIDs =
                          makeIDs(24 / _newEntryBloc.selectedInterval$!.value);
                      List<String> notificationIDs = intIDs
                          .map((i) => i.toString())
                          .toList(); //for shared prefs

                      Medicine newEntryMedicine = Medicine(
                        notificationIDs: notificationIDs,
                        medicineName: medicineName,
                        dosage: dosage,
                        interval: interval,
                        startTime: startTime,
                      );

                      //update medicine list via global bloc
                      globalBloc.updateMedicineList(
                        newEntryMedicine,
                      );

                      //schedule notification
                      scheduleNotification(newEntryMedicine);
                      print(
                          'Medicine saved successfully!'); // status print notification

                      //print success message on snackbar
                    },
                    child: Text('confirm'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        iOS: initializationSettingsIOS, android: initializationSettingsAndroid);

    //error handling
    try {
      await _notifications.initialize(
        initializationSettings,
      );
      print("Notifications initialized successfully.");
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  //display test notification
  Future testNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'TestID',
      'ScheduledID',
      channelDescription: 'RepeatID',
      importance: Importance.max,
      channelShowBadge: true,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    _notifications.show(
        10, 'testnotification', 'this is a test', notificationDetails);
  }

//cancel all notifications
  Future cancelTest() async {
    print('All notifications cancelled');
    _notifications.cancelAll();
  }

//test periodic notifications
  Future periodicNotificationTest() async {
    print('Periodic Notification Triggered');

    //define notification details
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'periodic channel id',
      'repeating channel name',
      channelDescription: 'repeating description',
      importance: Importance.max,
      channelShowBadge: true,
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails2 =
        NotificationDetails(android: androidNotificationDetails);

    await _notifications.periodicallyShow(
        7,
        'Periodic Notification',
        'This is a periodic notification',
        RepeatInterval.everyMinute,
        notificationDetails2,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

//redirect to reminder page
  Future onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const reminders()));
  }

  Future<void> scheduleNotification(Medicine medicine) async {
    var hour = int.parse(medicine.startTime![0] + medicine.startTime![1]);
    var minute = int.parse(medicine.startTime![2] + medicine.startTime![3]);
    print('{Parsed Hour is $hour and minute is $minute}');

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'repeatDailyAtTime channel id', 'repeatDailyAtTime channel name',
        importance: Importance.max, ticker: 'ticker');

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    );
    int hour2 = now.hour;
    int minute2 = now.minute;
    print({'the hour is $hour2 and minute is  $minute2'}); // time is correct

    for (int i = 0; i < (24 / medicine.interval!).floor(); i++) {
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      await _notifications.zonedSchedule(
        int.parse(medicine.notificationIDs![i]),
        'Reminder: ${medicine.medicineName}',
        'It is time to take your medicine',
        scheduledDate,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      print('notification scheduled with ID $i');

      scheduledDate = scheduledDate.add(Duration(seconds: 30));
    }
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
    final NewEntryBloc newEntryBloc = Provider.of<NewEntryBloc>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                newEntryBloc.updateInterval(newVal);
              });
            })
      ],
    );
  }
}

class SelectTime extends StatefulWidget {
  const SelectTime({super.key});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  TimeOfDay _time = TimeOfDay.now();
  bool clicked = false;

  Future<TimeOfDay> _selectedTime() async {
    final NewEntryBloc _newEntryBloc =
        Provider.of<NewEntryBloc>(context, listen: false);

    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: _time);

    if (picked != null) {
      setState(() {
        _time = picked;
        clicked = true;

        _newEntryBloc.updateTime(convertTime(_time.hour.toString()) +
            convertTime(_time.minute.toString()));
      });
    }
    //picked cannot be null
    return picked!;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xff9cc224),
          ),
          onPressed: _selectedTime,
          child: Text(
            clicked == false
                ? 'Select start time'
                : '${convertTime(_time.hour.toString())}:${convertTime(_time.minute.toString())}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          )),
    );
  }
}

void initializeErrorListen(NewEntryBloc _newEntryBloc) {
  _newEntryBloc.errorState$!.listen((EntryError error) {
    switch (error) {
      case EntryError.nameNull:
        displayError('Please Enter Medicine Name');
        break;

      case EntryError.nameDuplicate:
        displayError('Medicine already exists');
        break;

      case EntryError.dosage:
        displayError('Please enter the dosage required');
        break;

      case EntryError.interval:
        displayError('Please select the reminder interval');
        break;

      case EntryError.startTime:
        displayError('Please select the reminder start time');
        break;
      //show error snackbar
      default:
    }
  });
}

void displayError(String error) {
  // _scaffoldKey.currentState.showSnackBar(
  //   SnackBar(
  //     backgroundColor: Colors.red,
  //     content: Text(error),
  //     duration: Duration(milliseconds: 2000),
  //   ),
  // );
}

List<int> makeIDs(double n) {
  var rng = Random();
  List<int> ids = [];
  for (int i = 0; i < n; i++) {
    ids.add(rng.nextInt(1000000000));
  }
  return ids;
}
