class FasilitasModel {
  const FasilitasModel({
    required this.ac,
    required this.kamarMandiDalam,
    required this.wifi,
    required this.listrikInclude,
    required this.parkir,
    required this.dapur,
    required this.laundry,
    required this.security24Jam,
  });

  const FasilitasModel.empty()
    : ac = false,
      kamarMandiDalam = false,
      wifi = false,
      listrikInclude = false,
      parkir = false,
      dapur = false,
      laundry = false,
      security24Jam = false;

  final bool ac;
  final bool kamarMandiDalam;
  final bool wifi;
  final bool listrikInclude;
  final bool parkir;
  final bool dapur;
  final bool laundry;
  final bool security24Jam;

  factory FasilitasModel.fromJson(Map<String, dynamic> json) {
    return FasilitasModel(
      ac: _asBool(json['ac']),
      kamarMandiDalam: _asBool(json['kamar_mandi_dalam']),
      wifi: _asBool(json['wifi']),
      listrikInclude: _asBool(json['listrik_include']),
      parkir: _asBool(json['parkir']),
      dapur: _asBool(json['dapur']),
      laundry: _asBool(json['laundry']),
      security24Jam: _asBool(json['security_24jam']),
    );
  }

  List<String> get labels => [
    if (ac) 'AC',
    if (kamarMandiDalam) 'KM Dalam',
    if (wifi) 'Wi-Fi',
    if (listrikInclude) 'Listrik',
    if (parkir) 'Parkir',
    if (dapur) 'Dapur',
    if (laundry) 'Laundry',
    if (security24Jam) 'Security 24 Jam',
  ];

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value.toString().toLowerCase() == 'true';
  }
}
