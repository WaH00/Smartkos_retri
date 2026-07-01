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
    this.additionalLabels = const [],
  });

  const FasilitasModel.empty()
    : ac = false,
      kamarMandiDalam = false,
      wifi = false,
      listrikInclude = false,
      parkir = false,
      dapur = false,
      laundry = false,
      security24Jam = false,
      additionalLabels = const [];

  final bool ac;
  final bool kamarMandiDalam;
  final bool wifi;
  final bool listrikInclude;
  final bool parkir;
  final bool dapur;
  final bool laundry;
  final bool security24Jam;
  final List<String> additionalLabels;

  factory FasilitasModel.fromDynamic(dynamic value) {
    if (value is Map) {
      return FasilitasModel.fromJson(Map<String, dynamic>.from(value));
    }
    if (value is List) {
      return FasilitasModel.fromLabels(
        value.map((item) => item.toString()).toList(),
      );
    }
    return const FasilitasModel.empty();
  }

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

  factory FasilitasModel.fromLabels(List<String> labels) {
    final normalized = labels.map(_normalize).toSet();
    final known = <String>{
      'ac',
      'kamar mandi dalam',
      'km dalam',
      'wifi',
      'wi fi',
      'listrik',
      'listrik include',
      'parkir',
      'parking',
      'dapur',
      'laundry',
      'security 24 jam',
      'security 24jam',
    };

    return FasilitasModel(
      ac: normalized.contains('ac'),
      kamarMandiDalam:
          normalized.contains('kamar mandi dalam') ||
          normalized.contains('km dalam'),
      wifi: normalized.contains('wifi') || normalized.contains('wi fi'),
      listrikInclude:
          normalized.contains('listrik') ||
          normalized.contains('listrik include'),
      parkir: normalized.contains('parkir') || normalized.contains('parking'),
      dapur: normalized.contains('dapur'),
      laundry: normalized.contains('laundry'),
      security24Jam:
          normalized.contains('security 24 jam') ||
          normalized.contains('security 24jam'),
      additionalLabels: labels
          .where((label) => !known.contains(_normalize(label)))
          .toList(),
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
    ...additionalLabels,
  ];

  static bool _asBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return value.toString().toLowerCase() == 'true';
  }

  static String _normalize(String value) => value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[_-]+'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ');
}
