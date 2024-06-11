class Medicine {
  final List<dynamic>? notificationIDs;
  final String? medicineName;
  final int? dosage;
  final String? interval;
  final String? startTime;

  Medicine(
      {this.notificationIDs,
      this.medicineName,
      this.dosage,
      this.interval,
      this.startTime});

  //getters
  String get getName => medicineName!;
  int get getDosage => dosage!;
  String get getInterval => interval!;
  String get getStartime => startTime!;
  List<dynamic> get getIDs => notificationIDs!;

  Map<String, dynamic> toJson() {
    return {
      'ids': notificationIDs,
      'name': medicineName,
      'dosage': dosage,
      'interval': interval,
      'startTime': startTime,
    };
  }

  factory Medicine.fromJson(Map<String, dynamic> parsedJson) {
    return Medicine(
      notificationIDs: parsedJson['ids'],
      medicineName: parsedJson['name'],
      dosage: parsedJson['dosage'],
      interval: parsedJson['interval'],
      startTime: parsedJson['start'],
      
      
      
      
      );
  }
}
