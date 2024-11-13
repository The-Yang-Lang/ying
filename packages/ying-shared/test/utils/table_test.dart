import 'package:test/test.dart';
import 'package:ying_shared/utils/table.dart';
import 'package:ying_shared/utils/table/column_mapping.dart';
import 'package:ying_shared/utils/table/text_alignment.dart';

void main() {
  group('generateTable', () {
    group('invalid mappings', () {
      test(
        'it should throw an error when an empty map is given as mappings',
        () {
          expect(() {
            generateTable(
              mappings: {},
              rows: [],
              maximumWidth: 1,
            );
          }, throwsStateError);
        },
      );

      test(
        'it should throw an error when no displayable columns are left after removing empty columns',
        () {
          expect(() {
            generateTable(
              mappings: {
                "name": ColumnMapping(title: "Name"),
              },
              rows: [],
              maximumWidth: 1,
              removeEmptyColumns: true,
            );
          }, throwsStateError);
        },
      );
    });

    group('without header and footer', () {
      test('it should render a table with two columns and no data', () {
        final expected = """
┌──────┬─────┐
│ Name │ Age │
├──────┴─────┤
│ No entries │
└────────────┘
""";

        final result = generateTable(
          mappings: {
            "name": ColumnMapping(title: "Name"),
            "age": ColumnMapping(title: "Age"),
          },
          rows: [],
          maximumWidth: 14,
          emptyMessage: "No entries",
        );

        expect(result, expected.trim());
      });

      test(
        'it should render a table with two columns, one data row and enough space',
        () {
          final expected = """
┌──────────┬─────┐
│ Name     │ Age │
├──────────┼─────┤
│ John Doe │ 30  │
└──────────┴─────┘
""";

          final result = generateTable(
            mappings: {
              "name": ColumnMapping(title: "Name"),
              "age": ColumnMapping(title: "Age"),
            },
            rows: [
              {"name": "John Doe", "age": "30"},
            ],
            maximumWidth: 20,
          );

          expect(result, expected.trim());
        },
      );

      test(
        'it should render a table with two columns, one data row and not enough space',
        () {
          final expected = """
┌─────────┬────┐
│ Name    │ Ag │
│         │ e  │
├─────────┼────┤
│ John Do │ 30 │
│ e       │    │
└─────────┴────┘
""";

          final result = generateTable(
            mappings: {
              "name": ColumnMapping(title: "Name"),
              "age": ColumnMapping(title: "Age"),
            },
            rows: [
              {"name": "John Doe", "age": "30"},
            ],
            maximumWidth: 16,
          );

          expect(result, expected.trim());
        },
      );

      test(
        'it should render an expanded table with two columns, one data row',
        () {
          final expected = """
┌───────────────────┬────────┐
│ Name              │ Age    │
├───────────────────┼────────┤
│ John Doe          │ 30     │
└───────────────────┴────────┘
""";

          final result = generateTable(
            mappings: {
              "name": ColumnMapping(title: "Name"),
              "age": ColumnMapping(title: "Age"),
            },
            rows: [
              {"name": "John Doe", "age": "30"},
            ],
            maximumWidth: 30,
            expandToFullWidth: true,
          );

          expect(result, expected.trim());
        },
      );

      test(
        'it should render a table with two columns, two data rows and enough space',
        () {
          final expected = """
┌──────────┬─────┐
│ Name     │ Age │
├──────────┼─────┤
│ John Doe │ 30  │
├──────────┼─────┤
│ Jane Doe │ 30  │
└──────────┴─────┘
""";

          final result = generateTable(
            mappings: {
              "name": ColumnMapping(title: "Name"),
              "age": ColumnMapping(title: "Age"),
            },
            rows: [
              {"name": "John Doe", "age": "30"},
              {"name": "Jane Doe", "age": "30"},
            ],
            maximumWidth: 20,
          );

          expect(result, expected.trim());
        },
      );

      test('it should remove empty columns', () {
        var expected = """
┌──────────┬─────┐
│ Name     │ Age │
├──────────┼─────┤
│ John Doe │ 30  │
├──────────┼─────┤
│ Jane Doe │ 30  │
└──────────┴─────┘
""";

        var result = generateTable(
          mappings: {
            "name": ColumnMapping(title: "Name"),
            "age": ColumnMapping(title: "Age"),
            "dateOfBirth": ColumnMapping(title: "Date of birth"),
          },
          rows: [
            {
              "name": "John Doe",
              "age": "30",
              "dateOfBirth": "",
            },
            {
              "name": "Jane Doe",
              "age": "30",
              "dateOfBirth": "",
            },
          ],
          maximumWidth: 18,
          removeEmptyColumns: true,
        );

        expect(result, expected.trim());
      });
    });

    group('with header', () {
      test('it should generate a table without rows', () {
        var expected = """
┌────────────┐
│  Persons   │
├──────┬─────┤
│ Name │ Age │
├──────┴─────┤
│ No entries │
└────────────┘
""";

        var result = generateTable(
          mappings: {
            "name": ColumnMapping(title: "Name"),
            "age": ColumnMapping(title: "Age"),
          },
          rows: [],
          maximumWidth: 14,
          emptyMessage: "No entries",
          header: ColumnMapping(
            title: "Persons",
            alignment: TextAlignment.center,
          ),
        );

        expect(result, expected.trim());
      });
    });

    group('with footer', () {
      test('it should generate a table without rows', () {
        var expected = """
┌──────┬─────┐
│ Name │ Age │
├──────┴─────┤
│ No entries │
├────────────┤
│  Persons   │
└────────────┘
""";

        var result = generateTable(
          mappings: {
            "name": ColumnMapping(title: "Name"),
            "age": ColumnMapping(title: "Age"),
          },
          rows: [],
          maximumWidth: 14,
          emptyMessage: "No entries",
          footer: ColumnMapping(
            title: "Persons",
            alignment: TextAlignment.center,
          ),
        );

        expect(result, expected.trim());
      });

      test('it should generate a table with one row and two columns', () {
        var expected = """
┌──────────┐
│ Name     │
├──────────┤
│ John Doe │
├──────────┤
│ Persons  │
└──────────┘
""";

        var result = generateTable(
          mappings: {
            "name": ColumnMapping(title: "Name"),
          },
          rows: [
            {"name": "John Doe"},
          ],
          maximumWidth: 18,
          emptyMessage: "No entries",
          footer: ColumnMapping(
            title: "Persons",
            alignment: TextAlignment.center,
          ),
        );

        expect(result, expected.trim());
      });

      test('it should generate a table with one row and two columns', () {
        var expected = """
┌──────────┬─────┐
│ Name     │ Age │
├──────────┼─────┤
│ John Doe │ 30  │
├──────────┴─────┤
│    Persons     │
└────────────────┘
""";

        var result = generateTable(
          mappings: {
            "name": ColumnMapping(title: "Name"),
            "age": ColumnMapping(title: "Age"),
          },
          rows: [
            {"name": "John Doe", "age": "30"},
          ],
          maximumWidth: 18,
          emptyMessage: "No entries",
          footer: ColumnMapping(
            title: "Persons",
            alignment: TextAlignment.center,
          ),
        );

        expect(result, expected.trim());
      });
    });
  });
}
