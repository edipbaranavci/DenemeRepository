import 'dart:convert';

import 'package:api_deneme/models/repo_files.dart';
import 'package:api_deneme/services/json_service.dart';
import 'package:flutter/material.dart';

// RegExp exp = RegExp(r'(\.dart$)'); // c ye göre yapılacak
// String? pathInTree;

// FutureBuilder getRepoInsideCodeFileList(String? clickFilePath) {
//   return FutureBuilder<List<RepoInside>>(
//     future:
//         fetchRepoInsideTree(), // blob olan tüm dosyalar && dart türündekiler
//     builder: (BuildContext context, AsyncSnapshot snapshot) {
//       if (snapshot.hasData) {
//         List<RepoInside>? codeFileData = <RepoInside>[];
//         String str;
//         for (int i = 0; i < snapshot.data!.length; ++i) {
//           str = snapshot.data![i].path.toString();

//           try {
//             //str exp içeriyorsa

//             if (str.contains(exp) &&
//                 snapshot.data![i].type.toString() == "Type.blob") {
//               codeFileData.add(snapshot.data![i]);
//             }
//           } catch (e) {
//             print("catch");
//             continue;
//           }
//         }

//         return _repoCodeFileListView(codeFileData, clickFilePath);
//       } else if (snapshot.hasError) {
//         return Text("${snapshot.error}");
//       }
//       return const Center(child: CircularProgressIndicator());
//     },
//   );
// }

// ListView _repoCodeFileListView(data, String? clickFilePath) {
//   return ListView.builder(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       itemCount: data.length,
//       itemBuilder: (context, index) {
//         return _tile(
//             data[index].path,
//             data[index].type.toString(),
//             Icons.attach_file_sharp,
//             clickFilePath); // path type ve size var - repoinside sınıfı içinde
//       });
// }

// ListTile _tile(
//         String path, String type, IconData icon, String? clickFilePath) =>
//     ListTile(
//       onTap: () {
//         clickFilePath = path;
//       },
//       title: Text(path,
//           style: const TextStyle(
//             fontWeight: FontWeight.w500,
//             fontSize: 20,
//           )),
//       subtitle: Text(type),
//       leading: Icon(
//         icon,
//         color: Colors.blueGrey[500],
//       ),
//     );




/*

class RepoInsideList extends StatefulWidget {
  const RepoInsideList({Key? key}) : super(key: key);

  @override
  State<RepoInsideList> createState() => _RepoInsideListState();
}



class _RepoInsideListState extends State<RepoInsideList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Text('RepoInsideList'),
            Expanded(
              child: GestureDetector(
                child: getRepoInsideCodeFileList(),
                onTap: () {},
                //tıklandığında tıklanan dosyanın kodu ekrana gelmeli _tile fonksiyonunda
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/