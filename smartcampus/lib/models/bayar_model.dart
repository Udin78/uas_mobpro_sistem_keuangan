import 'package:smartcampus/models/tagihan_model.dart';

class BayarModel extends TagihanModel {
  BayarModel({
    String? id,
    String? namaTagihan,
    int? jumlahTagihan,
    String? tanggalTagihan,
    String? status,
  }) : super(
    id: id,
    namaTagihan: namaTagihan,
    jumlahTagihan: jumlahTagihan,
    tanggalTagihan: tanggalTagihan,
    status: status,
  );

  factory BayarModel.fromMap(Map<String, dynamic> map) {
    return BayarModel(
      id: map['id'],
      namaTagihan: map['namaTagihan'],
      jumlahTagihan: map['jumlahTagihan'],
      tanggalTagihan: map['tanggalTagihan'],
      status: map['status'],
    );
  }
}
