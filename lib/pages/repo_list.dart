// import 'dart:js';

// import 'package:api_deneme/link_func.dart';
// import 'package:api_deneme/models/repo.dart';
// import 'package:api_deneme/pages/user_info.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:dio/dio.dart';

// class RepoList extends StatefulWidget {
//   const RepoList({Key? key}) : super(key: key);

//   @override
//   State<RepoList> createState() => _RepoListState();
// }

// class _RepoListState extends State<RepoList> {
//   late Future<AllRepos>? futureRepo;
//   late Future<Tree> _treeInfo;

//   @override
//   void initState() {
//     super.initState();
//     futureRepo = fetchRepos();
//     _treeInfo = getResForRepoList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController linkController = TextEditingController();
//     @override
//     void initState() {
//       super.initState();
//       linkController.text = "";
//     }

//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text("github api deneme 1"),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (builder) => const UserInfo()));
//               },
//               icon: const Icon(Icons.account_circle)),
//           IconButton(
//             onPressed: () {
//               getTranslatedLinkAsList(linkController.text);
//             },
//             icon: const Icon(Icons.replay),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: Column(
//           children: [
//             TextField(
//               // textInputAction: TextInputAction.done,
//               onSubmitted: (link) {
//                 // enter tuşu ile tetiklenir
//                 // List splitLink = link.split("/");
//                 setState(() {
//                   linkController.text = link;
//                   getTranslatedLinkAsList(link);
//                 });
//               },
//               controller: linkController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Project Link',
//               ),
//             ),
//             IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
//             Flexible(
//               child: Row(children: [
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: Container(
//                       color: Colors.red[200],
//                       padding: const EdgeInsets.all(10.0),
//                       child: getFileList(),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: Container(
//                       color: Colors.green[200],
//                       padding: const EdgeInsets.all(10.0),
//                       child: getSourceCode(),
//                     ),
//                   ),
//                 ),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<AllRepos> fetchRepos() async {
//     final response = await http
//         .get(Uri.parse('https://api.github.com/users/MuazzezA/repos'));

//     if (response.statusCode == 200) {
//       return AllRepos.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Exception in fetchRepos');
//     }
//   }

//   FutureBuilder getSourceCode() {
//     return FutureBuilder(
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           return Center(child: Text("dio denemesi\n\n" + snapshot.data));
//         } else if (snapshot.hasError) {
//           return const Center(child: Text("ups! küçük bir hata var"));
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//       future: getResponse(),
//     );
//   }

//   Future<String> getResponse() async {
//     Response<dynamic> response;
//     var dio = Dio();

//     response = await dio.get(
//         'https://raw.githubusercontent.com/MuazzezA/Automata_Theory/main/MealyMachine/Main.java');

//     return response.toString();
//   }

//   FutureBuilder getFileList() {
//     return FutureBuilder(
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           return Center(
//               child: Text(
//             "Repo Files\n\n" +
//                 snapshot.data!.url +
//                 "\n" +
//                 snapshot.data.rpFile.toString(),
//           ));
//         } else if (snapshot.hasError) {
//           dynamic err = snapshot.error;
//           return Center(child: Text("Error in getFileList " + err));
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//       future: getResForRepoList(),
//     );
//   }

//   Future<Tree> getResForRepoList() async {
//     final response = await http.get(Uri.parse(
//         'https://api.github.com/repos/MuazzezA/Icon_Creator/git/trees/main?recursive=1'));

//     if (response.statusCode == 200) {
//       return Tree.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('Exception in getResForRepoList');
//     }
//   }

//   FutureBuilder buildRepoList() {
//     return FutureBuilder<AllRepos>(
//       future: futureRepo,
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           List<Repo> repos = <Repo>[];

//           for (int i = 0; i < snapshot.data!.repos!.length; i++) {
//             repos.add(Repo(
//               name: snapshot.data!.repos![i].name,
//               description: snapshot.data!.repos![i].description,
//               html_url: snapshot.data!.repos![i].html_url,
//             ));

//             print("repos length : " + repos.length.toString());
//             return ListView.builder(
//                 itemCount: repos.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   repos
//                       .map((e) => Card(
//                             color: Colors.blueGrey[100],
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Text(e.name! + "\n"),
//                                 Text("Description " + e.description!),
//                                 Text(e.html_url == null
//                                     ? 'Html ${e.html_url}'
//                                     : 'html url'),
//                               ],
//                             ),
//                           ))
//                       .toList();
//                   return const Text("data"); // EKRANA DATA YAZDIRDI
//                 });
//           }
//         } else if (snapshot.hasError) {
//           return const Center(child: Text('has error '));
//         } else {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return const Center(child: Text('error'));
//       },
//     );
//   }
// }
