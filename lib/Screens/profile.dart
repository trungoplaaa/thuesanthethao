import 'package:flutter/material.dart';
import 'package:thue_san_the_thao_1/Screens/splash.dart';
import 'package:thue_san_the_thao_1/widget/change_password.dart';
import 'package:thue_san_the_thao_1/widget/change_profile.dart';

// Model lịch sử đặt sân
class BookingHistory {
  final String id;
  final String venueName;
  final String timeSlot;
  final String date;
  final String address;
  final String courtType;
  final bool isCompleted;

  BookingHistory({
    required this.id,
    required this.venueName,
    required this.timeSlot,
    required this.date,
    required this.address,
    required this.courtType,
    required this.isCompleted,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Dữ liệu mẫu - thay bằng dữ liệu thật từ API
  final List<BookingHistory> bookingHistoryList = [
    BookingHistory(
      id: '1',
      venueName: 'AVENUE by citisports',
      timeSlot: '7h - 7h30',
      date: 'Ngày 29/05/2025',
      address: 'Trung tâm Hội nghị quốc gia, đường Phạm Hùng, Hà Nội',
      courtType: 'Sân 6',
      isCompleted: false,
    ),
    BookingHistory(
      id: '2',
      venueName: 'Baca Pickleballs Nguyễn Chánh',
      timeSlot: '21h30 - 22h',
      date: 'Ngày 28/05/2025',
      address: 'Số 45 ngõ 29 phố Mạc Thái Tông, Cầu Giấy, Hà Nội',
      courtType: 'Pickleball 2',
      isCompleted: false,
    ),
    BookingHistory(
      id: '3',
      venueName: 'Sân Tennis Đông Đô',
      timeSlot: '19h - 20h',
      date: 'Ngày 27/05/2025',
      address: 'Số 123 đường Láng, quận Đống Đa, Hà Nội',
      courtType: 'Sân 1',
      isCompleted: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 30),
          _buildBookingHistory(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      decoration: const BoxDecoration(color: Color(0xFF4A90E2)),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dương Minh Đức',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '0994500123',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Cài đặt',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsCard(),
        ],
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.edit,
            text: 'Thay đổi thông tin',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChangeProfile()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.lock,
            text: 'Đổi mật khẩu',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
              );
            },
          ),
          const Divider(height: 1),
          _buildMenuItem(
            icon: Icons.logout,
            text: 'Đăng xuất',
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF4A90E2), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text, style: const TextStyle(fontSize: 15)),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingHistory() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lịch sử đặt sân:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: bookingHistoryList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildBookingCard(bookingHistoryList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(BookingHistory booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff2973B2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            booking.venueName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Chi tiết: ', style: TextStyle(color: Colors.white70)),
              Expanded(
                child: Text(
                  '${booking.courtType}: ${booking.timeSlot} | ${booking.date}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Địa chỉ: ', style: TextStyle(color: Colors.white70)),
              Expanded(
                child: Text(booking.address, style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Splash()),
                    (route) => false,
              );
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
