// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      uniqueID: json['uniqueID'] as String?,
      username: json['username'] as String? ?? '',
      picture: json['picture'] as String?,
      admin: json['admin'] as bool? ?? false,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'admin': instance.admin,
      'uniqueID': instance.uniqueID,
      'username': instance.username,
      'picture': instance.picture,
    };
