class Tiket {
  final String id;
  final String namaPendaki;
  final String gunung;
  final DateTime tanggalPendakian;
  final int jumlahTiket;
  final String statusPembayaran;

  Tiket({
    required this.id,
    required this.namaPendaki,
    required this.gunung,
    required this.tanggalPendakian,
    required this.jumlahTiket,
    required this.statusPembayaran,
  });

  // Dari JSON (Map ke Tiket)
    factory Tiket.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'];
    return Tiket(
      id: json['name'].split('/').last,
      namaPendaki: fields['namaPendaki']['stringValue'],
      gunung: fields['gunung']['stringValue'],
      tanggalPendakian: DateTime.parse(fields['tanggalPendakian']['timestampValue']),
      jumlahTiket: int.parse(fields['jumlahTiket']['integerValue']),
      statusPembayaran: fields['statusPembayaran']['stringValue'],
    );
  }

  // factory Tiket.fromJson(Map<String, dynamic> json) {
  //   return Tiket(
  //     id: json['id'],
  //     namaPendaki: json['namaPendaki'],
  //     gunung: json['gunung'],
  //     tanggalPendakian: DateTime.parse(json['tanggalPendakian']),
  //     jumlahTiket: json['jumlahTiket'],
  //     statusPembayaran: json['statusPembayaran'],
  //   );
  // }

  // Ke JSON (Tiket ke Map)
    Map<String, dynamic> toJson() {
    return {
      "fields": {
        "namaPendaki": {"stringValue": namaPendaki},
        "gunung": {"stringValue": gunung},
        "tanggalPendakian": {
        "timestampValue": tanggalPendakian.toUtc().toIso8601String()},
        "jumlahTiket": {"integerValue": jumlahTiket.toString()},
        "statusPembayaran": {"stringValue": statusPembayaran},
      }
    };
  }
}

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "namaPendaki": namaPendaki,
//       "gunung": gunung,
//       "tanggalPendakian": tanggalPendakian.toIso8601String(),
//       "jumlahTiket": jumlahTiket,
//       "statusPembayaran": statusPembayaran,
//     };
//   }
// }
