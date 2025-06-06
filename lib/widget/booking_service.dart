import 'package:flutter/material.dart';

class BookingService extends StatefulWidget {
  final Map<String, int> selectedServices;

  BookingService({required this.selectedServices});

  @override
  _BookingServiceState createState() => _BookingServiceState();
}


class _BookingServiceState extends State<BookingService> {
  TextEditingController searchController = TextEditingController();
  String selectedCategory = 'Đồ Ăn Phục Vụ';

  Map<String, int> selectedServices = {};

  List<ServiceItem> services = [
    ServiceItem(
      name: 'Trứng luộc (Quả)',
      price: 7000,
      unit: 'Quả',
      category: 'Đồ Ăn Phục Vụ',
      icon: '🥚',
    ),
    ServiceItem(
      name: 'Nhật Bóng (Giờ)',
      price: 30000,
      unit: 'Giờ',
      category: 'Nhật Bóng',
      icon: '⚽',
    ),
    ServiceItem(
      name: 'Trà Chanh Ca (Ca)',
      price: 50000,
      unit: 'Ca',
      category: 'Nước',
      icon: '🥤',
    ),
    ServiceItem(
      name: 'Trà Chanh Cốc (Cốc)',
      price: 25000,
      unit: 'Cốc',
      category: 'Nước',
      icon: '🥤',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<ServiceItem> filteredServices = services
        .where((service) => service.category == selectedCategory)
        .toList();

    int totalAmount = selectedServices.entries
        .map((entry) => entry.value * services.firstWhere((s) => s.name == entry.key).price)
        .fold(0, (sum, price) => sum + price);

    return Scaffold(
      backgroundColor: Color(0xff2973B2),
      resizeToAvoidBottomInset: false, // Quan trọng: Ngăn Scaffold resize khi bàn phím xuất hiện
      appBar: AppBar(
        backgroundColor: Color(0xff2973B2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Dịch vụ dành cho bạn',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Phần body chính
          Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Nhập tên sản phẩm',
                      hintStyle: TextStyle(color: Color(0xff2973B2)),
                      prefixIcon: Icon(Icons.search, color: Color(0xff578FCA)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ),

              // Category tabs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildCategoryTab('Đồ Ăn Phục Vụ'),
                    SizedBox(width: 8),
                    _buildCategoryTab('Nhật Bóng'),
                    SizedBox(width: 8),
                    _buildCategoryTab('Nước'),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Services list
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 100), // Để tránh bị che bởi bottom summary
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      // Category header
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xff578FCA),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Text(
                          selectedCategory,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      // Services
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredServices.length,
                          itemBuilder: (context, index) {
                            ServiceItem service = filteredServices[index];
                            int quantity = selectedServices[service.name] ?? 0;

                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey[200]!),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Service icon
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        service.icon,
                                        style: TextStyle(fontSize: 24),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 12),

                                  // Service info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          '${service.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ / ${service.unit}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Add button
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedServices[service.name] =
                                            (selectedServices[service.name] ?? 0) + 1;
                                      });
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xff578FCA),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom summary cố định
          // Bottom summary cố định
          Positioned(
            left: 0,
            right: 0,
            bottom: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context, selectedServices); // 👈 Gửi dữ liệu đã chọn về
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange[400],
                  borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Thêm dịch vụ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${selectedServices.values.fold(0, (sum, qty) => sum + qty)} món',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Tổng cộng: ${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} đ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(String category) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class ServiceItem {
  final String name;
  final int price;
  final String unit;
  final String category;
  final String icon;

  ServiceItem({
    required this.name,
    required this.price,
    required this.unit,
    required this.category,
    required this.icon,
  });
}