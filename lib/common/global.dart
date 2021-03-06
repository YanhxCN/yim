
import 'dart:convert';

import 'package:dnetty/dnetty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yim/model/profile.dart';

import 'git_api.dart';

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();

  // 初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }

    // 初始化网络请求相关配置
    Git.init();
    // 初始化SocketClient
    SocketClient.instance.startClient("192.168.31.235", 5555, profile.user.id.toString(), "token_" + profile.user.id.toString());
  }

  // 持久化Profile信息
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}