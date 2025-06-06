import 'package:flutter/material.dart';

/// Model cho một lịch sử đặt sân
class BookingHistory {
  final String id;
  final String venueName;
  final String timeSlot;
  final String date;
  final String address;
  final String courtType;
  final bool isCompleted;
  final List<String> services;
  final int totalAmount;
  final String customerName;
  final String customerPhone;
  final String note;
  final DateTime createdAt;

  BookingHistory({
    required this.id,
    required this.venueName,
    required this.timeSlot,
    required this.date,
    required this.address,
    required this.courtType,
    required this.isCompleted,
    required this.services,
    required this.totalAmount,
    required this.customerName,
    required this.customerPhone,
    required this.note,
    required this.createdAt,
  });
}

/// Provider để quản lý danh sách lịch sử đặt sân
class BookingProvider extends ChangeNotifier {
  final List<BookingHistory> _bookingHistoryList = [
    BookingHistory(
      id: '1',
      venueName: 'AVENUE by citisports',
      timeSlot: '7h - 7h30',
      date: 'Ngày 29/05/2025',
      address: 'Trung tâm Hội nghị quốc gia, đường Phạm Hùng, quận Nam Từ Liêm, Hà Nội',
      courtType: 'Sân 6',
      isCompleted: false,
      services: ['Trứng luộc (2 quả)', 'Trà Chanh Cốc (1 cốc)'],
      totalAmount: 164000,
      customerName: 'Dương Minh Đức',
      customerPhone: '0994500123',
      note: 'Ghi chú mẫu',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BookingHistory(
      id: '2',
      venueName: 'Baca Pickleballs Nguyễn Chánh',
      timeSlot: '21h30 - 22h',
      date: 'Ngày 28/05/2025',
      address: 'Số 45 ngõ 29 phố Mạc Thái Tông, Trung Hòa, Cầu Giấy, Hà Nội',
      courtType: 'Pickleball 2',
      isCompleted: false,
      services: [],
      totalAmount: 100000,
      customerName: 'Dương Minh Đức',
      customerPhone: '0994500123',
      note: '',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<BookingHistory> get bookingHistoryList => _bookingHistoryList;

  /// Thêm lịch sử đặt sân mới
  void addBooking({
    required int selectedField,
    required DateTime selectedDate,
    required List<String> selectedTimes,
    required Map<String, int> selectedServices,
    required Map<String, int> servicePrices,
    required String customerName,
    required String customerPhone,
    required String note,
  }) {
    final int courtTotal = selectedTimes.length * 100000;

    int serviceTotal = 0;
    final List<String> serviceList = [];

    selectedServices.forEach((serviceName, quantity) {
      final price = servicePrices[serviceName] ?? 0;
      serviceTotal += quantity * price;
      serviceList.add('$serviceName ($quantity)');
    });

    final booking = BookingHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      venueName: 'Sân Thể Thao ABC',
      timeSlot: selectedTimes.join(', '),
      date: 'Ngày ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
      address: '123 Đường ABC, Quận XYZ',
      courtType: 'Sân $selectedField',
      isCompleted: false,
      services: serviceList,
      totalAmount: courtTotal + serviceTotal,
      customerName: customerName,
      customerPhone: customerPhone,
      note: note,
      createdAt: DateTime.now(),
    );

    _bookingHistoryList.insert(0, booking);
    notifyListeners();
  }

  /// Cập nhật trạng thái hoàn thành
  void updateBookingStatus(String id, bool isCompleted) {
    final index = _bookingHistoryList.indexWhere((item) => item.id == id);
    if (index != -1) {
      _bookingHistoryList[index] = BookingHistory(
        id: _bookingHistoryList[index].id,
        venueName: _bookingHistoryList[index].venueName,
        timeSlot: _bookingHistoryList[index].timeSlot,
        date: _bookingHistoryList[index].date,
        address: _bookingHistoryList[index].address,
        courtType: _bookingHistoryList[index].courtType,
        isCompleted: isCompleted,
        services: _bookingHistoryList[index].services,
        totalAmount: _bookingHistoryList[index].totalAmount,
        customerName: _bookingHistoryList[index].customerName,
        customerPhone: _bookingHistoryList[index].customerPhone,
        note: _bookingHistoryList[index].note,
        createdAt: _bookingHistoryList[index].createdAt,
      );
      notifyListeners();
    }
  }

  /// Xoá lịch sử theo ID
  void deleteBooking(String id) {
    _bookingHistoryList.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
