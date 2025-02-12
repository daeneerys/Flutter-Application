import 'package:http/http.dart' as http;
import 'dart:convert';

class DigimonApiService {
  Future<List<dynamic>> fetchDigimons() async {
    final response = await http.get(Uri.parse('https://digi-api.com/api/v1/digimon'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      // Print the response data to understand its structure
      print("Response Data: $data");

      // Check if the response contains a list under the 'content' key
      if (data.containsKey('content') && data['content'] is List) {
        // Return the first 5 Digimons
        return data['content'].take(5).toList();
      } else {
        throw Exception("Unexpected structure: 'content' key not found or not a list");
      }
    } else {
      throw Exception("Failed to load Digimons");
    }
  }
}