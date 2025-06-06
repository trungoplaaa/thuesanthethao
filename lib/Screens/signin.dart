import 'package:flutter/material.dart';
import 'package:thue_san_the_thao_1/Screens/signup.dart';
import 'package:thue_san_the_thao_1/mainscreen.dart';
import '../services/api/api_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();
  bool _isLoading = false;
  String? _errorMessage;

  // Thêm biến để kiểm soát ẩn/hiện mật khẩu
  bool _obscurePassword = true; // Ẩn mật khẩu mặc định

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _translateErrorMessage(String error) {
    String cleanError = error.replaceFirst('Exception: ', '');

    if (cleanError.toLowerCase().contains('invalid credentials') ||
        cleanError.toLowerCase().contains('wrong password') ||
        cleanError.toLowerCase().contains('incorrect password')) {
      return 'Tên đăng nhập hoặc mật khẩu không đúng';
    } else if (cleanError.toLowerCase().contains('user not found') ||
        cleanError.toLowerCase().contains('account not found')) {
      return 'Tài khoản không tồn tại';
    } else if (cleanError.toLowerCase().contains('network') ||
        cleanError.toLowerCase().contains('connection')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet';
    } else if (cleanError.toLowerCase().contains('timeout')) {
      return 'Hết thời gian chờ. Vui lòng thử lại';
    } else if (cleanError.toLowerCase().contains('server error') ||
        cleanError.toLowerCase().contains('internal server error')) {
      return 'Lỗi máy chủ. Vui lòng thử lại sau';
    } else if (cleanError.toLowerCase().contains('unauthorized')) {
      return 'Không có quyền truy cập';
    } else if (cleanError.toLowerCase().contains('forbidden')) {
      return 'Truy cập bị từ chối';
    } else if (cleanError.toLowerCase().contains('too many requests')) {
      return 'Quá nhiều lần thử. Vui lòng đợi một lúc';
    } else {
      return 'Đăng nhập thất bại. Vui lòng thử lại';
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        print('Attempting login with username: ${_usernameController.text}');
        await _apiService.authApi.login(
          _usernameController.text,
          _passwordController.text,
        );

        if (mounted) {
          print('Login successful, navigating to MainScreen');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng nhập thành công!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 2));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = _translateErrorMessage(e.toString());
          print('Đăng nhập thất bại: $_errorMessage');
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      print('Xác thực biểu mẫu không thành công');
    }
  }

  InputDecoration buildInputDecoration(String labelText) {
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
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Đăng nhập',
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
                    const Text('Chưa có tài khoản?'),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        ' Đăng ký',
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