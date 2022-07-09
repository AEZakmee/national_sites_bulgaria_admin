import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable(explicitToJson: true)
class AppUser {
  bool admin;
  String? uniqueID;
  @JsonKey(defaultValue: '')
  String username;
  String? picture;

  AppUser({
    required this.uniqueID,
    this.username = '',
    this.picture,
    this.admin = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}
