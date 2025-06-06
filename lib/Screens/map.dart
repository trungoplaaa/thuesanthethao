import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/model_field.dart';
import '../services/api/api_service.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  late GoogleMapController _controller;
  final Set<Marker> _markers = {};

  late BitmapDescriptor iconSoccer;
  late BitmapDescriptor iconbasketball;
  late BitmapDescriptor iconbadminton;
  late BitmapDescriptor icontennis;
  late BitmapDescriptor iconpickleball;
  late BitmapDescriptor iconvolleyball;
  late BitmapDescriptor defaultIcon;

  final TextEditingController _searchController = TextEditingController();
  List<Field> _fields = [];
  List<Field> _searchResults = [];

  // Giữ trạng thái icon được chọn
  String? _selectedSportFilter;

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    await _loadCustomIcons();
    await _fetchFields();
  }

  Future<void> _loadCustomIcons() async {
    iconSoccer = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/soccer1.png',
    );
    iconbasketball = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/basketball1.png',
    );
    iconbadminton = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/badminton1.png',
    );
    iconpickleball = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/pickleball2.png',
    );
    icontennis = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/tennis1.png',
    );
    iconvolleyball = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/volleyball1.png',
    );
    defaultIcon = BitmapDescriptor.defaultMarker;
  }

  Future<void> _fetchFields() async {
    try {
      final fields = await ApiService().fieldApi.getFields();
      setState(() {
        _fields = fields;
        _searchResults = [];
      });
      _addMarkers(fields);
      _zoomToFitMarkers(fields);
    } catch (e) {
      print('Lỗi tải dữ liệu sân: $e');
    }
  }

  void _addMarkers(List<Field> fieldsToShow) {
    _markers.clear();
    for (var field in fieldsToShow) {
      final position = LatLng(
        double.tryParse(field.latitude) ?? 0,
        double.tryParse(field.longitude) ?? 0,
      );

      BitmapDescriptor icon;
      switch (field.sportType.toLowerCase()) {
        case 'bóng đá':
          icon = iconSoccer;
          break;
        case 'bóng rổ':
          icon = iconbasketball;
          break;
        case 'cầu lông':
          icon = iconbadminton;
          break;
        case 'tennis':
          icon = icontennis;
          break;
        case 'pickleball':
          icon = iconpickleball;
          break;
        case 'bóng chuyền':
          icon = iconvolleyball;
          break;
        default:
          icon = defaultIcon;
      }

      _markers.add(
        Marker(
          markerId: MarkerId('field_${field.id}'),
          position: position,
          icon: icon,
          infoWindow: InfoWindow(title: field.name, snippet: field.address),
        ),
      );
    }
    setState(() {});
  }

  void _searchAddress(String query) {
    if (query.isEmpty) {
      // Nếu không có filter thể thao thì show toàn bộ
      if (_selectedSportFilter == null) {
        setState(() {
          _searchResults = [];
        });
        _addMarkers(_fields);
        _zoomToFitMarkers(_fields);
      } else {
        _filterBySport(_selectedSportFilter!);
      }
      return;
    }

    final results = _fields.where((field) {
      final name = field.name.toLowerCase();
      final address = field.address.toLowerCase();
      final queryLower = query.toLowerCase();
      return name.contains(queryLower) || address.contains(queryLower);
    }).toList();

    setState(() {
      _searchResults = results;
      // Khi search, bỏ filter thể thao
      _selectedSportFilter = null;
    });
    _addMarkers(results);
    _zoomToFitMarkers(results);
  }

  void _filterBySport(String sport) {
    if (_selectedSportFilter == sport.toLowerCase()) {
      // Nếu click lại icon đang được chọn → bỏ chọn
      setState(() {
        _selectedSportFilter = null;
        _searchResults = [];
        _searchController.clear();
      });
      _addMarkers(_fields);
      _zoomToFitMarkers(_fields);
    } else {
      // Nếu chọn icon mới → lọc danh sách sân theo môn thể thao
      final filtered = _fields.where((field) =>
      field.sportType.toLowerCase() == sport.toLowerCase()).toList();

      setState(() {
        _selectedSportFilter = sport.toLowerCase();
        _searchResults = [];
        _searchController.clear();
      });

      _addMarkers(filtered);
      _zoomToFitMarkers(filtered);
    }
  }


  void _goToLocation(Field field) {
    final pos = LatLng(
      double.tryParse(field.latitude) ?? 0,
      double.tryParse(field.longitude) ?? 0,
    );

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: pos, zoom: 20),
      ),
    );

    BitmapDescriptor icon;
    switch (field.sportType.toLowerCase()) {
      case 'bóng đá':
        icon = iconSoccer;
        break;
      case 'bóng rổ':
        icon = iconbasketball;
        break;
      case 'cầu lông':
        icon = iconbadminton;
        break;
      case 'tennis':
        icon = icontennis;
        break;
      case 'pickleball':
        icon = iconpickleball;
        break;
      case 'bóng chuyền':
        icon = iconvolleyball;
        break;
      default:
        icon = defaultIcon;
    }

    _markers.removeWhere((m) => m.markerId.value == 'selected_${field.id}');

    _markers.add(
      Marker(
        markerId: MarkerId('selected_${field.id}'),
        position: pos,
        icon: icon,
        infoWindow: InfoWindow(title: field.name, snippet: field.address),
        zIndex: 20,
      ),
    );

    setState(() {
      _searchResults = [];
      _searchController.clear();
      // Khi chọn location thì bỏ filter thể thao
      _selectedSportFilter = null;
    });
  }

  void _zoomToFitMarkers(List<Field> fields) {
    if (fields.isEmpty) return;

    double minLat = fields
        .map((f) => double.tryParse(f.latitude) ?? 0)
        .reduce((a, b) => a < b ? a : b);
    double maxLat = fields
        .map((f) => double.tryParse(f.latitude) ?? 0)
        .reduce((a, b) => a > b ? a : b);
    double minLng = fields
        .map((f) => double.tryParse(f.longitude) ?? 0)
        .reduce((a, b) => a < b ? a : b);
    double maxLng = fields
        .map((f) => double.tryParse(f.longitude) ?? 0)
        .reduce((a, b) => a > b ? a : b);

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 150),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _controller = controller,
            initialCameraPosition: CameraPosition(
              target: _fields.isNotEmpty
                  ? LatLng(
                double.tryParse(_fields[0].latitude) ?? 21.0285,
                double.tryParse(_fields[0].longitude) ?? 105.8542,
              )
                  : const LatLng(21.0285, 105.8542), // Hà Nội mặc định
              zoom: 15.5,
            ),
            markers: _markers,
          ),

          Positioned(
            top: 30,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo tên hoặc địa chỉ...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchAddress('');
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                    ),
                    onChanged: _searchAddress,
                  ),
                ),

                const SizedBox(height: 8),

                // Hàng icon thể thao
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, // cho phép cuộn ngang
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start, // căn trái để cuộn tự nhiên
                      children: [
                        _buildSportIcon(
                          icon: 'assets/soccer1.png',
                          isSelected: _selectedSportFilter == 'bóng đá',
                          onTap: () => _filterBySport('bóng đá'),
                        ),
                        SizedBox(width: 5,),
                        _buildSportIcon(
                          icon: 'assets/basketball1.png',
                          isSelected: _selectedSportFilter == 'bóng rổ',
                          onTap: () => _filterBySport('bóng rổ'),
                        ),
                        SizedBox(width: 5,),
                        _buildSportIcon(
                          icon: 'assets/badminton1.png',
                          isSelected: _selectedSportFilter == 'cầu lông',
                          onTap: () => _filterBySport('cầu lông'),
                        ),
                        SizedBox(width: 5,),
                        _buildSportIcon(
                          icon: 'assets/pickleball2.png',
                          isSelected: _selectedSportFilter == 'pickleball',
                          onTap: () => _filterBySport('pickleball'),
                        ),
                        SizedBox(width: 5,),
                        _buildSportIcon(
                          icon: 'assets/tennis1.png',
                          isSelected: _selectedSportFilter == 'tennis',
                          onTap: () => _filterBySport('tennis'),
                        ),
                        SizedBox(width: 5,),
                        _buildSportIcon(
                          icon: 'assets/volleyball1.png',
                          isSelected: _selectedSportFilter == 'bóng chyền',
                          onTap: () => _filterBySport('bóng chuyền'),
                        ),
                        SizedBox(width: 5,),
                        // Thêm icon khác nếu muốn
                      ],
                    ),
                  ),
                ),

              ],
            ),
          ),

          if (_searchResults.isNotEmpty)
            Positioned(
              top: 110,
              left: 15,
              right: 15,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 5),
                  ],
                ),
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final field = _searchResults[index];
                    return ListTile(
                      title: Text(field.name),
                      subtitle: Text(field.address),
                      onTap: () => _goToLocation(field),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSportIcon({
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade100 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(icon, width: 30, height: 30),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
