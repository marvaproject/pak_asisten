import 'package:flutter_test/flutter_test.dart';
import 'package:pak_asisten/presentation/app.dart';
import 'package:provider/provider.dart';
import 'package:pak_asisten/core/theme/theme_provider.dart';

void main() {
  testWidgets('Pak Asisten Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const PakAsisten(),
      ),
    );

    // Verify that the app builds without errors
    expect(find.byType(PakAsisten), findsOneWidget);
    
    // Add more specific tests based on your app's requirements
    // For example:
    // expect(find.byType(CustomAppBar), findsOneWidget);
    // expect(find.byType(CustomBottomNavBar), findsOneWidget);
  });
}