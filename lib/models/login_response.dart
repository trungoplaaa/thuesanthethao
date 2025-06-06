class LoginResponse {
  final int statusCode;
  final String accessToken;

  LoginResponse({required this.statusCode, required this.accessToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'] as int,
      accessToken: json['access_token'] as String,
    );
  }
}