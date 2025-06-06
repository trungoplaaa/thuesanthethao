import 'package:flutter/material.dart';
import 'package:thue_san_the_thao_1/widget/booking_service.dart';

class DetailBookingField extends StatefulWidget {
  final int selectedField;
  final DateTime selectedDate;
  final List<String> selectedTimes;

  DetailBookingField({
    required this.selectedField,
    required this.selectedDate,
    required this.selectedTimes,
  });

  @override
  _DetailBookingFieldState createState() => _DetailBookingFieldState();
}

class _DetailBookingFieldState extends State<DetailBookingField> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  Map<String, int> selectedServices = {}; // key: serviceName, value: quantity
  final Map<String, int> servicePrices = {
    'Trứng luộc (Quả)': 7000,
    'Nhật Bóng (Giờ)': 30000,
    'Trà Chanh Ca (Ca)': 50000,
    'Trà Chanh Cốc (Cốc)': 25000,
  };

  int _getTotalQuantity() {
    return selectedServices.values.fold(0, (sum, value) => sum + value);
  }

  int _getTotalAmount() {
    int total = 0;
    selectedServices.forEach((name, quantity) {
      int price = servicePrices[name] ?? 0;
      total += quantity * price;
    });
    return total;
  }

  String _formatPrice(int amount) {
    return '${amount ~/ 1000}.000 đ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2973B2),
      appBar: AppBar(
        backgroundColor: Color(0xff2973B2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Đặt lịch',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // [A] Thông tin sân
            _buildCourtInfo(),

            SizedBox(height: 16),

            // [B] Thông tin đặt lịch
            _buildBookingInfo(),

            SizedBox(height: 16),

            // [C] Dịch vụ bổ sung
            _buildServiceInfo(),

            SizedBox(height: 16),

            // [D] Nút thêm dịch vụ
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingService(
                        selectedServices: Map.from(selectedServices),
                      ),
                    ),
                  );

                  if (result != null && result is Map<String, int>) {
                    setState(() {
                      selectedServices = result;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Thêm dịch vụ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // [E] Thông tin người dùng
            _buildCustomerInput(),

            SizedBox(height: 32),

            // [F] Nút tiếp theo
            _buildConfirmButton(),

            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildCourtInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin sân', style: _headerStyle()),
          SizedBox(height: 12),
          _infoRow('Tên sân:', 'Sân ${widget.selectedField}'),
          _infoRow('Địa chỉ:', '123 Đường ABC, Quận XYZ'),
          _infoRow('SĐT:', '0123456789'),
        ],
      ),
    );
  }

  Widget _buildBookingInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin đặt lịch', style: _headerStyle()),
          SizedBox(height: 12),
          _infoRow('Ngày:',
              '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}'),
          _infoRow('Thời gian:', widget.selectedTimes.join(', ')),
          Row(
            children: [
              Text('Tổng tiền: ', style: TextStyle(color: Colors.grey[600])),
              Text('${widget.selectedTimes.length * 100}.000 đ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceInfo() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shopping_cart_outlined, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text('Thông tin dịch vụ', style: _headerStyle()),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tổng dịch vụ: ${_getTotalQuantity()}",
                  style: TextStyle(fontSize: 14, color: Colors.black)),
              Text("Tổng tiền: ${_formatPrice(_getTotalAmount())}",
                  style: TextStyle(fontSize: 14, color: Colors.black)),
            ],
          ),
          SizedBox(height: 16),
          selectedServices.isEmpty
              ? Text("Chưa có dịch vụ nào được chọn",
              style: TextStyle(color: Colors.grey[600]))
              : Column(
            children: selectedServices.entries.map((entry) {
              final price = servicePrices[entry.key] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildServiceItem(
                  "x${entry.value}",
                  entry.key,
                  _formatPrice(entry.value * price),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputLabel("Họ và tên:"),
        _inputField(nameController),
        SizedBox(height: 16),
        _inputLabel("Số điện thoại:"),
        _inputField(phoneController, keyboardType: TextInputType.phone),
        SizedBox(height: 16),
        _inputLabel("Ghi chú:"),
        _inputField(noteController, maxLines: 3),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Xác nhận đặt lịch'),
              content: Text('Bạn có chắc chắn muốn đặt lịch này không?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đặt lịch thành công!')),
                    );
                  },
                  child: Text('Xác nhận'),
                ),
              ],
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Đặt lịch',
          style: TextStyle(
            color: Colors.blue[400],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widgets phụ
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          SizedBox(width: 4),
          Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _inputLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _inputField(TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildServiceItem(String quantity, String name, String price) {
    return Row(
      children: [
        Container(
          width: 30,
          child: Text(quantity, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ),
        Expanded(
          child: Text(name, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        ),
        Text(price, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }

  TextStyle _headerStyle() => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
}