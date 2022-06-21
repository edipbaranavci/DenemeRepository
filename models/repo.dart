import 'dart:convert';

class User {
  String? userName; //name- full name
  String? login; //login- user nick
  String? avatarUrl; //avatar_url
  int? publicRepoCount;

  User({
    this.userName,
    this.login,
    this.avatarUrl,
    this.publicRepoCount,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['name'],
      login: json['login'],
      avatarUrl: json['avatar_url'], //https://github.com/[USER].png
      publicRepoCount: json['public_repos'],
    );
  }
}

class Repo {
  // bir repoya karşılık
  String? name; //repo name
  String? html_url;
  String? description;

  Repo({
    this.name,
    this.html_url,
    this.description,
  });

  factory Repo.fromJson(Map<String, dynamic> json) {
    return Repo(
      name: json['name'],
      html_url: json['html_url'],
      //stargazerCount: json['stargazerCount'],
      description: json['description'],
    );
  }
}

class AllRepos {
  List<Repo>? repos; // tüm repolar için liste

  AllRepos({this.repos});

  factory AllRepos.fromJson(List<dynamic> json) {
    List<Repo>? repos = <Repo>[];
    repos = json.map((e) => Repo.fromJson(e)).toList();
    return AllRepos(repos: repos);
  }
}

// "tree": [
//     {
//       "path": "icon_creator/lib",
//       "mode": "040000",
//       "type": "tree",
//       "sha": "62e6e25a63bf98d840ea6c5cb1a9b0b5a7964366",
//       "url": "https://api.github.com/repos/MuazzezA/Icon_Creator/git/trees/62e6e25a63bf98d840ea6c5cb1a9b0b5a7964366"
//     },
//     {
//       "path": "icon_creator/lib/main.dart",
//       "mode": "100644",
//       "type": "blob",
//       "sha": "0e6a3f73a39d619c2c65549298ea7d3ceb00d571",
//       "size": 415,
//       "url": "https://api.github.com/repos/MuazzezA/Icon_Creator/git/blobs/0e6a3f73a39d619c2c65549298ea7d3ceb00d571"
//     },
//     {
//      ...
//     },
// ]
class Tree {
  // dış json
  String url; //project file url
  List<RepoFile> rpFile = <RepoFile>[]; // tree içinde repo files var

  // tüm dosyalar tree içinde tutuluyor
  Tree({required this.rpFile, required this.url});

  factory Tree.fromJson(Map<String, dynamic> json) {
    final tempRpFile = json['tree'] as List<dynamic>;
    final treeList = tempRpFile
        .map((e) => RepoFile.fromJson(e))
        .toList(); // liste olduğu için RepoFile türünden alındı

    return Tree(rpFile: treeList, url: json['url']);
  }
}

class RepoFile {
  // iç json
  String? path;
  String? url; // file path
  String? type; //blob ise dosya, tree ise klasör

  RepoFile({this.path, this.url, this.type});

  factory RepoFile.fromJson(Map<String, dynamic> json) {
    return RepoFile(
      path: json['path'],
      url: json['url'],
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'url': url,
      'type': type,
    };
  }
}
