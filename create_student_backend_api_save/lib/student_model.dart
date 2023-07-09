class Student {
  final String id;
  final String name;
  final String mobileNumber;

  Student({required this.id, required this.name, required this.mobileNumber});

  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        mobileNumber = json['mobile_number'];

  factory Student.withoutId(String name, String mobileNumber) {
    return Student(id: "-1", name: name, mobileNumber: mobileNumber);
  }
}
