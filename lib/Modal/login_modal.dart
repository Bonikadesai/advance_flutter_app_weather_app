class signUp {
  final String name;
  final String email;
  final String Password;
  signUp({
    required this.name,
    required this.email,
    required this.Password,
  });
}

class login {
  final String email;
  final String password;
  login({
    required this.email,
    required this.password,
  });
}

class forgetPassword {
  final String email;
  forgetPassword({required this.email});
}

//class UrlModel {PullToRefreshController? }
