import 'package:reminders/models/errors.dart';
import 'package:rxdart/rxdart.dart';

class NewEntryBloc {
  BehaviorSubject<int>? _selectedInterval$;
  BehaviorSubject<int>? get selectedIntervals => _selectedInterval$;

  BehaviorSubject<String>? _selectedTimeOfDay$;
  BehaviorSubject<String>? get selectedTimeOfDay => _selectedTimeOfDay$;

  //error state
  BehaviorSubject<EntryError>? _errorState$;
  BehaviorSubject<EntryError>? get errorState$ => _errorState$;

  NewEntryBloc() {
    _selectedTimeOfDay$ = BehaviorSubject<String>.seeded('none');
    _selectedInterval$ = BehaviorSubject<int>.seeded(0);
    _errorState$ = BehaviorSubject<EntryError>();
  }

  void dispose() {
    _selectedTimeOfDay$!.close();
    _selectedInterval$!.close();
  }

  void submitError(EntryError error) {
    _errorState$!.add(error);
  }

  void updateInterval(int interval) {
    _selectedInterval$!.add(interval);
  }

  void updateTime(String time) {
    _selectedTimeOfDay$!.add(time);
  }

}
