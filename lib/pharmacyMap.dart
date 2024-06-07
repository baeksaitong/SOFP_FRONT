import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sopf_front/appColors.dart';

class PharmacyMap extends StatefulWidget {
  @override
  _PharmacyMapState createState() => _PharmacyMapState();
}

class _PharmacyMapState extends State<PharmacyMap> {
  bool isNearbySelected = false;
  bool isNightSelected = false;
  late GoogleMapController mapController;
  Position? _currentPosition;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};

  final LatLng _initialCenter = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_currentPosition != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _addMarker(position, 'current_location', 'Current Location');
    });

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ));
    }
  }

  void _addMarker(Position position, String markerId, String info) async {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: info),
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _markers.add(marker);
    });
  }

  List<Map<String, dynamic>> pharmacyList = [
    {
      'name': '신태평 약국',
      'status': '영업중',
      'distance': '200m | 서울 노원구',
      'hours': '월-금: 09:00-19:30',
      'position': LatLng(37.62145647928562, 127.05910319834672),
    },
    {
      'name': '수암약국',
      'status': '영업중',
      'distance': '300m | 서울 노원구',
      'hours': '월-금: 09:00-18:30',
      'position': LatLng(37.62258922114194, 127.05959967347209),
    },
    {
      'name': '다나약국',
      'status': '영업중',
      'distance': '445m | 서울 노원구',
      'hours': '월-금: 09:00-19:00',
      'position': LatLng(37.622924015347145, 127.06120845368457),
    },
    {
      'name': '월계 365 약국',
      'status': '영업중',
      'distance': '430m | 서울 노원구',
      'hours': '월-금: 10:00-23:00',
      'position': LatLng(37.6231562725574, 127.0607187258027),
    },
  ];
  List<Map<String, dynamic>> nightPharmacyList = [
    {
      'name': '월계 365 약국',
      'status': '영업중',
      'distance': '430m | 서울 노원구',
      'hours': '월-금: 10:00-23:00',
      'position': LatLng(37.6231562725574, 127.0607187258027),
    },
    {
      'name': '팜프라자약국',
      'status': '영업중',
      'distance': '1.1km',
      'hours': '월-일: 10:00-22:00',
      'position': LatLng(37.62515144987384, 127.07349538050501),
    },
    {
      'name': '청년약국',
      'status': '영업중',
      'distance': '2.7km',
      'hours': '매일: 11:00-22:00',
      'position': LatLng(37.628133794622116, 127.07690531699147),
    },
  ];

  void _onNearbyButtonPressed() {
    setState(() {
      isNearbySelected = !isNearbySelected;
      isNightSelected = false;
    });

    if (_currentPosition != null) {
      print(
          'Current Position: Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}');
    } else {
      print('Current Position is not available.');
    }

    _addPharmacyMarkers(pharmacyList);
    _showPharmacyList(pharmacyList);
  }

  void _onNightButtonPressed() {
    setState(() {
      isNightSelected = !isNightSelected;
      isNearbySelected = false;
    });

    _addPharmacyMarkers(nightPharmacyList);
    _showPharmacyList(nightPharmacyList);
  }

  void _addPharmacyMarkers(List<Map<String, dynamic>> list) {
    _markers.clear();
    for (var pharmacy in list) {
      final marker = Marker(
        markerId: MarkerId(pharmacy['name']),
        position: pharmacy['position'],
        infoWindow: InfoWindow(title: pharmacy['name']),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      setState(() {
        _markers.add(marker);
      });
    }
  }

  void _showPharmacyList(List<Map<String, dynamic>> list) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: list.length,
              itemBuilder: (context, index) {
                final pharmacy = list[index];
                final status = pharmacy['status']!;
                return GestureDetector(
                  onTap: () => _showPharmacyDetail(pharmacy['name']),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    pharmacy['name']!,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusBackgroundColor(status),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: _getStatusTextColor(status),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(pharmacy['distance']!),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '영업시간',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                pharmacy['hours']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Color _getStatusBackgroundColor(String status) {
    if (status == '영업중') {
      return Colors.green.shade100;
    }
    return Colors.transparent;
  }

  Color _getStatusTextColor(String status) {
    if (status == '영업중') {
      return Colors.green;
    }
    return Colors.grey.shade700;
  }

  void _showPharmacyDetail(String? pharmacyName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.25,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          pharmacyName ?? '약국 상세 정보',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusBackgroundColor('영업중'),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '영업중',
                            style: TextStyle(
                              color: _getStatusTextColor('영업중'),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '내 위치',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '서울특별시 노원구 광운로',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '약국 위치',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '서울 노원구 광운로 20',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '영업시간',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '월 - 금 10:00 ~ 17:00',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                '토 10:00 ~ 15:00',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                '일 휴무',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.local_phone_outlined,
                          color: Colors.grey.shade700,
                        ),
                        SizedBox(width: 12),
                        Text(
                          '02-1234-5678',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.directions_outlined,
                          color: Colors.grey.shade700,
                        ),
                        SizedBox(width: 12),
                        Text(
                          '길 찾기',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onCameraMove(CameraPosition position) {
    print(
        'Current Position: Latitude: ${position.target.latitude}, Longitude: ${position.target.longitude}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.wh,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            '약국 위치',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _onNearbyButtonPressed,
            style: TextButton.styleFrom(
              backgroundColor: isNearbySelected ? Colors.teal : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '주변 약국',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isNearbySelected ? Colors.white : Colors.black,
              ),
            ),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: _onNightButtonPressed,
            style: TextButton.styleFrom(
              backgroundColor: isNightSelected ? Colors.teal : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '야간 약국',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isNightSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey.shade200,
            child: Center(
              child: _currentPosition == null
                  ? Center(child: CircularProgressIndicator())
                  : GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        zoom: 17.0,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: _currentMapType,
                      markers: _markers,
                      onCameraMove: _onCameraMove,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
