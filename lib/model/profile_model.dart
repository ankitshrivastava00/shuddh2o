
class ProfileModel {
  final String id, name,email,mobile,city,address,state;

  ProfileModel({this.id, this.name, this.email, this.mobile, this.city, this.address, this.state});

  factory ProfileModel.fromJson(Map<String, dynamic> parsedJson){

    return ProfileModel(
      id: parsedJson['_id'].toString().trim(),
      name: parsedJson['name'].toString().trim(),
      email: parsedJson['email'].toString().trim(),
      mobile: parsedJson['mobile'].toString().trim(),
      city: parsedJson['city'].toString().trim(),
      address: parsedJson['address'].toString().trim(),
      state: parsedJson['state'].toString().trim(),
    );
  }
}


