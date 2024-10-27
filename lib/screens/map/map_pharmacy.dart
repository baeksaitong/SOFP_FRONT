 import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:sopf_front/services/services_pharmacy.dart';

import '../../constans/colors.dart';
import '../../models/models_pharmacy_info.dart';

class MapPharmacy extends StatefulWidget {
  @override
  _MapPharmacyState createState() => _MapPharmacyState();
}

class _MapPharmacyState extends State<MapPharmacy> {
  bool isNearbySelected = false;
  bool isNightSelected = false;
  late GoogleMapController mapController;
  Position? _currentPosition;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  final PharmacyService pharmacyService = PharmacyService();

  var logger = Logger();

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

    mapController.animateCamera(CameraUpdate.newLatLng(
      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
    ));
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

  void _onNearbyButtonPressed() async {
    var logger = Logger();

    setState(() {
      isNearbySelected = !isNearbySelected;
      isNightSelected = false;
    });

    if (_currentPosition != null) {

      try {
        final pharmacyList = await pharmacyService.pharmacyAroundGet(
          context,
          _currentPosition!.longitude.toString(),
          _currentPosition!.latitude.toString(),
        );

        if (pharmacyList != null) {
          _addPharmacyMarkers(pharmacyList);
          _showPharmacyList(pharmacyList);
        }
      } catch (e) {
        logger.e('Error fetching pharmacies: $e');
      }
    } else {
      logger.e('Current Position is not available.');
    }
  }

  void _onNightButtonPressed() async {
    setState(() {
      isNightSelected = !isNightSelected;
      isNearbySelected = false;
    });

    if (_currentPosition != null) {
      try {
        final nightPharmacyList = await pharmacyService.pharmacyNightGet(
          context,
          _currentPosition!.longitude.toString(),
          _currentPosition!.latitude.toString(),
        );

        if (nightPharmacyList != null) {
          _addPharmacyMarkers(nightPharmacyList);
          _showPharmacyList(nightPharmacyList);
        }
      } catch (e) {
        logger.e('Error fetching night pharmacies: $e');
      }
    }
  }

  void _addPharmacyMarkers(List<Pharmacy> pharmacyList) {
    _markers.clear();
    for (var pharmacy in pharmacyList) {
      final marker = Marker(
        markerId: MarkerId(pharmacy.name),
        position: LatLng(pharmacy.latitude, pharmacy.longitude),
        infoWindow: InfoWindow(title: pharmacy.name),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      setState(() {
        _markers.add(marker);
      });
    }
  }

  void _showPharmacyList(List<Pharmacy> pharmacyList) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return ListView.builder(
              controller: scrollController,
              itemCount: pharmacyList.length,
              itemBuilder: (context, index) {
                final pharmacy = pharmacyList[index];
                return GestureDetector(
                  onTap: () => _showPharmacyDetail(pharmacy),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: const [
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
                                    pharmacy.name,
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
                              SizedBox(height: 4),
                              Text(
                                pharmacy.address.length>10
                                  ? '${pharmacy.distance} km | ${pharmacy.address.substring(0,18)}...'
                                  : '${pharmacy.distance} km | ${pharmacy.address}'
                              ),
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
                                '${pharmacy.startTime[0]}:${pharmacy.startTime[1]} - ${pharmacy.endTime[0]}:${pharmacy.endTime[1]}',
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

  void _showPharmacyDetail(Pharmacy? pharmacy) {
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
                          pharmacy?.name ?? '약국 상세 정보',
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
                            pharmacy?.address ?? '서울 노원구 광운로 20',
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
                          pharmacy?.tel ?? '02-1234-5678',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // 그림자를 없애서 색 변화 방지
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
