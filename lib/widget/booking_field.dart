import 'package:flutter/material.dart';
import 'package:thue_san_the_thao_1/widget/detail_booking_field.dart';

class BookingField extends StatefulWidget {
  @override
  _BookingFieldState createState() => _BookingFieldState();
}

class _BookingFieldState extends State<BookingField> {
  DateTime selectedDate = DateTime.now();
  int selectedField = 1;
  List<String> timeSlots = [
    '6:00-6:30', '6:30-7:00', '7:00-7:30', '7:30-8:00', '8:00-8:30', '8:30-9:00',
    '9:00-9:30', '9:30-10:00', '10:00-10:30', '10:30-11:00', '11:00-11:30', '11:30-12:00',
    '6:00-6:30', '6:30-7:00', '7:00-7:30', '7:30-8:00', '8:00-8:30', '8:30-9:00',
    '9:00-9:30', '9:30-10:00', '10:00-10:30', '10:30-11:00', '11:00-11:30', '11:30-12:00',
  ];
  List<bool> selectedTimeSlots = List.generate(24, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0,
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
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Date section
            Row(
              children: [
                // Chọn ngày
                GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(Duration(days: 1)),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );

                    if (picked != null && picked != selectedDate) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${selectedDate.day.toString().padLeft(2, '0')}/'
                              '${selectedDate.month.toString().padLeft(2, '0')}/'
                              '${selectedDate.year}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.calendar_today, size: 20),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // Nút xem bảng giá
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'xem sân & bảng giá',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Field selection
            Text(
              'chọn sân',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 1; i <= 4; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedField = i;
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedField == i ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$i',
                          style: TextStyle(
                            color: selectedField == i ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
              SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 5; i <= 8; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedField = i;
                      });
                    },
                    child: Container(
                      width: 60,
                      height: 40,
                      decoration: BoxDecoration(
                        color: selectedField == i ? Colors.blue[700] : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '$i',
                          style: TextStyle(
                            color: selectedField == i ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 20),

            // Time slots
            Text(
              'trạng thái giờ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                ),
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  Color backgroundColor;
                  if (index < 12) {
                    backgroundColor = selectedTimeSlots[index]
                        ? Colors.blue[800]!
                        : Colors.blue[300]!;
                  } else if (index >= 12 && index < 18) {
                    backgroundColor = Colors.red[400]!;
                  } else {
                    backgroundColor = selectedTimeSlots[index]
                        ? Colors.blue[800]!
                        : Colors.blue[300]!;
                  }

                  return GestureDetector(
                    onTap: () {
                      if (index < 12 || index >= 18) {
                        setState(() {
                          selectedTimeSlots[index] = !selectedTimeSlots[index];
                        });
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.white
                        )
                      ),
                      child: Center(
                        child: Text(
                          timeSlots[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'trống',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                SizedBox(width: 20),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'đã đặt',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Continue button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Get selected time slots
                  List<String> selectedTimes = [];
                  for (int i = 0; i < selectedTimeSlots.length; i++) {
                    if (selectedTimeSlots[i]) {
                      selectedTimes.add(timeSlots[i]);
                    }
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBookingField(
                        selectedField: selectedField,
                        selectedDate: selectedDate,
                        selectedTimes: selectedTimes,
                      ),
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
                  'Tiếp theo',
                  style: TextStyle(
                    color: Colors.blue[400],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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