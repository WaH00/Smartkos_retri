import 'package:flutter_test/flutter_test.dart';
import 'package:smartkos_mobile/app/data/models/search_response_model.dart';

void main() {
  test('parses FastAPI search response contract', () {
    final response = SearchResponseModel.fromJson({
      'status': 'success',
      'query_original': 'kos putri dekat kampus wifi',
      'query_preprocessed': 'kos putri dekat kampus wifi',
      'query_expanded': 'kos putri dekat kampus wifi kamar bersih nyaman',
      'expansion_terms': ['kamar', 'bersih', 'nyaman'],
      'total_candidates': 20,
      'search_time_ms': 187.4,
      'total_results': 1,
      'super_deal_count': 1,
      'results': [
        {
          'id_kos': 1,
          'nama_kos': 'Kos Melati',
          'kota': 'Jakarta Selatan',
          'wilayah': 'Kebayoran Baru',
          'foto_path': 'kos/melati.jpg',
          'harga_per_bulan': 1500000,
          'predicted_price': 2000000,
          'distance_km': 1.2,
          'final_score': 0.91,
          'semantic_score': 0.88,
          'geospatial_score': 0.76,
          'price_boost': 1.0,
          'price_label': 'super_deal',
          'is_super_deal': true,
          'rating': 4.7,
          'fasilitas': {
            'ac': true,
            'kamar_mandi_dalam': true,
            'wifi': true,
            'listrik_include': false,
            'parkir': true,
            'dapur': true,
            'laundry': false,
            'security_24jam': true,
          },
        },
      ],
    });

    expect(response.status, 'success');
    expect(response.expansionTerms, ['kamar', 'bersih', 'nyaman']);
    expect(response.searchTimeMs, 187.4);
    expect(response.results.single.idKos, 1);
    expect(
      response.results.single.locationText,
      'Kebayoran Baru, Jakarta Selatan',
    );
    expect(response.results.single.discountPercent, 25);
    expect(response.results.single.facilityLabels, [
      'AC',
      'KM Dalam',
      'Wi-Fi',
      'Parkir',
      'Dapur',
      'Security 24 Jam',
    ]);
  });

  test('uses null-safe defaults for incomplete result data', () {
    final response = SearchResponseModel.fromJson({
      'status': 'success',
      'results': [
        {'id_kos': '7', 'fasilitas': null},
      ],
    });

    final kos = response.results.single;
    expect(kos.idKos, 7);
    expect(kos.namaKos, isEmpty);
    expect(kos.facilityLabels, isEmpty);
    expect(kos.discountPercent, 0);
  });
}
