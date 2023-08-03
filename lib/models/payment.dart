// ignore: camel_case_types
class Payment {
  final int?      id;
  final String    name;
  final String    note;
  // ignore: non_constant_identifier_names
  final int?      status;
  // ignore: non_constant_identifier_names
  final DateTime  created_at;

  // create contructor
  Payment({
    this.id,
    required this.name,
    required this.note,
    // ignore: non_constant_identifier_names
    this.status,
    // ignore: non_constant_identifier_names
    required this.created_at
  });


  factory Payment.fromMap(Map<String, dynamic>json ) => Payment(
    id:         json['id'],
    name:       json['name'],
    note:       json['note'], 
    status:     json['status'],
    created_at: json['created_at'],
  );

  // create Map data
  Map<String, dynamic> toMap() {
    return {
      'id'            : id,
      'name'          : name,
      'note'          : note,
      'status'        : status,
      'created_at'    : created_at,
    };
  }
}