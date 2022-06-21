import 'package:api_deneme/models/repo.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserInfo extends StatefulWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  late Future<User> _userInfo;
  late User user;
  @override
  void initState() {
    super.initState();

    _userInfo = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('USER INFO'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Center(
          child: Flexible(
            //child: getUserInfoFromLocal(),
            child: getUserInfo(),
          ),
        ),
      ),
    );
  }

  FutureBuilder getUserInfo() {
    return FutureBuilder<User>(
        future: _userInfo,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  foregroundImage: NetworkImage(snapshot.data!.avatarUrl!),
                ),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("user name : " + snapshot.data!.userName!),
                      Text("user nick : " + snapshot.data!.login!),
                      Text("repo count : " +
                          snapshot.data!.publicRepoCount!.toString()),
                    ]),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Text("ups! user info - küçük bir hata var"));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<User> fetchUser() async {
    final response =
        await http.get(Uri.parse('https://api.github.com/users/MuazzezA'));

    if (response.statusCode == 200) {
      setState(() {
        user = User.fromJson(json.decode(response.body));
      });
      return user; // user.userName artık erişilebilir
    } else {
      throw Exception('failed in fetchUser');
    }
  }
}
