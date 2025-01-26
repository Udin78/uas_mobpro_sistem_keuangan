class TagihanModel {
  String? id;
  String? namaTagihan;
  int? jumlahTagihan;
  String? tanggalTagihan;
  String? status;
  String? tanggalPembayaran;

  TagihanModel({
    this.id,
    this.namaTagihan,
    this.jumlahTagihan,
    this.tanggalTagihan,
    this.status = 'Belum Lunas',
    this.tanggalPembayaran,
  });

  factory TagihanModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return TagihanModel(
      id: id ?? map['id'],
      namaTagihan: map['namaTagihan'],
      jumlahTagihan: map['jumlahTagihan'],
      tanggalTagihan: map['tanggalTagihan'],
      status: map['status'] ?? 'Belum Lunas',
      tanggalPembayaran: map['tanggalPembayaran'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'namaTagihan': namaTagihan,
      'jumlahTagihan': jumlahTagihan,
      'tanggalTagihan': tanggalTagihan,
      'status': status,
      'tanggalPembayaran': tanggalPembayaran,
    };
  }
}
