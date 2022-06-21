import 'dart:js' as js;

import 'package:api_deneme/link_func.dart';
import 'package:api_deneme/models/repo_files.dart';
import 'package:api_deneme/services/json_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

List<String> pathList = ['MuazzezA', 'Icon_Creator']; // ad ve proje adı olacak
String nickAndProjectName = "MuazzezA/Icon_Creator";
String userName = "MuazzezA";

String branch = "/master/";
String clickFilePath = "icon_creator/lib/main.dart";

class _HomePageState extends State<HomePage> {
  TextEditingController linkController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  late Future<String> sourceCodeFetch = getSourceCodeResponse(
      fullPath: nickAndProjectName + branch + clickFilePath);

  late Future<Object> userInfoFetch = getUserInfoResponse(userName: userName);
  late Future<List<RepoInside>> treeFetch = fetchRepoInsideTree(
      nickAndProjectName: nickAndProjectName, branch: branch);

  Color outlineTextFieldColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      super.initState();
      linkController.text = "";
      sourceCodeFetch = getSourceCodeResponse(
          fullPath: nickAndProjectName + branch + clickFilePath);

      userInfoFetch = getUserInfoResponse(userName: userName);

      treeFetch = fetchRepoInsideTree(
          nickAndProjectName: nickAndProjectName, branch: branch);
    }

    // TÜM YÜKLER BU SCAFFOLDDA
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(child: getUserInfo()),
                // IconButton(
                //     onPressed: () {
                //       if (linkController.text != "" ||
                //           linkController.text.isNotEmpty) {
                //         getTranslatedLinkAsList(linkController.text);
                //       }
                //     },
                //     icon: const Icon(Icons.search)),
                Expanded(child: buildTextField()),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 4,
              color: Colors.blueGrey,
            ),
            buildCodeScreen(),
          ],
        ),
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Code Basic"),
      actions: [
        // IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (builder) =>
        //                   const RepoInsideList())); //repo_tree.dart
        //     },
        //     icon: const Icon(Icons.list_alt)), //çalışıyor
      ],
    );
  }

  buildTextField() {
    return TextField(
      // textInputAction: TextInputAction.done,
      // enter tuşu ile tetiklenir
      onSubmitted: (value) {
        setState(() {
          linkController.text = value;

          if (checkPath(value) == false) {
            print(pathList.toString() + " path not");

            setState(() {
              outlineTextFieldColor = Colors.red;
            });
          } // empty gelirse
          else {
            print(pathList.toString() + " truee is have");
            setState(() {
              pathList = getTranslatedLinkAsList(value);
              nickAndProjectName = pathList[0] + "/" + pathList[1];
              userName = pathList[0];
              userInfoFetch = getUserInfoResponse(userName: userName);
              sourceCodeFetch = getSourceCodeResponse(
                  fullPath: nickAndProjectName + branch + clickFilePath);
              treeFetch = fetchRepoInsideTree(
                  nickAndProjectName: nickAndProjectName, branch: branch);
              outlineTextFieldColor = Colors.green;
            });
          }
        });
      },
      controller: linkController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: outlineTextFieldColor, width: 1.0),
        ),
        labelText: 'User / ProjectName',
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.black,
        ),
      ),
    );
  }

  buildCodeScreen() {
    return Flexible(
      fit: FlexFit.loose,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                color: Colors.green[200],
                padding: const EdgeInsets.all(10.0),
                child: getSourceCode(), //String
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  getRepoInsideCodeFileList(), //future builder
                  // dosya listesi
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FutureBuilder getUserInfo() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (snapshot.data!.login != null) {
                    js.context.callMethod('open',
                        ['https://github.com/${snapshot.data!.login!}']);
                  } // avatara tıklanınca yeni sayfada github adresini açıyor
                },
                child: CircleAvatar(
                  radius: 25,
                  foregroundImage: NetworkImage(snapshot.data!.avatarUrl!),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data!.login!),
                    Text(snapshot.data!.userName!),
                    Text(snapshot.data!.publicRepoCount!.toString() + " repos"),
                  ]),
            ],
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("ups! küçük bir hata var"));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: getUserInfoResponse(userName: userName),
    );
  }

  FutureBuilder getSourceCode() {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return Center(
            child: Text(
              "Source Code\n\n" + snapshot.data,
              style: const TextStyle(fontSize: 12),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Text(
                  "ups! küçük bir hata var\n" + snapshot.error.toString()));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
      future: sourceCodeFetch,
    );
  }

  RegExp exp = RegExp(r'(\.dart$)'); // c ye göre yapılacak
  String? pathInTree;

  FutureBuilder getRepoInsideCodeFileList() {
    return FutureBuilder<List<RepoInside>>(
      future: treeFetch, // blob olan tüm dosyalar && dart türündekiler
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<RepoInside>? codeFileData = <RepoInside>[];
          String str;
          for (int i = 0; i < snapshot.data!.length; ++i) {
            str = snapshot.data![i].path.toString();

            try {
              //str exp içeriyorsa

              if (str.contains(exp) &&
                  snapshot.data![i].type.toString() == "Type.blob") {
                codeFileData.add(snapshot.data![i]);
              }
            } catch (e) {
              print("catch");
              continue;
            }
          }
          return _repoCodeFileListView(codeFileData);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  ListView _repoCodeFileListView(data) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return (_tile(
              data[index].path,
              data[index].type.toString(),
              Icons
                  .attach_file_sharp)); // path type ve size var - repoinside sınıfı içinde
        });
  }

  ListTile _tile(String path, String type, IconData icon) {
    return ListTile(
      onTap: () {
        print("tıklanan " + path);

        setState(() {
          clickFilePath = path;
          sourceCodeFetch = getSourceCodeResponse(
              fullPath: nickAndProjectName + branch + clickFilePath);
        });
      },
      title: Text(path,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(type),
      leading: Icon(
        icon,
        color: Colors.blueGrey[500],
      ),
    );
  }
}
