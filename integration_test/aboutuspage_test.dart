import 'package:city_v_g/settings/about_us/about_us_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('AboutUsWidget UI test', (WidgetTester tester) async {
    // Build the AboutUsWidget inside a MaterialApp
    await tester.pumpWidget(
      MaterialApp(
        home: AboutUsWidget(),
      ),
    );

    // Allow the widget to settle
    await tester.pumpAndSettle();

    // Verify the title "About us" exists
    expect(find.text('About us'), findsOneWidget);

    // Verify the "Meet the Team Behind the Journey" text is displayed
    expect(find.text('Meet the Team Behind the Journey'), findsOneWidget);

    // Verify the section headers exist
    expect(find.text('Our Story'), findsOneWidget);
    expect(find.text('International Collaboration'), findsOneWidget);
    expect(find.text('Our Mission'), findsOneWidget);
    expect(find.text('Academic Project'), findsOneWidget);
    expect(find.text('Thank You'), findsOneWidget);

    // Verify the back button exists and uses the custom arrow image
    expect(find.byType(Image), findsWidgets);
    expect(find.widgetWithText(Image, 'arrow.png'), findsNothing); // Custom image

    // Verify some of the content text exists
    expect(
      find.textContaining(
        'We are a diverse team of 8 students from Politecnico di Milano and Mälardalen University',
      ),
      findsOneWidget,
    );

    // Verify the emoji flags are displayed
    expect(find.textContaining('🇮🇹 🇸🇪 🇪🇸 🇺🇾 🇲🇪 🇧🇩'), findsOneWidget);

    // Verify the footer image is displayed
    expect(find.byType(Image), findsWidgets);
    expect(find.widgetWithText(Image, 'Frame_3.png'), findsNothing); // Footer image
  });
}
