import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:city_v_g/settings/suggest_ideas/suggest_ideas_widget.dart'; 

void main() {
  testWidgets('SuggestIdeasWidget UI Test', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: SuggestIdeasWidget(),
      ),
    );


    await tester.pumpAndSettle();

    // Verify the "Your Ideas" title is displayed
    expect(find.text('Your Ideas'), findsOneWidget);

    // Verify the introduction text
    expect(
      find.text(
          'Our travelers are our greatest testimony and your ideas and suggestions bring a huge impact to improving our business.'),
      findsOneWidget,
    );

    // Verify the suggestion text field exists
    expect(find.widgetWithText(TextFormField, 'Suggestion...'), findsOneWidget);

    // Verify the description text field exists
    expect(find.widgetWithText(TextFormField, 'Description...'), findsOneWidget);

    // Verify the "Add tags" label is displayed
    expect(find.text('Add tags'), findsOneWidget);

    // Verify chip tags are present
    expect(find.text('Product Design'), findsOneWidget);
    expect(find.text('Feature requirement'), findsOneWidget);
    expect(find.text('UI/UX improvement'), findsOneWidget);
    expect(find.text('Functionality'), findsOneWidget);
    expect(find.text('Marketing opportunities'), findsOneWidget);

    // Verify the "Submit Idea" button is displayed
    expect(find.text('Submit Idea'), findsOneWidget);
  });
}
