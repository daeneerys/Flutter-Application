import 'package:http/http.dart' as http;
import 'dart:convert';

class DigimonApiService {
  Future<Map<String, dynamic>> fetchDigimonDetails(int id) async {
    final response = await http.get(Uri.parse('https://digi-api.com/api/v1/digimon/$id'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      // Debugging: Print the raw response to check its structure
      print("Raw Digimon Details Response: $data");

      // Extracting details
      String name = data['name'] ?? 'Unknown';
      bool xAntibody = data['xAntibody'] ?? false;
      String image = data['images']?.isNotEmpty ?? false
          ? data['images'][0]['href']
          : 'https://via.placeholder.com/150';

      String level = data['levels']?.isNotEmpty ?? false
          ? data['levels'][0]['level'] ?? 'Unknown'
          : 'Unknown';

      String attribute = data['attributes']?.isNotEmpty ?? false
          ? data['attributes'][0]['attribute'] ?? 'Unknown'
          : 'Unknown';

      String type = data['types']?.isNotEmpty ?? false
          ? data['types'][0]['type'] ?? 'Unknown'
          : 'Unknown';

      String field = data['fields']?.isNotEmpty ?? false
          ? data['fields'][0]['field'] ?? 'Unknown'
          : 'Unknown';

      String releaseDate = data['releaseDate'] ?? 'Unknown';

      // Fetch English description
      String description = 'No description available';
      if (data['descriptions'] != null && data['descriptions'] is List) {
        for (var desc in data['descriptions']) {
          if (desc['language'] == 'en_us') {
            description = desc['description'];
            break;
          }
        }
      }

      // Return the extracted data
      return {
        'id': id,
        'name': name,
        'xAntibody': xAntibody,
        'image': image,
        'level': level,
        'attribute': attribute,
        'type': type,
        'field': field,
        'releaseDate': releaseDate,
        'description': description,
      };
    } else {
      throw Exception("Failed to load Digimon details for ID: $id");
    }
  }

  Future<List<Map<String, dynamic>>> fetchMultipleDigimons(List<int> ids) async {
    List<Map<String, dynamic>> digimonList = [];

    for (int id in ids) {
      try {
        var digimonDetails = await fetchDigimonDetails(id);
        digimonList.add(digimonDetails);
      } catch (e) {
        print("Error fetching Digimon ID $id: $e");
      }
    }
    return digimonList;
  }
}
