class LoginModel {
  final String response, token;
  final List<userDetail> result;

  LoginModel({this.response, this.token, this.result});

  factory LoginModel.fromJson(Map<String, dynamic> parsedJson){

    return LoginModel(
        response: parsedJson['response'].toString().trim(),
        token: parsedJson['token'].toString().trim(),
        result: parsedJson['result']
    //    result: userDetail.fromJson(parsedJson['images'])
    );
  }
}

  class userDetail {
  final String id, name, email, mobile;

  userDetail({this.id, this.name, this.email, this.mobile});

  factory userDetail.fromJson(Map<String, dynamic> parsedJson) {
    return userDetail(
        id: parsedJson['_id'].toString().trim(),
        name: parsedJson['name'].toString().trim(),
        email: parsedJson['email'].toString().trim(),
        mobile: parsedJson['mobile'].toString().trim());
  }
}
