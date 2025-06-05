import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tiket.dart';

class TiketService {
  final String baseUrl = 'https://firestore.googleapis.com/v1/projects/tiketpendakianapp/databases/(default)/documents/tiket_pendakian';


  Future<List<Tiket>> getTikets() async {
    print('Fetching tiket data...');
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Tiket> tikets = [];

      if (data['documents'] != null) {
        for (var doc in data['documents']) {
          final fields = doc['fields'];
          tikets.add(Tiket(
            id: doc['name'].split('/').last,
            namaPendaki: fields['namaPendaki']['stringValue'],
            gunung: fields['gunung']['stringValue'],
            tanggalPendakian: DateTime.parse(fields['tanggalPendakian']['timestampValue']),
            jumlahTiket: int.parse(fields['jumlahTiket']['integerValue']),
            statusPembayaran: fields['statusPembayaran']['stringValue'],
          ));
        }
      }
      print('Successfully fetched tiket data');
      return tikets;
    } else {
      print('Failed to fetch tiket data: ${response.body}');
      throw Exception('Gagal memuat tiket');
    }
  }

  Future<void> addTiket(Tiket tiket) async {
    print('Adding tiket: ${tiket.toJson()}');
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "fields": {
          "namaPendaki": {"stringValue": tiket.namaPendaki},
          "gunung": {"stringValue": tiket.gunung},
          "tanggalPendakian": {"timestampValue": tiket.tanggalPendakian.toUtc().toIso8601String()},
          "jumlahTiket": {"integerValue": tiket.jumlahTiket.toString()},
          "statusPembayaran": {"stringValue": tiket.statusPembayaran},
        }
      }),
    );

    if (response.statusCode == 200) {
      print('Tiket added successfully');
    } else {
      print('Failed to add tiket: ${response.body}');
      throw Exception('Gagal menambahkan tiket');
    }
  }

  Future<void> updateTiket(String id, Tiket tiket) async {
    final url = '$baseUrl/$id?updateMask.fieldPaths=namaPendaki&updateMask.fieldPaths=gunung&updateMask.fieldPaths=tanggalPendakian&updateMask.fieldPaths=jumlahTiket&updateMask.fieldPaths=statusPembayaran';
    print('Updating tiket with id $id: ${tiket.toJson()}');
    
    final response = await http.patch(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "fields": {
          "namaPendaki": {"stringValue": tiket.namaPendaki},
          "gunung": {"stringValue": tiket.gunung},
          "tanggalPendakian": {"timestampValue": tiket.tanggalPendakian.toUtc().toIso8601String()},
          "jumlahTiket": {"integerValue": tiket.jumlahTiket.toString()},
          "statusPembayaran": {"stringValue": tiket.statusPembayaran},
        }
      }),
    );

    if (response.statusCode == 200) {
      print('Tiket updated successfully');
    } else {
      print('Failed to update tiket: ${response.body}');
      throw Exception('Gagal mengupdate tiket');
    }
  }

  Future<void> deleteTiket(String id) async {
    final url = '$baseUrl/$id';
    print('Deleting tiket with id $id');

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Tiket deleted successfully');
    } else {
      print('Failed to delete tiket: ${response.body}');
      throw Exception('Gagal menghapus tiket');
    }
  }
}


// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/tiket.dart';

// class TiketService {
//   final String baseUrl = 'https://firestore.googleapis.com/v1/projects/tiketpendakianapp/databases/(default)/documents/tiket_pendakian';

//   Future<List<Tiket>> getTikets() async {
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       final List<Tiket> tikets = [];

//       if (data['documents'] != null) {
//         for (var doc in data['documents']) {
//           final fields = doc['fields'];
//           tikets.add(Tiket(
//             id: doc['name'].split('/').last,
//             namaPendaki: fields['namaPendaki']['stringValue'],
//             gunung: fields['gunung']['stringValue'],
//             tanggalPendakian: DateTime.parse(fields['tanggalPendakian']['timestampValue']),
//             jumlahTiket: int.parse(fields['jumlahTiket']['integerValue']),
//             statusPembayaran: fields['statusPembayaran']['stringValue'],
//           ));
//         }
//       }
//       return tikets;
//     } else {
//       throw Exception('Gagal memuat tiket');
//     }
//   }

//   Future<void> addTiket(Tiket tiket) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         "fields": {
//           "namaPendaki": {"stringValue": tiket.namaPendaki},
//           "gunung": {"stringValue": tiket.gunung},
//           "tanggalPendakian": {"timestampValue": tiket.tanggalPendakian.toIso8601String()},
//           "jumlahTiket": {"integerValue": tiket.jumlahTiket.toString()},
//           "statusPembayaran": {"stringValue": tiket.statusPembayaran},
//         }
//       }),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Gagal menambahkan tiket');
//     }
//   }

//   Future<void> updateTiket(String id, Tiket tiket) async {
//     final url = '$baseUrl/$id?updateMask.fieldPaths=namaPendaki&updateMask.fieldPaths=gunung&updateMask.fieldPaths=tanggalPendakian&updateMask.fieldPaths=jumlahTiket&updateMask.fieldPaths=statusPembayaran';
//     final response = await http.patch(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         "fields": {
//           "namaPendaki": {"stringValue": tiket.namaPendaki},
//           "gunung": {"stringValue": tiket.gunung},
//           "tanggalPendakian": {"timestampValue": tiket.tanggalPendakian.toIso8601String()},
//           "jumlahTiket": {"integerValue": tiket.jumlahTiket.toString()},
//           "statusPembayaran": {"stringValue": tiket.statusPembayaran},
//         }
//       }),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Gagal mengupdate tiket');
//     }
//   }

//   Future<void> deleteTiket(String id) async {
//     final url = '$baseUrl/$id';
//     final response = await http.delete(Uri.parse(url));
//     if (response.statusCode != 200) {
//       throw Exception('Gagal menghapus tiket');
//     }
//   }
// }


