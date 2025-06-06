import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thue_san_the_thao_1/services/api/api_service.dart';
import 'package:thue_san_the_thao_1/widget/booking_field.dart';

import '../models/model_field.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> sports = [
    {'icon': 'assets/soccer1.png', 'label': 'Bóng đá'},
    {'icon': 'assets/basketball1.png', 'label': 'Bóng rổ'},
    {'icon': 'assets/tennis1.png', 'label': 'Tennis'},
    {'icon': 'assets/badminton1.png', 'label': 'Cầu lông'},
    {'icon': 'assets/volleyball1.png', 'label': 'Bóng chuyền'},
    {'icon': 'assets/pickleball2.png', 'label': 'Pickleball'},
  ];

  final _apiService = ApiService();
  List<Field> _fields = [];
  List<Field> _filteredFields = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  int? _selectedSportIndex;

  @override
  void initState() {
    super.initState();
    _fetchFields();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _fetchFields() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final fields = await _apiService.fieldApi.getFields();
      setState(() {
        _fields = fields;
        _filteredFields = fields;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final selectedLabel = _selectedSportIndex != null
        ? sports[_selectedSportIndex!]['label']!.toLowerCase()
        : null;

    setState(() {
      _filteredFields = _fields.where((field) {
        final name = field.name.toLowerCase();
        final address = field.address.toLowerCase();
        final sportType = field.sportType.toLowerCase();
        final matchesSearch = name.contains(query) || address.contains(query);
        final matchesSport = selectedLabel == null || sportType == selectedLabel;
        return matchesSearch && matchesSport;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2973B2),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: _buildFieldList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/search.svg',
                          width: 20,
                          height: 20,
                          colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                        ),
                      ),
                      hintText: 'Tìm kiếm',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/dadung.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'What do you want?',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sports.length,
              itemBuilder: (context, index) {
                final sport = sports[index];
                return GestureDetector(
                  // onTap: () {
                  //   setState(() {
                  //     _selectedSportIndex = index;
                  //     _applyFilters();
                  //   });
                  // },
                    onTap: () {
                      setState(() {
                        if (_selectedSportIndex == index) {
                          // Nếu click lại vào biểu tượng đang chọn => bỏ chọn
                          _selectedSportIndex = null;
                        } else {
                          _selectedSportIndex = index;
                        }
                        _applyFilters(); // Áp dụng lại lọc
                      });
                    },

                    child: Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: _buildSportCategory(
                      sport['icon']!,
                      sport['label']!,
                      index,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportCategory(String icon, String name, int index) {
    return Container(
      width: 70,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: index == _selectedSportIndex ? Colors.blue : const Color(0xff6A99D7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(icon, scale: 2),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.0),
          child: Text(
            'Danh sách sân',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          )
              : _filteredFields.isEmpty
              ? const Center(
            child: Text(
              'Không tìm thấy sân nào.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
              : SingleChildScrollView(
            child: Column(
              children: _filteredFields
                  .map((field) => Column(
                children: [
                  _buildFieldCard(field),
                  const SizedBox(height: 15),
                ],
              ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldCard(Field field) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.network(
                field.images,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(color: Colors.blue.shade300),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tên Sân: ${field.name}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    field.address,
                    style:
                    const TextStyle(color: Colors.grey, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        field.timeaction,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.phone,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        field.contactPhone,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            Flexible(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  BookingField()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const FittedBox(
                  child: Text(
                    'Đặt lịch',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}