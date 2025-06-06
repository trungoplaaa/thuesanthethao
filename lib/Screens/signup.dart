import 'package:flutter/material.dart';
import 'package:thue_san_the_thao_1/Screens/signin.dart';
import 'package:thue_san_the_thao_1/services/api/api_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  // Thêm biến để kiểm soát ẩn/hiện mật khẩu
  bool _obscurePassword = true; // Ẩn mật khẩu mặc định
  bool _obscureConfirmPassword = true; // Ẩn xác nhận mật khẩu mặc định

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _translateErrorMessage(String error) {
    String cleanError = error.replaceFirst('Exception: ', '');

    if (cleanError.toLowerCase().contains('email already exists') ||
        cleanError.toLowerCase().contains('email đã được sử dụng')) {
      return 'Email đã được sử dụng';
    } else if (cleanError.toLowerCase().contains('username already exists')) {
      return 'Tên đăng nhập đã được sử dụng';
    } else if (cleanError.toLowerCase().contains('network') ||
        cleanError.toLowerCase().contains('connection')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet';
    } else if (cleanError.toLowerCase().contains('timeout')) {
      return 'Hết thời gian chờ. Vui lòng thử lại';
    } else if (cleanError.toLowerCase().contains('server error') ||
        cleanError.toLowerCase().contains('internal server error')) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau';
    } else if (cleanError.toLowerCase().contains('validation failed') ||
        cleanError.toLowerCase().contains('dữ liệu không hợp lệ')) {
      return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra lại thông tin';
    } else {
      return 'Đăng ký thất bại. Vui lòng thử lại';
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        print('Attempting register with username: ${_usernameController.text}');
        await _apiService.authApi.register(
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
        );

        if (mounted) {
          print('Register successful, navigating to SignInScreen');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = _translateErrorMessage(e.toString());
          print('Register failed: $_errorMessage');
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      print('Form validation failed');
    }
  }

  InputDecoration buildInputDecoration(String labelText, {bool isRequired = true}) {
    return InputDecoration(
      label: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: labelText,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isRequired)
              const TextSpan(
                text: '*',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
      hintText: 'Nhập ${labelText.toLowerCase()}',
      hintStyle: TextStyle(
        color: Colors.grey[600],
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[400]!, width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue[800]!, width: 2.0),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 40),
              Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: buildInputDecoration('Email'),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _usernameController,
                decoration: buildInputDecoration('Tên đăng nhập'),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên đăng nhập';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Sửa đổi TextFormField cho Mật khẩu với ẩn/hiện
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword, // Sử dụng biến để kiểm soát ẩn/hiện
                decoration: buildInputDecoration('Mật khẩu').copyWith(
                  // Thêm suffix icon để chuyển đổi ẩn/hiện
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword; // Chuyển đổi trạng thái
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải dài ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              // Sửa đổi TextFormField cho Xác nhận mật khẩu với ẩn/hiện
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword, // Sử dụng biến để kiểm soát ẩn/hiện
                decoration: buildInputDecoration('Xác nhận mật khẩu').copyWith(
                  // Thêm suffix icon để chuyển đổi ẩn/hiện
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword; // Chuyển đổi trạng thái
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu';
                  }
                  if (value != _passwordController.text) {
                    return 'Mật khẩu không khớp';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: buildInputDecoration('Số điện thoại', isRequired: false),
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                      return 'Số điện thoại không hợp lệ (10-11 số)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Đăng ký',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Đã có tài khoản?'),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()),
                        );
                      },
                      child: Text(
                        ' Đăng nhập',
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}