import 'package:StarTickera/models/profile_metadata_model.dart';
import 'package:test/test.dart';

void main() {
  group('parseFromMikrotiketNameString', () {
    test('Perfil válido', () {
      String input =
          'profile_nombre-se:hotspot1-co:123.0-pr:pre-lu:7-lp:7-ut:3d-00:00:00-bt:200-kt:true-nu:true-np:true-tp:1';
      var result = ProfileMetadata.parseFromMikrotiketNameString(input);

      expect(result.warnings, isEmpty);
      expect(result.profile!.hotspot, 'hotspot1');
      expect(result.profile!.price, 123.0);
      expect(result.profile!.prefix, 'pre');
      expect(result.profile!.userLength, 7);
      expect(result.profile!.passwordLength, 7);
      expect(result.profile!.usageTime, '3d-00:00:00');
      expect(result.profile!.dataLimit, 200);
      expect(result.profile!.durationType, DurationType.SaveTime);
      expect(result.profile!.isNumericUser, true);
      expect(result.profile!.isNumericPassword, true);
      expect(result.profile!.onLogin, isNotEmpty);
    });

    test('Perfil sin nombre válido', () {
      String input =
          'se:hotspot1-co:123.0-pr:pre-lu:7-lp:7-ut:3d-00:00:00-bt:200-kt:true-nu:true-np:true-tp:1';
      expect(
              () => ProfileMetadata.parseFromMikrotiketNameString(input),
          throwsA(isA<Exception>().having(
                  (e) => e.toString(), 'toString', contains('nombre del perfil'))));
    });

    // Agrega más casos de prueba según sea necesario para cubrir diferentes situaciones
  });

  group('parseDate', () {
    test('munutos', () {
      String input =
          'profile_nombre-se:hotspot1-co:123.0-pr:pre-lu:7-lp:7-ut:3d-00:00:00-bt:200-kt:true-nu:true-np:true-tp:1';
      var result = ProfileMetadata.parseFromMikrotiketNameString(input);

      expect(result.warnings, isEmpty);
      expect(result.profile!.hotspot, 'hotspot1');
      expect(result.profile!.price, 123.0);
      expect(result.profile!.prefix, 'pre');
      expect(result.profile!.userLength, 7);
      expect(result.profile!.passwordLength, 7);
      expect(result.profile!.usageTime, '3d-00:00:00');
      expect(result.profile!.dataLimit, 200);
      expect(result.profile!.durationType, DurationType.SaveTime);
      expect(result.profile!.isNumericUser, true);
      expect(result.profile!.isNumericPassword, true);
      expect(result.profile!.onLogin, isNotEmpty);
    });

    test('Perfil sin nombre válido', () {
      String input =
          'se:hotspot1-co:123.0-pr:pre-lu:7-lp:7-ut:3d-00:00:00-bt:200-kt:true-nu:true-np:true-tp:1';
      expect(
              () => ProfileMetadata.parseFromMikrotiketNameString(input),
          throwsA(isA<Exception>().having(
                  (e) => e.toString(), 'toString', contains('nombre del perfil'))));
    });

    // Agrega más casos de prueba según sea necesario para cubrir diferentes situaciones
  });
}
