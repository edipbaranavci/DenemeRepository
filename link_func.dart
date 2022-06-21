import 'package:http/http.dart' as http;

List getTranslatedLinkAsList(String link) {
  List splitLink = link.split("/");

  if (checkLink(link) == true) {}

  return splitLink;
}

Future<bool> checkLink(String value) async {
  http.Response response = await http
      .get(Uri.parse(value), headers: {"Access-Control-Allow-Origin": "*"});

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
