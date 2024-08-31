class Pharmacy {
  final String pharmacyId;
  final String name;
  final String tel;
  final String address;
  final List<int> startTime;
  final List<int> endTime;
  final double distance;
  final double latitude;
  final double longitude;

  Pharmacy({
    required this.pharmacyId,
    required this.name,
    required this.tel,
    required this.address,
    required this.startTime,
    required this.endTime,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      pharmacyId: json['pharmacyId'],
      name: json['name'],
      tel: json['tel'],
      address: json['address'],
      startTime: List<int>.from(json['startTime']),
      endTime: List<int>.from(json['endTime']),
      distance: json['distance'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
