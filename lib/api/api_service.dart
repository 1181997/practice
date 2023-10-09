import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:practice/api/posts_model.dart';

var base="https://dummyjson.com";


 getPost() async {
  try {
   // print("Making API request...");
    final res = await http.get(Uri.parse("$base/products")).timeout(Duration(seconds: 10));

    if (res.statusCode == 200) {
    //  print("API request successful");
      var data = postsModelFromJson(res.body);
      return data.products;
    } else {
      print("API request failed with status code: ${res.statusCode}");
    }
  } catch (e) {
    print("Error during API request: $e");
  }

}


postData() async {
  Uri url = Uri.parse("$base/products/add");

  var data = {
    'title': "abc",
    'price': 300.toString(),
  };
  var post = await http.post(url, body: data);

  try {
    if (post.statusCode == 200) {
      var jsonData = jsonDecode(post.body);
      print(jsonData);
      print("Data is Uploaded Successfully....");
    } else {
      print("Error During Posting Data");
    }
  } catch (e) {
    print(e.toString());
  }
}
