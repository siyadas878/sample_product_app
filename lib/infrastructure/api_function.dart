import 'dart:convert';
import 'package:http/http.dart' as http;

import '../domain/fake/fake.dart';
import '../domain/post_model/post_model.dart';

Future<List<Fake>> getApi() async {
  final response = await http.get(
    Uri.parse('https://fakestoreapi.com/products'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    final List<Fake> resultList =
        jsonData.map((data) => Fake.fromJson(data)).toList();
    return resultList;
  }

  return [];
}

Future<bool> postApi({required PostModel newdata}) async{

  try {
    final response =await http.post(Uri.parse('https://fakestoreapi.com/products'),body:jsonEncode( newdata.toJson()));
  if (response.statusCode==200) {
    print('result successful');
    return true; 
  }else{
    return false;
  }
  
  } catch (e) {
    print(e.toString());
    return false;
  }
}