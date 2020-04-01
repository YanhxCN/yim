import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yim/common/git_api.dart';
import 'package:yim/common/global.dart';
import 'package:yim/model/user.dart';
import 'package:yim/states/profile_change_notifier.dart';
import 'package:yim/widget/widget_utils.dart';

class LoginRoute extends StatefulWidget {
  @override
  _LoginRouteState createState() => _LoginRouteState();
}

class _LoginRouteState extends State<LoginRoute> {

  TextEditingController _accountController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  bool pwdShow = false; //密码是否显示明文
  bool _autoFocus = true;

  @override
  void initState() {
    super.initState();
    // 自动填充上次登录的用户名，填充后将焦点定位到密码输入框
    _accountController.text = Global.profile.lastLogin;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: _autoFocus,
                controller: _accountController,
                decoration: InputDecoration(
                  labelText: '账号',
                  hintText: '请输入ID/Email',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                autofocus: !_autoFocus,
                controller: _pwdController,
                decoration: InputDecoration(
                    labelText: '密码',
                    hintText: '请输入密码',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    )),
                obscureText: !pwdShow,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _onLogin,
                    textColor: Colors.white,
                    child: Text('登录'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    // 提交前，先验证各个表单字段是否合法
    if ((_formKey.currentState as FormState).validate()) {
      showLoading(context);
      User user;
      try {
        user = await Git(context).login(_accountController.text, _pwdController.text);
        // 因为登录页返回后，首页会build，所以我们传false，更新user后不触发更新
        Provider.of<UserModel>(context, listen: false).user = user;
      } catch (e) {
        //登录失败则提示
        print(e);
        if (e.response?.statusCode == 401) {
          showToast('账号或密码错误');
        } else {
          showToast(e.toString());
        }
      } finally {
        // 隐藏loading框
        Navigator.of(context).pop();
      }
      if (user != null) {
        // 返回
        Navigator.of(context).pop();
      }
    }
  }

}