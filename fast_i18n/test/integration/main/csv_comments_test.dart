import 'package:fast_i18n/builder/builder/build_config_builder.dart';
import 'package:fast_i18n/builder/decoder/csv_decoder.dart';
import 'package:fast_i18n/builder/generator_facade.dart';
import 'package:fast_i18n/builder/model/i18n_locale.dart';
import 'package:fast_i18n/builder/model/namespace_translation_map.dart';
import 'package:test/test.dart';

import '../../util/build_config_utils.dart';
import '../../util/resources_utils.dart';

void main() {
  late String compactInput;
  late String buildYaml;
  late String expectedOutput;

  setUp(() {
    compactInput = loadResource('main/csv_comments.csv');
    buildYaml = loadResource('main/build_config.yaml');
    expectedOutput = loadResource('main/expected_comments.output');
  });

  test('comments csv', () {
    final parsed = CsvDecoder().decode(compactInput);

    final result = GeneratorFacade.generate(
      buildConfig: BuildConfigBuilder.fromYaml(buildYaml)!.copyWith(
        renderLocaleHandling: false,
      ),
      baseName: 'translations',
      translationMap: NamespaceTranslationMap()
        ..addTranslations(
          locale: I18nLocale.fromString('en'),
          translations: parsed['en'],
        )
        ..addTranslations(
          locale: I18nLocale.fromString('de'),
          translations: parsed['de'],
        ),
    );

    expect(result.joinAsSingleOutput(), expectedOutput);
  });
}
