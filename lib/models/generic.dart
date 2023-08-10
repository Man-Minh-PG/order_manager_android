// ignore: camel_case_types
class Generic {
  final int?      id;
  final String    name;
  final String    value;
  // ignore: non_constant_identifier_names
  final int?      status;
  // ignore: non_constant_identifier_names
  final DateTime  created_at;

  // create contructor
  Generic({
    this.id,
    required this.name,
    required this.value,
    // ignore: non_constant_identifier_names
    this.status,
    // ignore: non_constant_identifier_names
    required this.created_at
  });


  factory Generic.fromMap(Map<String, dynamic>json ) => Generic(
    id:         json['id'],
    name:       json['name'],
    value:      json['value'],
    status:     json['status'],
    created_at: json['created_at'],
  );

  // create Map data
  Map<String, dynamic> toMap() {
    return {
      'id'            : id,
      'name'          : name,
      'value'         : value,
      'status'        : status,
      'created_at'    : created_at,
    };
  }
}