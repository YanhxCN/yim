import 'package:json_annotation/json_annotation.dart';
import 'package:yim/model/user.dart';

part 'profile.g.dart';

@JsonSerializable()
class Profile {
  User user;
  String token;
  String lastLogin;
  Map<String,dynamic> license;

  Profile();

  factory Profile.fromJson(Map<String,dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}